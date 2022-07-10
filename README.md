# Band Protocol | Full Stack Assignment

## Demo

data-generated app
https://provider.chayanin.dev

data-consumed app
https://consumer.chayanin.dev

#### This Project consist of 3 separated part

	1. Remote Data Store and API server
	2. Provider App : an app that generates data to provide to the data store
	3. Consumer App : an app that consumes data from the store and visualizes them in table

## 1. Remote Data Store and API server

- remote data is a **PostgreSQL** database deployed on **GCP Cloud SQL**
- API server written in **Go** using **Gin framework** deployed on **GCP Cloud Run**

### DB Table 

```sql
	CREATE TABLE USERS (
		id VARCHAR(100) NOT NULL, 
		username VARCHAR(100) NOT NULL, 
		password VARCHAR(100) NOT NULL, 
		profile_image VARCHAR(100) NOT NULL, 
		joined_date TIMESTAMP NOT NULL, 
		PRIMARY KEY (id), 
		UNIQUE(username) 
	);
```

### API Specification

#### 1. Get all users
get all of users sort by joined_date descending

```
method: GET
endpoint: https://run-sql-xliijuge3q-dt.a.run.app/all
```

request example
```shell
curl --location --request GET 'https://run-sql-xliijuge3q-dt.a.run.app/all'
```

result example 
```yaml
{
    "message": "Success",
    "method": "serveUsersAll",
    "users": [
        {
            "id": "usercl5cor2us000h3a6aqrf2uvqr",
            "username": "goldenmarine.net",
            "password": "Sierr1955",
            "profile_image": "https://api.lorem.space/image/face?w=150&h=150&hash=16cl57y0",
            "joined_date": "2022-01-16T12:27:45Z"
        },
        {
            "id": "usercl5cor7ov000n3a6aypf4hvje",
            "username": "Haskell.Hodkiewicz",
            "password": "qcg546hx8u",
            "profile_image": "https://api.lorem.space/image/face?w=150&h=150&hash=rhwjagbx",
            "joined_date": "2021-08-26T22:29:43Z"
        },
.
.
.
        {
            "id": "usercl5dmpupr000b3a6aoa9ypmtu",
            "username": "Viva.Wiegand50",
            "password": "t01vky760b",
            "profile_image": "https://api.lorem.space/image/face?w=150&h=150&hash=bka9ccl6",
            "joined_date": "2021-08-20T01:54:12Z"
        },
	]
}
```

#### 2. Get users limit

get limit number of users sort by joined_date descending

```
method: GET
endpoint: https://run-sql-xliijuge3q-dt.a.run.app/limit
params :
	limit: Integer
```

request example
```shell
curl --location --request GET 'https://run-sql-xliijuge3q-dt.a.run.app/limit?limit=10'
```

result example
```yaml
{
    "message": "Success",
    "method": "serveUsersLimit",
    "users": [
        {
            "id": "usercl5cor2us000h3a6aqrf2uvqr",
            "username": "goldenmarine.net",
            "password": "Sierr1955",
            "profile_image": "https://api.lorem.space/image/face?w=150&h=150&hash=16cl57y0",
            "joined_date": "2022-01-16T12:27:45Z"
        },
        {
            "id": "usercl5cor7ov000n3a6aypf4hvje",
            "username": "Haskell.Hodkiewicz",
            "password": "qcg546hx8u",
            "profile_image": "https://api.lorem.space/image/face?w=150&h=150&hash=rhwjagbx",
            "joined_date": "2021-08-26T22:29:43Z"
        },
.
.
.
        {
            "id": "usercl5dmpupr000b3a6aoa9ypmtu",
            "username": "Viva.Wiegand50",
            "password": "t01vky760b",
            "profile_image": "https://api.lorem.space/image/face?w=150&h=150&hash=bka9ccl6",
            "joined_date": "2021-08-20T01:54:12Z"
        },
	]
}
```

#### 3. Get number of user

get how many user in data store

```
method: GET
endpoint: https://run-sql-xliijuge3q-dt.a.run.app/count
```

request example
```shell
curl --location --request GET 'https://run-sql-xliijuge3q-dt.a.run.app/count?limit=10'
```

result example
```yaml
{
	"message": "Success"
    "count": 39,
}
```


#### 4.Add user

add user to data store

```
method: POST
endpoint: https://run-sql-xliijuge3q-dt.a.run.app/user
header: 'Content-Type: application/json'
data: {
	"id"
    "username"
    "password" 
    "profile_image"
    "joined_date"
}
```

request example

```shell
curl --location --request POST 'https://run-sql-xliijuge3q-dt.a.run.app/user' \
--header 'Content-Type: application/json' \
--data-raw '{
    "id": "usercl5c9zvq800013a6ash5wsh4o",
    "username": "Jeanie.Kovacek",
    "password": "ht4xrhjjf7",
    "profile_image": "https://api.lorem.space/image/face?w=150&h=150&hash=5khigtqx",
    "joined_date": "2021-06-08 11:22:30"
}'

```

result example
```yaml
{
    "message": "Success",
    "method": "insertUsers"
}
```


#### 5.Update user data

update user data indicate by id
can update only username nad password field

```
method: PATCH
endpoint: https://run-sql-xliijuge3q-dt.a.run.app/user
header: 'Content-Type: text/plain'
data: {
	"id"
    "username"
    "password" 
    "profile_image"
    "joined_date"
}
```

request example

```shell
curl --location --request PATCH 'https://run-sql-xliijuge3q-dt.a.run.app/user' \
--header 'Content-Type: text/plain' \
--data-raw '{
    "id": "usercl5cor2us000h3a6aqrf2uvqr",
    "username": "Jeanie.Cob",
    "password": "8UvGeyRD"
}'
```

result example

```yaml
{
    "message": "Success",
    "method": "updateUser"
}
```

#### 5.Delete User

Delete User from data store indicate by id

```
method: DELETE
endpoint: https://run-sql-xliijuge3q-dt.a.run.app/user
header: 'Content-Type: text/plain'
data: {
	"id"
}
```

request example

```shell
curl --location --request DELETE 'https://run-sql-xliijuge3q-dt.a.run.app/user' \
--header 'Content-Type: text/plain' \
--data-raw '{
    "id": "usercl5coqwnl00093a6avkbuw1pj"
}'
```

result example

```yaml
{
    "message": "Success",
    "method": "deleteUser"
}
```

## 2. Provider App : an app that generates data to provide to the data store

### Description 

React application which generates a mock user infomation each time you click on generate button.
-   user information contains:
	-   user_id
	-   username
	-   password
	-   profile_image
	-   joined_date
	- 
every time generated button got clicked, it generate user data all send to data store via insert API

clone from [bandprotocol/full-stack-assignment](https://github.com/bandprotocol/full-stack-assignment)

### To Start Server:

```shell
	cd provider-app
	yarn
	yarn dev
```

### Change log
- everytime user data generated. it call insert API to store data in remote data store.
- add UserView Component (made generated user data more readable).
- show number of user in data store.
- deployed

## 3. Consumer App : an app that consumes data from the store and visualizes them in table

### Description 

React Application using [Rescript](https://rescript-lang.org/) (rebranded from **BuckleScript** and **Reason**) a typed language that compiles to JavaScript.

this App consumes data from the store and visualizes them in table. you can edit username and password of user and can delete user

template from [xxibcill/rescript-react-example](https://github.com/xxibcill/rescript-react-example)

### To Start Server:

```shell
	cd consumer-app
	npm install
	npm run dev
```
