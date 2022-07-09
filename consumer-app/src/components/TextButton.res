@react.component
let make = (~children:React.element,~color="#000000",~onClick) => {

    let buttonStyle = Emotion.css({
        "border": "0px",
        "padding": "8px",
        "cursor": "pointer",
        "borderRadius": "5px",
        "fontSize": "15px",
        "color": color ,
        "&:hover": {
            "backgroundColor": "#dedede",
        }
    })

    <button onClick className={buttonStyle}> {children} </button>
}