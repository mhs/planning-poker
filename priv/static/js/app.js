webpackJsonp([0],[
/* 0 */,
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(2);
module.exports = __webpack_require__(3);


/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _phoenix = __webpack_require__(0);

(function () {
    function buildHiddenInput(name, value) {
        var input = document.createElement("input");
        input.type = "hidden";
        input.name = name;
        input.value = value;
        return input;
    }

    function handleLinkClick(link) {
        var message = link.getAttribute("data-confirm");
        if (message && !window.confirm(message)) {
            return;
        }

        var to = link.getAttribute("data-to"),
            method = buildHiddenInput("_method", link.getAttribute("data-method")),
            csrf = buildHiddenInput("_csrf_token", link.getAttribute("data-csrf")),
            form = document.createElement("form");

        form.method = "post";
        form.action = to;
        form.style.display = "hidden";

        form.appendChild(csrf);
        form.appendChild(method);
        document.body.appendChild(form);
        form.submit();
    }

    window.addEventListener("click", function (e) {
        if (e.target && e.target.getAttribute("data-method")) {
            handleLinkClick(e.target);
        }
    }, false);
})();

/***/ }),
/* 3 */
/***/ (function(module, exports) {

// removed by extract-text-webpack-plugin

/***/ })
],[1]);
//# sourceMappingURL=app.js.map