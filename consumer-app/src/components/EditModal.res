%%raw("require('./Modal.css')")

@react.component
let make = (~isOpen,~handleDelete,~handleCancel) => {
    <>
        {isOpen ? <div className="modal-container">
            <div className="modal-card">
                <h2>{"Delete Confirm?" -> React.string}</h2>
                <div className="button-group">
                    <TextButton onClick={(_) => handleDelete()}>
                        { "OK" -> React.string }
                    </TextButton>
                    <TextButton onClick={(_) => handleCancel()} color="red">
                        { "Cancel" -> React.string }
                    </TextButton>
                </div>
            </div>
        </div> : React.null}
    </>
}