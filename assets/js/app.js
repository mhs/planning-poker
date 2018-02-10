import { Socket } from "phoenix";
import { ready } from "./helpers";
import setupLinks from "./phoenix-link-helpers";
import Turbolinks from "turbolinks";
import { Application } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";


setupLinks();
console.log("starting turbolinks");
Turbolinks.start();

const application = Application.start();
const context = require.context("./controllers", true, /\.js$/);
application.load(definitionsFromContext(context));
