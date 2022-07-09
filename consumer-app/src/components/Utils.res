

let useDataController = () => {
    let (data, setData) = React.useState(_ => [])

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

    // Runs only once right after mounting the component
    React.useEffect0(() => {
        // Run effects
        fetchUsers()
        None
    })

    // delete 1 user indicate by id
    let deleteUser = (~id:string) => {
        let config = Axios.makeConfig(
            ~url="http://localhost",
            ~data={"id" :id},
            ()
        )
        Axios.delete("https://run-sql-xliijuge3q-dt.a.run.app/user", ~config, ())
            -> Promise.Js.toResult
            -> Promise.tapOk(({data}) => {
                Js.log(data)
                // fetch new users data when delete succeed
                fetchUsers()
            })
            ->ignore
    }

    // functions for pagination
    // let prev = () => {
        
    // }

    // let next = () => {

    // }

    (data,deleteUser)
}

