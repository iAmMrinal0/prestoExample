handleScreenAction = (state) => {
  switch (state.tag) {
    case "MainScreenInit":break;
    case "MainScreenAddToDo":
      appendChild(state.contents);
      break;
    case "MainScreenDeleteToDo":
      removeChild(state.contents);
      break;
    default: console.log("Invalid Tag Passed", state.tag);

  }
}

appendChild = (val) => {
    var todolist = document.getElementById("todolist")
    var div = document.createElement("div")
    var titleSpan = document.createElement("span")
    var buttonSpan = document.createElement("span")
    var p = document.createElement("p")
    var button = document.createElement("button")

    var date = val[1]
    var text = val[0]

    button.appendChild(document.createTextNode("Delete"))
    button.addEventListener("click", function() {
        var event = {
            tag: "RemoveTodo",
            contents: "todoid" + date
        }
        window.callBack(JSON.stringify(event))()})
    buttonSpan.appendChild(button)

    p.appendChild(document.createTextNode(text))
    titleSpan.appendChild(p)

    div.setAttribute("id","todoid"+date)
    div.appendChild(titleSpan)
    div.appendChild(buttonSpan)

    todolist.appendChild(div)
}

removeChild = (id) => {
    var todolist = document.getElementById("todolist");
    var elem = document.getElementById(id);
    todolist.removeChild(elem);
}

window.showScreen = function (callBack, data) {
    window.callBack = callBack;
    handleScreenAction(data);
};

document.getElementById("ADD_BUTTON").addEventListener("click", function () {
    var todo = document.getElementById("ADD_TODO").value;
    var event = {
                    tag:"AddToDo",
                    contents:todo
                };
    window.callBack(JSON.stringify(event))();
})
