import './main.css';
import './todo.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';


var storedState = localStorage.getItem('elm-todo-save');
var startingState = storedState ? JSON.parse(storedState) : null;

const now = Date.now()
const flags = {localStorage: startingState, now}

const app =
    Elm.Main.init({ flags
        , node: document.getElementById('root')
    });

app.ports.setStorage.subscribe(function(state) {
   localStorage.setItem('elm-todo-save', JSON.stringify(state));
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();

