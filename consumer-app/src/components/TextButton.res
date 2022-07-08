@react.component
let make = (~children:React.element,~color="#000000") => {

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

    <button className={buttonStyle}> {children} </button>
}