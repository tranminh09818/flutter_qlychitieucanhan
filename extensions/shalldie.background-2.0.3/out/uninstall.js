"use strict";
/**
 * 1. 需要所有 vscode 进程退出，再打开，才会执行 `vscode:uninstall`
 * 2. 不能访问 vscode api
 *
 * https://github.com/microsoft/vscode/issues/155561
 * https://code.visualstudio.com/api/references/extension-manifest#extension-uninstall-hook
 */
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
/**
 * 使用到的依赖需要引用到具体文件，避免二次导出
 */
const fs_1 = __importDefault(require("fs"));
const PatchFile_javascript_1 = require("./background/PatchFile/PatchFile.javascript");
const constants_1 = require("./utils/constants");
async function uninstall() {
    try {
        const jsFilePath = (await fs_1.default.promises.readFile(constants_1.TOUCH_JSFILE_PATH, constants_1.ENCODING)).trim();
        if (!jsFilePath) {
            return;
        }
        const file = new PatchFile_javascript_1.JsPatchFile(jsFilePath);
        const hasPatched = await file.hasPatched();
        if (!hasPatched) {
            return;
        }
        await file.restore();
        console.log('vscode background has been auto uninstalled.');
    }
    catch (ex) {
        console.error('vscode background uninstalled fail: ' + ex.message);
    }
}
uninstall();
//# sourceMappingURL=uninstall.js.map