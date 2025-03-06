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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.Background = void 0;
const fs_1 = __importDefault(require("fs"));
const os_1 = require("os");
const path_1 = __importDefault(require("path"));
const vscode_1 = __importStar(require("vscode"));
const constants_1 = require("../utils/constants");
const vscodePath_1 = require("../utils/vscodePath");
const vsHelp_1 = require("../utils/vsHelp");
const CssFile_1 = require("./CssFile");
const PatchFile_1 = require("./PatchFile");
const PatchGenerator_1 = require("./PatchGenerator");
/**
 * 插件逻辑类
 * Extension logic
 *
 * @export
 * @class Background
 */
class Background {
    // #region fields 字段
    /**
     * 老版本css文件操作对象
     *
     * @memberof Background
     */
    cssFile = new CssFile_1.CssFile(vscodePath_1.vscodePath.cssPath); // 没必要继承，组合就行
    jsFile = new PatchFile_1.JsPatchFile(vscodePath_1.vscodePath.jsPath);
    /**
     * Current config
     * 当前用户配置
     *
     * @private
     * @type {TConfigType}
     * @memberof Background
     */
    get config() {
        return vscode_1.default.workspace.getConfiguration('background');
    }
    /**
     * 需要释放的资源
     *
     * @private
     * @type {Disposable[]}
     * @memberof Background
     */
    disposables = [];
    // #endregion
    // #region private methods 私有方法
    /**
     * 检测是否初次加载，并在初次加载的时候提示用户
     *
     * @private
     * @returns {boolean} 是否初次加载
     * @memberof Background
     */
    async checkFirstload() {
        const firstLoad = !fs_1.default.existsSync(constants_1.TOUCH_JSFILE_PATH);
        if (firstLoad) {
            // 提示
            vscode_1.default.window
                .showInformationMessage(vscode_1.l10n.t('Welcome to use background@{version}!', { version: constants_1.VERSION }), {
                title: vscode_1.l10n.t('More')
            })
                .then(confirm => {
                if (!confirm) {
                    return;
                }
                this.showWelcome();
            });
            // 新版本强制提示下吧
            // if (VERSION === '2.0.0' || true) {
            //     this.showWelcome();
            // }
            // 标识插件已启动过
            await fs_1.default.promises.writeFile(constants_1.TOUCH_JSFILE_PATH, vscodePath_1.vscodePath.jsPath, constants_1.ENCODING);
            return true;
        }
        return false;
    }
    async showWelcome() {
        // 欢迎页
        const docDir = path_1.default.join(__dirname, '../../docs');
        const docName = /^zh/.test(vscode_1.default.env.language) ? 'welcome.zh-CN.md' : 'welcome.md';
        // welcome 内容
        let content = await fs_1.default.promises.readFile(path_1.default.join(docDir, docName), constants_1.ENCODING);
        // 替换图片内联为base64
        content = content.replace(/\.\.\/images[^\")]+/g, (relativePath) => {
            const imgPath = path_1.default.join(vscodePath_1.vscodePath.extensionRoot, 'images', relativePath);
            return (`data:image/${path_1.default.extname(imgPath).slice(1) || 'png'};base64,` +
                Buffer.from(fs_1.default.readFileSync(imgPath)).toString('base64'));
        });
        // 替换变量
        const paramsMap = {
            VERSION: constants_1.VERSION
        };
        for (const [key, value] of Object.entries(paramsMap)) {
            content = content.replaceAll('${' + key + '}', value);
        }
        const targetPath = path_1.default.join((0, os_1.tmpdir)(), 'welcome-to-background.md');
        await fs_1.default.promises.writeFile(targetPath, content, constants_1.ENCODING);
        vscode_1.default.commands.executeCommand('markdown.showPreviewToSide', vscode_1.Uri.file(targetPath));
    }
    /**
     * 移除旧版本css文件中的patch
     *
     * @private
     * @return {*}
     * @memberof Background
     */
    async removeLegacyCssPatch() {
        try {
            const hasInstalled = await this.cssFile.hasInstalled();
            if (!hasInstalled) {
                return;
            }
            await this.cssFile.uninstall();
        }
        catch (ex) { }
    }
    /**
     * 配置改变，confirm 并提示应用&重启
     *
     * @private
     * @return {*}
     * @memberof Background
     */
    async onConfigChange() {
        const hasInstalled = await this.hasInstalled();
        const enabled = this.config.enabled;
        // 禁用
        if (!enabled) {
            if (hasInstalled) {
                await this.uninstall();
                vsHelp_1.vsHelp.showInfoRestart(vscode_1.l10n.t('Background has been disabled! Please restart.'));
            }
            return;
        }
        // 更新，需要二次确认
        const confirm = await vscode_1.default.window.showInformationMessage(vscode_1.l10n.t('Configuration has been changed, click to update.'), {
            title: vscode_1.l10n.t('Update and restart')
        });
        if (!confirm) {
            return;
        }
        await this.applyPatch();
        vscode_1.default.commands.executeCommand('workbench.action.reloadWindow');
    }
    async applyPatch() {
        // 禁用时候，不处理
        if (!this.config.enabled) {
            return;
        }
        const scriptContent = PatchGenerator_1.PatchGenerator.create(this.config);
        return this.jsFile.applyPatches(scriptContent);
    }
    // #endregion
    // #region public methods
    /**
     * 初始化
     *
     * @return {*}  {Promise<void>}
     * @memberof Background
     */
    async setup() {
        await this.removeLegacyCssPatch(); // 移除v1旧版本patch
        await this.checkFirstload(); // 是否初次加载插件
        const patchType = await this.jsFile.getPatchType(); // css 文件目前状态
        // 如果「开启」状态，文件不是「latest」，则进行更新
        if (this.config.enabled) {
            // 此时一般为 vscode更新、background更新
            if ([PatchFile_1.EFilePatchType.Legacy, PatchFile_1.EFilePatchType.None].includes(patchType)) {
                if (await this.applyPatch()) {
                    vsHelp_1.vsHelp.showInfoRestart(vscode_1.l10n.t('Background has been changed! Please restart.'));
                }
            }
        }
        // 监听文件改变
        this.disposables.push(vscode_1.default.workspace.onDidChangeConfiguration(async (ex) => {
            const hasChanged = ex.affectsConfiguration(constants_1.EXTENSION_NAME);
            if (!hasChanged) {
                return;
            }
            this.onConfigChange();
        }));
    }
    /**
     * 是否已安装
     *
     * @return {*}
     * @memberof Background
     */
    hasInstalled() {
        return this.jsFile.hasPatched();
    }
    /**
     * 卸载
     *
     * @return {*}  {Promise<boolean>} 是否成功卸载
     * @memberof Background
     */
    async uninstall() {
        await this.removeLegacyCssPatch();
        return this.jsFile.restore();
    }
    /**
     * 释放资源
     *
     * @memberof Background
     */
    dispose() {
        this.disposables.forEach(n => n.dispose());
    }
}
exports.Background = Background;
//# sourceMappingURL=Background.js.map