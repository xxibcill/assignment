%%raw("require('./Modal.css')")

@react.component
let make = (~isOpen,~handleDelete,~handleCancel) => {
    <>
        {isOpen ? <div className="modal-container">
            <div className="modal-card">
                <h2>{"Delete Confirm?" -> React.string}</h2>
                <div className="button-group">
                    <TextButton onClick={(_) => handleCancel()} color="red" backgroundColor="#ffffff">
                        { "Cancel" -> React.string }
                    </TextButton>
                    <TextButton onClick={(_) => handleDelete()} padding="8px 15px">
                        { "OK" -> React.string }
                    </TextButton>
                </div>
            </div>
        </div> : React.null}
    </>
}