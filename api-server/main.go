package main

import (
	"database/sql"
	"fmt"
	"log"
	"math"
	"net/http"
	"os"
	"sync"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

// user data
type User struct {
	Id            string `json:"id"`
	Username      string `json:"username"`
	Password      string `json:"password"`
	Profile_image string `json:"profile_image"`
	Joined_date   string `json:"joined_date"`
}

var (
	db   *sql.DB
	err  error
	once sync.Once
)

func main() {
	db = getDB()
	// insert_(db)

	r := gin.Default()
	r.Use(cors.Default())
	r.POST("/user", insertUsers)

	r.Run()
}

func insertUsers(c *gin.Context) {

	var user User
	e := c.BindJSON(&user)
	if e != nil {
		fmt.Println(e)
	}

	// [START cloud_sql_postgres_databasesql_connection]
	insertVote := "INSERT INTO Users VALUES($1,$2,$3,$4,$5)"

	_, err := db.Exec(insertVote, user.Id, user.Username, user.Password, user.Profile_image, user.Joined_date)
	// [END cloud_sql_postgres_databasesql_connection]

	if err != nil {
		log.Printf("saveVote: unable to save vote: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err})
	}
	c.JSON(http.StatusOK, gin.H{"message": "Success"})
}

func getVoteData(db *sql.DB) {
	fmt.Println("getVoteData")
	t := getAllUsers(db)
	if err != nil {
		log.Printf("renderIndex: failed to read current totals: %v", err)
		return
	}

	log.Printf("t: %v", t)
}

func insert_(db *sql.DB) {

	insertVote := "INSERT INTO votes(candidate, created_at) VALUES($1, NOW())"
	_, err := db.Exec(insertVote, "TABS")
	if err != nil {
		log.Printf("saveVote: unable to save vote: %v", err)
	}
}

// mustConnect creates a connection to the database based on environment
// variables. Setting the optional DB_CONN_TYPE environment variable to UNIX or
// TCP will use the corresponding connection method. By default, the connector
// is used.
func mustConnect() *sql.DB {
	fmt.Println("mustConnect")

	// Use a TCP socket when INSTANCE_HOST (e.g., 127.0.0.1) is defined
	fmt.Println(os.Getenv("INSTANCE_HOST"))
	if os.Getenv("INSTANCE_HOST") != "" {
		db, err = connectTCPSocket()
		if err != nil {
			log.Fatalf("connectTCPSocket: unable to connect: %s", err)
		}
	}

	// Use a Unix socket when INSTANCE_UNIX_SOCKET (e.g., /cloudsql/proj:region:instance) is defined.
	if os.Getenv("INSTANCE_UNIX_SOCKET") != "" {
		db, err = connectUnixSocket()
		if err != nil {
			log.Fatalf("connectUnixSocket: unable to connect: %s", err)
		}
	}

	// Use the connector when INSTANCE_CONNECTION_NAME (proj:region:instance) is defined.
	if os.Getenv("INSTANCE_CONNECTION_NAME") != "" {
		db, err = connectWithConnector()
		if err != nil {
			log.Fatalf("connectConnector: unable to connect: %s", err)
		}
	}

	if db == nil {
		log.Fatal("Missing database connection type. Please define one of INSTANCE_HOST, INSTANCE_UNIX_SOCKET, or INSTANCE_CONNECTION_NAME")
	}

	return db
}

// getDB lazily instantiates a database connection pool. Users of Cloud Run or
// Cloud Functions may wish to skip this lazy instantiation and connect as soon
// as the function is loaded. This is primarily to help testing.
func getDB() *sql.DB {
	once.Do(func() {
		db = mustConnect()
	})
	return db
}

func getAllUsers(db *sql.DB) []User {
	queryString := "SELECT * FROM USERS"
	row, err := db.Query(queryString)
	if err != nil {
		log.Fatal(err)
	}
	defer row.Close()

	result := []User{}

	for row.Next() { // Iterate and fetch the records from result cursor
		var id string
		var username string
		var password string
		var profile_image string
		var joined_date string
		row.Scan(&id, &username, &password, &profile_image, &joined_date)
		ingredient := User{id, username, password, profile_image, joined_date}
		result = append(result, ingredient)
	}

	return result
}

// currentTotals retrieves all voting data from the database.
func currentTotals(db *sql.DB) (int, error) {
	fmt.Println("currentTotals")

	var (
		count int
	)

	err := db.QueryRow("SELECT * FROM USERS").Scan(&count)
	if err != nil {
		return 0, fmt.Errorf("DB.QueryRow: %v", err)
	}

	log.Printf("tabs: %v", count)

	return count, nil
}

// formatMargin calculates the difference between votes and returns a human
// friendly margin (e.g., 2 votes)
func formatMargin(a, b int) string {
	diff := int(math.Abs(float64(a - b)))
	margin := fmt.Sprintf("%d votes", diff)
	// remove pluralization when diff is just one
	if diff == 1 {
		margin = "1 vote"
	}
	return margin
}

// vote contains a single row from the votes table in the database. Each vote
// includes a candidate ("TABS" or "SPACES") and a timestamp.
type vote struct {
	Candidate string
	VoteTime  time.Time
}

// recentVotes returns the last five votes cast.
func recentVotes(db *sql.DB) ([]vote, error) {
	rows, err := db.Query("SELECT candidate, created_at FROM votes ORDER BY created_at DESC LIMIT 5")
	if err != nil {
		return nil, fmt.Errorf("DB.Query: %v", err)
	}
	defer rows.Close()

	var votes []vote
	for rows.Next() {
		var (
			candidate string
			voteTime  time.Time
		)
		err := rows.Scan(&candidate, &voteTime)
		if err != nil {
			return nil, fmt.Errorf("Rows.Scan: %v", err)
		}
		votes = append(votes, vote{Candidate: candidate, VoteTime: voteTime})
	}
	return votes, nil
}
