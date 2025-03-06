"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.vscodePath = void 0;
const path_1 = __importDefault(require("path"));
const index_1 = require("./index");
const vsc_1 = require("./vsc");
// 基础目录
const base = (() => {
    const mainFilename = require.main?.filename;
    const vscodeInstallPath = vsc_1.vsc?.env.appRoot;
    const base = mainFilename?.length ? path_1.default.dirname(mainFilename) : path_1.default.join(vscodeInstallPath, 'out');
    return base;
})();
const cssPath = (() => {
    const getCssPath = (cssFileName) => path_1.default.join(base, 'vs', 'workbench', cssFileName);
    const defPath = getCssPath('workbench.desktop.main.css');
    // https://github.com/microsoft/vscode/pull/141263
    const webPath = getCssPath('workbench.web.main.css');
    if (index_1._.isDesktop) {
        return defPath;
    }
    return webPath;
})();
const jsPath = (() => {
    // See https://code.visualstudio.com/api/references/vscode-api#env
    // desktop
    // /Applications/Visual Studio Code.app/Contents/Resources/app/out/vs/workbench/workbench.desktop.main.js
    if (index_1._.isDesktop) {
        return path_1.default.join(base, 'vs/workbench/workbench.desktop.main.js');
    }
    // code-server
    // /usr/lib/code-server/lib/vscode/out/vs/code/browser/workbench/workbench.js
    return path_1.default.join(base, 'vs/code/browser/workbench/workbench.js');
})();
exports.vscodePath = {
    /**
     * 基础目录
     */
    base,
    extensionRoot: path_1.default.join(__dirname, '../../'),
    /**
     * css文件路径
     */
    cssPath,
    /**
     * js 文件地址
     */
    jsPath
};
//# sourceMappingURL=vscodePath.js.map