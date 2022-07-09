package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"
	"sync"

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

	r := gin.Default()
	r.Use(cors.Default())
	r.POST("/user", insertUsers)
	r.GET("/count", getUsersCount)
	r.GET("/all", serveUsersAll)
	r.GET("/limit", serveUsersLimit)
	r.PATCH("/user", updateUser)
	r.DELETE("/user", deleteUser)

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
		log.Printf("saveVote: unable to insert user: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err})
	}
	c.JSON(http.StatusOK, gin.H{"message": "Success", "method": "insertUsers"})
}

// mustConnect creates a connection to the database based on environment
// variables. Setting the optional DB_CONN_TYPE environment variable to UNIX or
// TCP will use the corresponding connection method. By default, the connector
// is used.
func mustConnect() *sql.DB {
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

func serveUsersLimit(c *gin.Context) {
	limit := c.DefaultQuery("limit", "50")
	users, err := getUsersLimit(db, limit)
	if err != nil {
		log.Printf("saveVote: unable to get user count: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err})
	}
	c.JSON(http.StatusOK, gin.H{"message": "Success", "method": "serveUsersLimit", "limit": limit, "users": users})
}

func serveUsersAll(c *gin.Context) {
	users, err := getAllUsers(db)
	if err != nil {
		log.Printf("saveVote: unable to get user count: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err})
	}
	c.JSON(http.StatusOK, gin.H{"message": "Success", "method": "serveUsersAll", "users": users})
}

func getAllUsers(db *sql.DB) ([]User, error) {
	queryString := "SELECT * FROM USERS order by joined_date desc"
	row, err := db.Query(queryString)
	if err != nil {
		log.Fatal(err)
		return []User{}, err
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

	return result, nil
}

func getUsersLimit(db *sql.DB, limit string) ([]User, error) {
	queryString := "SELECT * FROM USERS order by joined_date desc limit $1"

	row, err := db.Query(queryString, limit)
	if err != nil {
		log.Fatal(err)
		return []User{}, err
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

	return result, nil
}

func getUsersCount(c *gin.Context) {
	queryString := "SELECT count(*) FROM USERS"
	row, err := db.Query(queryString)
	if err != nil {
		log.Printf("saveVote: unable to get user count: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err})
	}
	defer row.Close()

	var count int
	row.Next()
	row.Scan(&count)

	if err != nil {
		log.Printf("saveVote: unable to get user count: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err})
	}
	c.JSON(http.StatusOK, gin.H{"message": "Success", "count": count})
}

func getUpdateQuery(user User) (querystring string) {
	querystring = "UPDATE USERS SET "

	if len(user.Username) > 0 {
		querystring = querystring + "username='" + user.Username + "', "
	}

	if len(user.Password) > 0 {
		querystring = querystring + "password='" + user.Password + "', "
	}

	// remove trailing comma
	if querystring[len(querystring)-2:len(querystring)-1] == "," {
		querystring = querystring[:len(querystring)-2]
	}

	return querystring + " WHERE id = $1"
}

func updateUser(c *gin.Context) {
	var user User
	e := c.BindJSON(&user)
	if e != nil {
		fmt.Println(e)
	}
	// check if id provided
	if len(user.Id) == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "id must be provided"})
	} else {
		querystring := getUpdateQuery(user)
		_, err := db.Exec(querystring, user.Id)

		if err != nil {
			log.Printf("saveVote: unable to update user: %v", err)
			c.JSON(http.StatusBadRequest, gin.H{"error": err})
		}
		c.JSON(http.StatusOK, gin.H{"message": "Success", "method": "updateUser"})
	}

}

func deleteUser(c *gin.Context) {
	var user User
	e := c.BindJSON(&user)
	if e != nil {
		fmt.Println(e)
	}

	// check if id provided
	if len(user.Id) == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "id must be provided"})
	} else {
		querystring := "DELETE FROM USERS WHERE id=$1"
		_, err := db.Exec(querystring, user.Id)

		if err != nil {
			log.Printf("saveVote: unable to delete user: %v", err)
			c.JSON(http.StatusBadRequest, gin.H{"error": err})
		}
		c.JSON(http.StatusOK, gin.H{"message": "Success", "method": "deleteUser"})
	}

}
