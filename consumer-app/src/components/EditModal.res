%%raw("require('./Modal.css')")
open Types

@react.component
let make = (~isOpen,~handleEdit,~handleCancel,~handleChange,~editData,~userData) => {
    <>
        {isOpen ? <div className="modal-container">
            <div className="modal-card">
                <h2>{"Edit User" -> React.string}</h2>
                <form>

                    <TextField
                        disabled={true}
                        onChange={(_) => ()} 
                        id="id" 
                        value={userData["id"]}
                    />

                    <TextField
                        onChange={(e) => ("username" -> handleChange)(e)} 
                        id="username" 
                        value={editData.username}
                    />

                    <TextField
                        onChange={(e) => ("password" -> handleChange)(e)} 
                        id="password" 
                        value={editData.password}
                    />

                    <TextField
                        disabled={true}
                        onChange={(_) => ()} 
                        id="joineddate" 
                        value={userData["joined_date"]}
                    />
                </form>
                <div className="button-group">
                    <TextButton onClick={(_) => handleCancel()} color="red" backgroundColor="#ffffff">
                        { "Cancel" -> React.string }
                    </TextButton>
                    <TextButton onClick={(_) => handleEdit()} padding="8px 15px">
                        { "OK" -> React.string }
                    </TextButton>
                </div>
            </div>
        </div> : React.null}
    </>
}