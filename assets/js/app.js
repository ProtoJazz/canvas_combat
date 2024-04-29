// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import Konva from "konva";
let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let Hooks = {};

Hooks.Drawing = {
  mounted() {
    var width = window.innerWidth;
    var height = window.innerHeight - 25;

    // first we need Konva core things: stage and layer
    var stage = new Konva.Stage({
      container: "container",
      width: width,
      height: height,
    });

    var layer = new Konva.Layer();
    stage.add(layer);

    var isPaint = false;
    var mode = "brush";
    var lastLine;

    stage.on("mousedown touchstart", function (e) {
      isPaint = true;
      var pos = stage.getPointerPosition();
      lastLine = new Konva.Line({
        stroke: "#df4b26",
        strokeWidth: 5,
        globalCompositeOperation:
          mode === "brush" ? "source-over" : "destination-out",
        // round cap for smoother lines
        lineCap: "round",
        lineJoin: "round",
        // add point twice, so we have some drawings even on a simple click
        points: [pos.x, pos.y, pos.x, pos.y],
      });
      layer.add(lastLine);
    });

    stage.on("mouseup touchend", function () {
      isPaint = false;
    });

    // and core function - drawing
    stage.on("mousemove touchmove", function (e) {
      if (!isPaint) {
        return;
      }

      // prevent scrolling on touch devices
      e.evt.preventDefault();

      const pos = stage.getPointerPosition();
      var newPoints = lastLine.points().concat([pos.x, pos.y]);
      lastLine.points(newPoints);
    });

    var select = document.getElementById("tool");
    select.addEventListener("change", function () {
      mode = select.value;
    });

    this.handleEvent("DrawingDone", (payload) => {
      console.log("Winkyface");
      console.log(layer.toJSON());
      this.pushEvent("DrawingSubmit", {
        drawing: layer.toJSON(),
      });
    });
    this.handleEvent("DrawThis", (payload) => {
      console.log("Drawing");
      console.log(payload);
      var newLayer = Konva.Node.create(payload.drawing);
      console.log(newLayer);
      stage.add(newLayer);
    });
  },
};

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
