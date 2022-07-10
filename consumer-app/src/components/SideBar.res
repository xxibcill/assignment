%%raw("require('./SideBar.css')")

@react.component
let make = (~count,~refresh) => {

    <div id="sidebar">
        <button id="refresh-button" onClick={_ => refresh()}>{"Refresh" -> React.string}</button>
        <div id="total-users">{"Total users :" -> React.string} <br/><span>{count -> React.int}</span></div>
    </div>
}