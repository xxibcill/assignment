

let useDataConsumer = () => {
    let (data, setData) = React.useState(_ => [])

    let getUsers = () => {
        Axios.get("https://run-sql-xliijuge3q-dt.a.run.app/limit?limit=10", ())
        ->Promise.Js.toResult
        ->Promise.tapOk((res) => setData(res.data["users"]))
        ->Promise.tapError(err => {
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
        getUsers()
        None // or Some(() => {})
    })

    // Js.log(getUsers())

    // let prev = () => {
        
    // }

    // let next = () => {

    // }

    (data)
}