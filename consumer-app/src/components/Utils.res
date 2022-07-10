open Types

let useDataController = () => {
    let (data, setData) = React.useState(_ => [])
    let (count, setCount) = React.useState(_ => 0)

    // fetch all users from data store
    let fetchUsers = () => {
        Axios.get("https://run-sql-xliijuge3q-dt.a.run.app/all", ())
        -> Promise.Js.toResult
        -> Promise.tapOk((res) => setData(res.data["users"]))
        -> Promise.tapError(err => {
            switch (err.response) {
                | Some({status: 404}) => Js.log("Not found")
                | e => Js.log2("an error occured", e)
            }
        })
        ->ignore
    }

    // fetch number of users from data store
    let getCount = () => {
        Axios.get("https://run-sql-xliijuge3q-dt.a.run.app/count", ())
        -> Promise.Js.toResult
        -> Promise.tapOk((res) => setCount(res.data["count"]))
        -> Promise.tapError(err => {
            switch (err.response) {
                | Some({status: 404}) => Js.log("Not found")
                | e => Js.log2("an error occured", e)
            }
        })
        ->ignore
    }

    // get data from data store and update to local state
    let refresh = () => {
        // fetch new users data when delete succeed
        fetchUsers()
        // fetch number of user
        getCount()
    }

    // Runs only once right after mounting the component
    React.useEffect0(() => {
        // Run effects
        fetchUsers()
        // fetch number of user
        getCount()
        None
    })

    // delete 1 user indicate by id
    let deleteUser = (~id:string) => {
        let config = Axios.makeConfig(
            ~data={"id" :id},
            ()
        )
        Axios.delete("https://run-sql-xliijuge3q-dt.a.run.app/user", ~config, ())
            -> Promise.Js.toResult
            -> Promise.tapOk(({data}) => {
                Js.log(data)

                // update local state
                refresh()
            })
            ->ignore
    }

    // update 1 user indicate by id
    let updateUser = (data:updateUserType) => {
        let config = Axios.makeConfig(
            ()
        )
        Axios.patch("https://run-sql-xliijuge3q-dt.a.run.app/user",~data=data, ~config, ())
            -> Promise.Js.toResult
            -> Promise.tapOk(({data}) => {
                Js.log(data)

                // update local state
                refresh()
            })
            ->ignore
    }

    // functions for pagination
    // let prev = () => {
    // }

    // let next = () => {
    // }

    (data,count,refresh,updateUser,deleteUser)
}

// unwrap Option<string> to string
let unwrapOption = (opt) => {
    switch opt {
        | Some(n) => n
        | None => ""
    }
}

// format date function
let getShortMonthName = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
] -> Belt.Array.get

let dateString = (date) => Js.Date.getDate(date) -> Belt.Float.toString
let monthString = (date) => Js.Date.getMonth(date) -> Belt.Float.toInt -> getShortMonthName
let yearString = (date) => Js.Date.getFullYear(date) -> Belt.Float.toString
let formatDate = (date) => `${date -> dateString} ${date -> monthString -> unwrapOption} ${date -> yearString}`

