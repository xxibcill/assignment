let container = Emotion.css({
  "minWidth": "100vw",
  "minHeight": "100vh",
  "padding": "30px",
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