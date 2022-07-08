%%raw("require('./Table.css')")

type user = {
  "id": string,
  "username": string,
  "password": string,
  "profile_image": string,
  "joined_date": string,
};

@react.component
let make = () => {
    <table id="users">
        <thead>
            <tr>
                <th>{"Avatar" -> React.string}</th>
                <th>{"ID" -> React.string}</th>
                <th>{"Username" -> React.string}</th>
                <th>{"Password" -> React.string}</th>
                <th>{"Joined Date" -> React.string}</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            {MockData.data -> Belt.Array.map((user) => <Row user/>) -> React.array}
        </tbody>
    </table>
}