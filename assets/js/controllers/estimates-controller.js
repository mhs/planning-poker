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

    this.gameChannel.on("estimates_updated", payload => {
      console.log("estimates updated!");
      this.element.innerHTML = payload.estimates;
      const round = document.querySelector('[data-round-name]');
      if (round) {
        round.textContent = `Round ${payload.roundId}`;
      }
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
