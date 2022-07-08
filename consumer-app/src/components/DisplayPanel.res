@react.component
let make = () => {
    let container = Emotion.css({
        "display": "flex",
        "justifyContent": "flex-end",
        "alignItems": "flex-end",
        "width": "100%",
        "height": "35%",
        "backgroundColor": "salmon"
    })

    let display = Emotion.css({
        "width": "auto",
        "height": "auto",
        "overflowWrap": "break-word",
        "textAlign": "right",
        "fontSize": "35px",
        "margin": "20px",
    })

    let (state, _) = Utils.useCalculator()

    <div className={container}>
        <h1 className={display}>{state -> React.string}</h1>
    </div>
}