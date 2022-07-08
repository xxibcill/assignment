
@react.component
let make = () => {

    let container = Emotion.css({
        "width": "30vh",
        "height": "60vh",
        "minWidth" : "300px",
        "minHeight" : "640px",
        "border": "solid 1px #dedede",
        "borderRadius": "4px"
    })

    let (state, setState) = React.useState(() => "0")

    <Utils.Provider value={(state, setState)}>
        <div className={container}>
            <DisplayPanel/>
            <ButtonPanel/>
        </div>
    </Utils.Provider>
}