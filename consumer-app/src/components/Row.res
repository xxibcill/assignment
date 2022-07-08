
type user = {
  "id": string,
  "username": string,
  "password": string,
  "profile_image": string,
  "joined_date": string,
};

@react.component
let make = (~user:user) => {

    let pfpContainer = Emotion.css({
        "display": "flex",
        "justifyContent": "center",
    })

    let pfp = Emotion.css({
        "width": "50px",
        "height": "50px",
        "borderRadius": "50%"
    })

    <tr>
        <td className={pfpContainer}>
            <img className={pfp} src={user["profile_image"]} alt="profile picture"/>
        </td>
        <td>{ user["id"] -> React.string }</td>
        <td>{ user["username"] -> React.string }</td>
        <td>{ user["password"] -> React.string }</td>
        <td>{ user["joined_date"] -> React.string }</td>
    </tr>
}