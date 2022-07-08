 type target = {
    innerText: string
}

@react.component
let make = () => {
    let container = Emotion.css({
        "width": "auto",
        "height": "65%",
        "display": "grid",
        "gridTemplateColumns": "auto auto auto auto",
        "border": "solid 1px #f7f7f7",
        "borderRadius": "4px"
    })

    let (_, setState) = Utils.useCalculator()

    let handleClick = (value) => {
        setState(value)
    }
    
    <div className={container}>
        // 1st Row 
        <Button onClick={(_) => handleClick(_ => "AC")}> {"AC" -> React.string} </Button>
        <Button onClick={(_) => handleClick(_ => "clear")}> {"<=" -> React.string} </Button>
        <Button onClick={(_) => handleClick(_ => "Percentage")}> {"%" -> React.string} </Button>
        <Button onClick={(_) => handleClick(_ => "DIV")}> {`÷` -> React.string} </Button >
  
        // 2nd Row  
        <Button onClick={(_) => handleClick(_ => "7")}> {"7" -> React.string} </Button>
        <Button onClick={(_) => handleClick(_ => "8")}> {"8" -> React.string} </Button>
        <Button onClick={(_) => handleClick(_ => "9")}> {"9" -> React.string} </Button>
        <Button onClick={(_) => handleClick(_ => "MUL")}> {`×` -> React.string} </Button >
   
        // 3rd Row   
        <Button onClick={(_) => handleClick(_ => "4")}> {"4" -> React.string} </Button>
        <Button onClick={(_) => handleClick(_ => "5")}> {"5" -> React.string} </Button>
        <Button onClick={(_) => handleClick(_ => "6")}> {"6" -> React.string} </Button>
        <Button onClick={(_) => handleClick(_ => "SUB")}> {"-" -> React.string} </Button >
   
        // 4th Row   
        <Button onClick={(_) => handleClick(_ => "1")}> {"1" -> React.string} </Button>
        <Button onClick={(_) => handleClick(_ => "2")}> {"2" -> React.string} </Button>
        <Button onClick={(_) => handleClick(_ => "3")}> {"3" -> React.string} </Button>
        <Button onClick={(_) => handleClick(_ => "ADD")}> {"+" -> React.string} </Button >
   
        // 5th Row   
        <Button onClick={(_) => handleClick(_ => "EXP")}> {"e" -> React.string} </Button>
        <Button onClick={(_) => handleClick(_ => "0")}> {"0" -> React.string} </Button>
        <Button onClick={(_) => handleClick(_ => "DEC")}> {"." -> React.string} </Button>
        <Button onClick={(_) => handleClick(_ => "EXE")}> {"=" -> React.string} </Button>
    </div>
}