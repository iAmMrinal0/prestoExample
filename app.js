const handleScreenAction = (state) => {
  switch (state.tag) {
    case "MainScreenInit": initApp();break;
    case "MainScreenAddTodo":
      addTodo(state.contents);
      break;
    case "MainScreenDeleteTodo":
      deleteTodo(state.contents);
      break;
    case "MainScreenEditTodo":
      editTodo(state.contents)
      break;
    case "MainScreenUpdateTodo":
      updateTodo(state.contents)
      break;
    case "MainScreenError":
      console.log('This is the error: ', state.contents)
      break
    default: console.log("Invalid Tag Passed: ", state.tag);
  }
}

const initApp = () => {
  document.body.innerHTML = `
<div id="controller">
  <span>
  <h1 id="text">TO-DO LIST</h1>
  </span>
  <span>
    <input id="ADD_TODO" type="text"/>
    <button onclick="addTodoClick()">Click Me</button>
  </span>
</div>
<div id="todolist"></div>`
}

const addTodoClick = () => {
  var todo = document.getElementById("ADD_TODO").value;
  var event = { tag:"AddTodo",
                contents:todo
              };
  window.callBack(JSON.stringify(event))();
}

const addTodo = (val) => {
    var todolist = document.getElementById("todolist")
    var div = document.createElement("div")

    val[1] = 'todoid' + val[1]
    div.setAttribute("id", val[1])
    div = updateView(div, val)
    todolist.appendChild(div)
}

const deleteTodo = (id) => {
    var todolist = document.getElementById("todolist");
    var elem = document.getElementById(id);
    todolist.removeChild(elem);
}

const editTodo = todo => {
  var todoElem = document.getElementById(todo)
  var todoVal = todoElem.getElementsByTagName('p')[0].innerHTML
  todoElem.innerHTML = '<br/><input type="text" placeholder="' + todoVal + '" id="UPDATE_TODO" />'
  var button = document.createElement("button")

  button.appendChild(document.createTextNode("Update"))
  button.addEventListener("click", function() {
    var val = document.getElementById('UPDATE_TODO').value
    var event = { tag: "UpdateTodo",
                  contents: [val, todo]
                }
    window.callBack(JSON.stringify(event))()
  })
  todoElem.appendChild(button)
}

const updateTodo = data => {
  var [value, id] = data
  var updatedElem = document.getElementById(id)
  updatedElem.innerHTML = ''
  updateView(updatedElem, data)
}

const updateView = (div, data) => {
  var p = document.createElement("p")
  var button = document.createElement("button")
  var [text, id] = data
  p.appendChild(document.createTextNode(text))
  div.appendChild(p)

  button.appendChild(document.createTextNode("Delete"))
  button.addEventListener("click", function() {
    var event = { tag: "RemoveTodo",
                  contents: id
                }
    window.callBack(JSON.stringify(event))()
  })
  div.appendChild(button)

  var button2 = document.createElement("button")

  button2.appendChild(document.createTextNode("Edit"))
  button2.addEventListener("click", function() {
    var event = { tag: "EditTodo",
                  contents: id
                }
    window.callBack(JSON.stringify(event))()
  })
  div.appendChild(button2)
  return div
}

window.showScreen = function (callBack, data) {
    window.callBack = callBack;
    handleScreenAction(data);
};

const JBridge = {}

JBridge.getFromSharedPrefs = function(key) {
  return localStorage.getItem(key) || "__failed";
}

JBridge.setInSharedPrefs = function(key, value) {
  localStorage.setItem(key, value);
  return "success"
}
