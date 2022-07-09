let container = Emotion.css({
  "minWidth": "100%",
  "minHeight": "100%",
  "padding": "30px 0px",
  "display": "flex",
  "justifyContent": "center",
  "alignItems": "center",
})


@react.component
let make = () => {
  <Theme.Provider value={Theme.initialValue}>
    <div className={container}>
      <Table/>
    </div>
  </Theme.Provider>
}