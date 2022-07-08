
type colorPalleteType = {
    primary: string,
    secondary: string,
    grey: string,
}

type fontSizeType = {
    small: string,
    medium: string,
    large: string,
}

type contextType = {
    pallete: colorPalleteType,
    spacing: int => string,
    fontSize: fontSizeType
}

let initialValue = {
    pallete: {
        primary: "#f3443a",
        secondary: "#eb847d",
        grey: "#e7e7e7",
    },
    spacing: (x) => Belt.Int.toString(8*x) ++ "px",
    fontSize: {
        small: "0.875rem",
        medium: "1rem",
        large: "1.125rem",
    }
}

let context = React.createContext(initialValue)

module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
        React.createElement(provider, {"value": value, "children": children})
    }
}

let useTheme = () => {
    let theme = React.useContext(context)
    theme
}

