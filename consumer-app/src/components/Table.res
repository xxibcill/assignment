%%raw("require('./Table.css')")

@react.component
let make = () => {

    let (data,count,refresh,updateUser,deleteUser) = Utils.useDataController()

    <>
        <SideBar count refresh/>
        <table id="users">
            <thead>
                <tr>
                    <th>{"Avatar" -> React.string}</th>
                    <th>{"ID" -> React.string}</th>
                    <th>{"Username" -> React.string}</th>
                    <th>{"Password" -> React.string}</th>
                    <th>{"Joined Date" -> React.string}</th>
                    <th></th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                {data -> Belt.Array.map((user) => <Row updateUser deleteUser key={user["id"]} user/>) -> React.array}
            </tbody>
            // for pagination
            // <tfoot>
            //     <tr>
            //         <td>
            //             <TextButton >
            //                 { "prev" -> React.string }
            //             </TextButton>
            //         </td>
            //         <td></td>
            //         <td></td>
            //         <td>{ "1" -> React.string }</td>
            //         <td></td>
            //         <td></td>
            //         <td>
            //             <TextButton >
            //                 { "next" -> React.string }
            //             </TextButton>
            //         </td>
            //     </tr>
            // </tfoot>
        </table>
    </>

}