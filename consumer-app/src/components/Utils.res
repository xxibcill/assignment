
type contextType = (string, (string => string) => unit)
 
let initialValue:contextType = ("",(_) => ())
let context = React.createContext(initialValue)

module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
        React.createElement(provider, {"value": value, "children": children})
    }
}

let useCalculator = () => {
    React.useContext(context)
}
