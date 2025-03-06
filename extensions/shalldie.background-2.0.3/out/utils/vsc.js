"use strict";
/**
 * 给无 vscode api 的 case 使用
 * 比如 `vscode:uninstall`
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.vsc = void 0;
let vsc;
try {
    exports.vsc = vsc = require('vscode');
}
catch {
    // nothing todo
}
//# sourceMappingURL=vsc.js.map