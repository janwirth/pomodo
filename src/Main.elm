module Main exposing (..)
{-| Pomodo is a time-boxing work-planning tool.

MVP
- timer
- todo-list
-}

import Browser
import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Element
import Timer
import Todo
import Json.Decode as Decode


---- MODEL ----


type alias Model =
    { timerModel : Timer.Model
    , todoModel : Todo.Model
    }


init : Flags -> a -> b -> ( Model, Cmd Msg )
init flags _ _ =
    let
        (timerModel, timerCmd) = Timer.init
        (todoModel, todoCmd) = Todo.init flags.localStorage
    in
        ( {
            timerModel = timerModel
          , todoModel = todoModel
        }, Cmd.batch [
            timerCmd |> Cmd.map TimerMsg
        , todoCmd |> Cmd.map TodoMsg
        ]
        )



---- UPDATE ----


type Msg
    = NoOp
    | TodoMsg Todo.Msg
    | TimerMsg Timer.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
        TodoMsg msg_ ->
            let
                (model_, cmd) = Todo.updateWithStorage msg_ model.todoModel
            in
                ({model | todoModel = model_}, Cmd.map TodoMsg cmd)
            
        TimerMsg msg_ ->
            let
                (model_, cmd) = Timer.update msg_ model.timerModel
            in
                ({model | timerModel = model_}, Cmd.map TimerMsg cmd)
            



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ Timer.view model.timerModel |> Html.map TimerMsg
        , Todo.view model.todoModel |> Html.map TodoMsg
        ]

viewWithTitle : Model -> Browser.Document Msg
viewWithTitle model =
    let
        title : String
        title =
            Timer.getStatusString model.timerModel ++
            " " ++
            Timer.timeMaker model.timerModel
    in
        { title = title
        , body = [view model]
        }


---- PROGRAM ----
type alias Flags = {
    localStorage : Maybe Todo.Model
    , now : Int
    }


main : Program Flags Model Msg
main =
    Browser.application
        { view = viewWithTitle
        , init = init
        , update = update
        , onUrlChange = always NoOp
        , onUrlRequest = always NoOp
        , subscriptions = subscriptions
        }

subscriptions model = Timer.subscriptions model.timerModel |> Sub.map TimerMsg
