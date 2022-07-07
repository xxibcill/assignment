package main

import (
	"database/sql"
	"fmt"
	"log"
	"math"
	"os"
	"sync"
	"time"
)

var (
	db   *sql.DB
	err  error
	once sync.Once
)

func main() {
	db = getDB()
	insert_(db)
	getVoteData(db)
}

func getVoteData(db *sql.DB) {
	fmt.Println("getVoteData")
	t, err := currentTotals(db)
	if err != nil {
		log.Printf("renderIndex: failed to read current totals: %v", err)
		return
	}

	log.Printf("t: %v", t.VoteMargin)
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

	if db == nil {
		log.Fatal("Missing database connection type. Please define one of INSTANCE_HOST, INSTANCE_UNIX_SOCKET, or INSTANCE_CONNECTION_NAME")
	}

	if err := migrateDB(db); err != nil {
		log.Fatalf("unable to create table: %s", err)
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

// migrateDB creates the votes table if it does not already exist.
func migrateDB(db *sql.DB) error {
	createVotes := `CREATE TABLE IF NOT EXISTS votes (
		id SERIAL NOT NULL,
		created_at timestamp NOT NULL,
		candidate VARCHAR(6) NOT NULL,
		PRIMARY KEY (id)
	);`
	_, err := db.Exec(createVotes)
	return err
}

// votingData is used to pass data to the HTML template.
type votingData struct {
	TabsCount   int
	SpacesCount int
	VoteMargin  string
	RecentVotes []vote
}

// currentTotals retrieves all voting data from the database.
func currentTotals(db *sql.DB) (votingData, error) {
	fmt.Println("currentTotals")
	var (
		tabs   int
		spaces int
	)
	err := db.QueryRow("SELECT count(id) FROM votes WHERE candidate='TABS'").Scan(&tabs)
	if err != nil {
		return votingData{}, fmt.Errorf("DB.QueryRow: %v", err)
	}
	err = db.QueryRow("SELECT count(id) FROM votes WHERE candidate='SPACES'").Scan(&spaces)
	if err != nil {
		return votingData{}, fmt.Errorf("DB.QueryRow: %v", err)
	}

	recent, err := recentVotes(db)
	if err != nil {
		return votingData{}, fmt.Errorf("recentVotes: %v", err)
	}

	log.Printf("tabs: %v", tabs)
	log.Printf("spaces: %v", spaces)

	return votingData{
		TabsCount:   tabs,
		SpacesCount: spaces,
		VoteMargin:  formatMargin(tabs, spaces),
		RecentVotes: recent,
	}, nil
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
