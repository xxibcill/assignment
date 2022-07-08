@react.component
let make = (~children , ~onClick=? ) => {
  // useTheme custom hook
  let theme = Theme.useTheme()

  let style = Emotion.css({
    "width": "59px",
    "height": "59px",
    "margin": "12px 8px",
    "fontSize": theme.fontSize.large,
    "backgroundColor": theme.pallete.grey,
    "border": "solid 1px #dedede",
    "borderRadius": "4px",
    "&:hover": {
      "backgroundColor": "#d8d8d8"
      "cursor": "pointer"
    }
  })

  <button ?onClick className={style}> children </button>
}