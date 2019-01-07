// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect()

// Now that you are connected, you can join channels with a topic:
function new_channel(subtopic, screen_name) {
    return socket.channel("game:" + subtopic, {screen_name: screen_name})
}

function join(channel) {
    channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })
}

function leave(channel) {
    channel.leave()
      .receive("ok", resp => { console.log("Left successfully", resp) })
      .receive("error", resp => { console.log("Unable to leave", resp) })
}

function new_game(channel) {
    channel.push("new_game")
      .receive("ok", resp => { console.log("New Game!", resp.message) })
      .receive("error", resp => { console.log("Unable to start a new game", resp.message) })
}

function add_player(channel, player) {
    channel.push("add_player", player)
      .receive("error", resp => { console.log("Unable to add new player: " + player.resp) })
}

function position_island(channel, player, island, row, col) {
    var params = {"player": player, "island": island, "row": row, "col": col}
    channel.push("position_island", params)
      .receive("ok", resp => { console.log("Island positioned!", resp.message) })
      .receive("error", resp => { console.log("Unable to position island", resp.message) })
}

function set_islands(channel, player) {
    channel.push("set_islands", player)
      .receive("ok", resp => { console.log("Island set") })
      .receive("error", resp => { console.log("Unable to set island" ) })
}

function guess_coordinate(channel, player, row, col) {
    var params = {"player": player, "row": row, "col": col}
    channel.push("guess_coordinate", params)
      .receive("error", resp => {
          console.log("Unable to guess coordinate", resp)
      })
}

let channel = new_channel("moon", "moon")

channel.on("player_added", resp => {
    console.log("Player Added", resp)
    channel.push("show_subscribers")
})

channel.on("player_set_islands", resp => {
    console.log("Player Set Islands", resp)
})

channel.on("player_guessed_coordinate", resp => {
    console.log("Player Guesssd Coordinate: ", resp.result)
})

channel.on("subscribers", resp => {
    console.log("These players have joined: ", resp)
})

join(channel)
new_game(channel)
add_player(channel, "Meraj")

position_island(channel, "player1", "dot", 1, 5)
position_island(channel, "player1", "atoll", 1, 1)
position_island(channel, "player1", "l_shape", 1, 7)
position_island(channel, "player1", "s_shape", 5, 1)
position_island(channel, "player1", "square", 5, 5)

position_island(channel, "player2", "dot", 1, 5)
position_island(channel, "player2", "atoll", 1, 1)
position_island(channel, "player2", "l_shape", 1, 7)
position_island(channel, "player2", "s_shape", 5, 1)
position_island(channel, "player2", "square", 5, 5)

set_islands(channel, "player1")
set_islands(channel, "player2")

guess_coordinate(channel, "player1", 1, 1)
guess_coordinate(channel, "player2", 1, 1)
guess_coordinate(channel, "player1", 10, 1)

export default socket
