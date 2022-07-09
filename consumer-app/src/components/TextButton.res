@react.component
let make = (~children:React.element,~color="#000000",~backgroundColor="#f0f0f0",~padding="8px",~onClick) => {

    let buttonStyle = Emotion.css({
        "border": "0px",
        "padding": padding,
        "cursor": "pointer",
        "borderRadius": "5px",
        "fontSize": "15px",
        "color": color ,
        "backgroundColor": backgroundColor,
        "&:hover": {
            "backgroundColor": "#dedede",
        }
    })

    <button onClick className={buttonStyle}> {children} </button>
}