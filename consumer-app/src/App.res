let container = Emotion.css({
  "width": "100vw",
  "height": "100vh",
  "display": "flex",
  "justifyContent": "center",
  "alignItems": "center",
})


@react.component
let make = () => {
  <Theme.Provider value={Theme.initialValue}>
    <div className={container}>
      <Calculator/>
    </div>
  </Theme.Provider>
}