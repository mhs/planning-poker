import { Controller } from "stimulus";
import { Socket } from "phoenix";

export default class extends Controller {
  connect() {
    this.socket = new Socket("/socket");
    this.socket.connect();
    const gameId = this.element.getAttribute("data-game-id");

    this.gameChannel = this.socket.channel(`game:${gameId}`, {
      token: window.userToken
    });

    this.gameChannel.on("players_updated", payload => {
      console.log("players updated!");
      this.element.innerHTML = payload.players;
      console.log(payload);
    });

    this.gameChannel
      .join()
      .receive("ok", resp => console.log("joined game channel ", resp))
      .receive("error", reason => console.log("error joining: ", reason));
  }

    disconnect() {
        this.gameChannel.leave();
    }
}
