
type user = {
  "id": string,
  "username": string,
  "password": string,
  "profile_image": string,
  "joined_date": string,
};

@react.component
let make = (~user:user,~deleteUser) => {

    let pfpContainer = Emotion.css({
        "display": "flex",
        "justifyContent": "center",
    })

    let pfp = Emotion.css({
        "width": "50px",
        "height": "50px",
        "borderRadius": "50%"
    })

    let (isEditOpen, setEditOpen) = React.useState(_ => false)
    let (isDeleteOpen, setDeleteOpen) = React.useState(_ => false)

    let handleClickEdit = () => {
        setEditOpen(_ => true)
        Js.log("edit")
    }

    let handleclickDelete = (e) => {
        setDeleteOpen(_ => true)
    }

    let handleDelete = (e) => {
        deleteUser(~id=user["id"])
        setDeleteOpen(_ => false)
    }

    let handleCancel = (e) => {
        setDeleteOpen(_ => false)
        setEditOpen(_ => false)
    }

    <tr>
        <td className={pfpContainer}>
            <img className={pfp} src={user["profile_image"]} alt="profile picture"/>
        </td>
        <td>{ user["id"] -> React.string }</td>
        <td>{ user["username"] -> React.string }</td>
        <td>{ user["password"] -> React.string }</td>
        <td>{ user["joined_date"] -> React.string }</td>
        <td>
            <TextButton onClick={(_) => handleClickEdit()}>
                { "edit" -> React.string }
            </TextButton>
        </td>
        <td>
            <TextButton onClick={(_) => handleclickDelete()} color="red">
                { "delete" -> React.string }
            </TextButton>
            <EditModal handleCancel handleDelete isOpen={isEditOpen}/>
            <DeleteModal handleCancel handleDelete isOpen={isDeleteOpen}/>
        </td>
    </tr>
}