open Types

type user = {
  "id": string,
  "username": string,
  "password": string,
  "profile_image": string,
  "joined_date": string,
};

let pfpContainer = Emotion.css({
    "display": "flex",
    "justifyContent": "center",
})

let pfp = Emotion.css({
    "width": "50px",
    "height": "50px",
    "borderRadius": "50%"
})

@react.component
let make = (~user:user,~updateUser,~deleteUser) => {

    let (isEditOpen, setEditOpen) = React.useState(_ => false)
    let (isDeleteOpen, setDeleteOpen) = React.useState(_ => false)
    let (editData, setEditData) = React.useState(_ => {username: "",password: ""})

    // Runs only once right after mounting the component
    React.useEffect0(() => {
        // Run effects
        setEditData(_ => {username: user["username"],password: user["password"]})
        None
    })

    let handleClickEdit = (_) => {
        setEditOpen(_ => true)
        Js.log("edit")
    }

    let handleclickDelete = (_) => {
        setDeleteOpen(_ => true)
    }

    let handleDelete = (_) => {
        deleteUser(~id=user["id"])
        setDeleteOpen(_ => false)
    }

    let handleEdit = (_) => {

        let data:updateUserType = {
            "id": user["id"],
            "username": editData.username,
            "password": editData.password
        }
        updateUser(data)
        setEditOpen(_ => false)
        Js.log(editData)
    }

    let handleCancel = (_) => {
        setDeleteOpen(_ => false)
        setEditOpen(_ => false)
    }

    let handleChange = (field:string,e) => {
        let updateData = switch field {
            | "username" => {...editData,username: ReactEvent.Form.target(e)["value"]}
            | "password" => {...editData,password: ReactEvent.Form.target(e)["value"]}
            | _ => editData
        }
        setEditData(_ => updateData)
    }

    <tr>
        <td className={pfpContainer}>
            <img className={pfp} src={user["profile_image"]} alt="profile picture"/>
        </td>
        <td>{ user["id"] -> React.string }</td>
        <td>{ user["username"] -> React.string }</td>
        <td>{ user["password"] -> React.string }</td>
        <td>{ user["joined_date"] -> Js.Date.fromString -> Utils.formatDate -> React.string }</td>
        <td>
            <TextButton onClick={handleClickEdit}>
                { "edit" -> React.string }
            </TextButton>
        </td>
        <td>
            <TextButton onClick={handleclickDelete} color="red">
                { "delete" -> React.string }
            </TextButton>
            <EditModal userData={user} editData handleChange handleCancel handleEdit isOpen={isEditOpen}/>
            <DeleteModal handleCancel handleDelete isOpen={isDeleteOpen}/>
        </td>
    </tr>
}