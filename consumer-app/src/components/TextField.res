@react.component
let make = (~onChange,~id,~value,~disabled=false) => {

    // make first char Uppercase while others lowercase
    let toHeaderText = (str) => (str -> Js.String2.get(0) -> Js.String2.toUpperCase) ++ (str -> Js.String2.toLowerCase -> Js.String.sliceToEnd(~from=1))

    <div className="textfield">
        <label>{ id -> toHeaderText -> React.string }</label>
        <input
            disabled
            onChange
            type_="text" 
            id
            name={id}
            value
        />
    </div>
}