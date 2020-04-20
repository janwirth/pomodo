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

var notificationsEnabled = false
Notification.requestPermission((status) => {
  notify('Notifications enabled');
  notificationsEnabled = status === "granted";
});

// Notifications
const notificationSound = "https://notificationsounds.com/soundfiles/a8849b052492b5106526b2331e526138/file-sounds-1125-insight.mp3"

const audio = new Audio(notificationSound)
const notify = function(message) {
  audio.play()
  // do not try pushing a notification if the user has not yet accepted it.
  if (!notificationsEnabled) {
      return
  }
  const iconLink = "http://www.wpclipart.com/food/fruit/tomato/tomato.png"

  return new Notification(message, {
    body: message,
    icon: iconLink
  });
};

app.ports.notify.subscribe(notify);
