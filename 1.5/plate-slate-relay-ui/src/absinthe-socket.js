import * as AbsintheSocket from "@absinthe/socket";
import { Socket as PhoenixSocket } from "phoenix";

export default AbsintheSocket.create(
  new PhoenixSocket("ws://localhost:4000/socket")
);