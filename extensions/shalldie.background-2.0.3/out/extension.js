"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.activate = activate;
exports.deactivate = deactivate;
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
const vscode_1 = __importStar(require("vscode"));
const background_1 = require("./background");
const constants_1 = require("./utils/constants");
const vsHelp_1 = require("./utils/vsHelp");
// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
function getStatusbar() {
    const item = vscode_1.default.window.createStatusBarItem(vscode_1.default.StatusBarAlignment.Right);
    item.command = 'extension.background.showAllCommands';
    item.name = 'Background';
    item.text = '$(file-media) Background';
    item.tooltip = new vscode_1.default.MarkdownString(vscode_1.l10n.t('Show `background` commands'));
    item.show();
    return item;
}
async function activate(context) {
    const background = new background_1.Background();
    context.subscriptions.push(background);
    const ok = await background.setup();
    if (ok === false) {
        return;
    }
    context.subscriptions.push(vscode_1.default.commands.registerCommand('extension.background.info', function () {
        background.showWelcome();
    }));
    context.subscriptions.push(vscode_1.default.commands.registerCommand('extension.background.install', async () => {
        await background.config.update('enabled', true, true);
        await background.applyPatch();
        await vscode_1.default.commands.executeCommand('workbench.action.reloadWindow');
    }));
    context.subscriptions.push(vscode_1.default.commands.registerCommand('extension.background.disable', async () => {
        await background.config.update('enabled', false, true);
        await background.uninstall();
        await vscode_1.default.commands.executeCommand('workbench.action.reloadWindow');
    }));
    context.subscriptions.push(vscode_1.default.commands.registerCommand('extension.background.uninstall', async () => {
        if (await background.uninstall()) {
            // 当且仅当成功删除样式时才会卸载扩展
            // 否则可能导致没有成功删掉样式时扩展就被卸载掉
            await vscode_1.default.commands.executeCommand('workbench.extensions.uninstallExtension', constants_1.EXTENSION_ID);
            await vsHelp_1.vsHelp.showInfoRestart(vscode_1.l10n.t('Background extension has been uninstalled. See you next time!'));
        }
    }));
    const statusbar = getStatusbar();
    context.subscriptions.push(vscode_1.default.commands.registerCommand(statusbar.command, async () => {
        vscode_1.default.commands.executeCommand('workbench.action.quickOpen', '> background: ');
    }));
    context.subscriptions.push(statusbar);
}
// this method is called when your extension is deactivated
function deactivate() { }
//# sourceMappingURL=extension.js.map