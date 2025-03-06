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
exports.AbsPatchFile = exports.EFilePatchType = void 0;
const crypto_1 = require("crypto");
const fs_1 = __importStar(require("fs"));
const os_1 = require("os");
const path_1 = __importDefault(require("path"));
const utils_1 = require("../../utils");
const constants_1 = require("../../utils/constants");
const vsc_1 = require("../../utils/vsc");
var EFilePatchType;
(function (EFilePatchType) {
    /**
     * 未修改的文件
     */
    EFilePatchType[EFilePatchType["None"] = 0] = "None";
    /**
     * patch 过的旧版本文件
     */
    EFilePatchType[EFilePatchType["Legacy"] = 1] = "Legacy";
    /**
     * patch 过的新版本文件
     */
    EFilePatchType[EFilePatchType["Latest"] = 2] = "Latest";
})(EFilePatchType || (exports.EFilePatchType = EFilePatchType = {}));
/**
 * 文件 patch 操作
 *
 * @export
 * @abstract
 * @class AbsPatchFile
 */
class AbsPatchFile {
    filePath;
    constructor(filePath) {
        this.filePath = filePath;
    }
    /**
     * 是否已经修改过
     *
     * @return {*}  {Promise<boolean>}
     * @memberof JsFile
     */
    async hasPatched() {
        const editType = await this.getPatchType();
        return editType !== EFilePatchType.None;
    }
    /**
     * 当前文件的修改状态
     *
     * @return {*}  {Promise<EPatchFileEditType>}
     * @memberof AbsPatchFile
     */
    async getPatchType() {
        const content = await this.getContent();
        // patch 过的新版本
        if (content.includes(`${constants_1.BACKGROUND_VER}.${constants_1.VERSION}`)) {
            return EFilePatchType.Latest;
        }
        // 包含 background.ver，patch 过的旧版本
        if (content.includes(constants_1.BACKGROUND_VER)) {
            return EFilePatchType.Legacy;
        }
        return EFilePatchType.None;
    }
    getContent() {
        return fs_1.default.promises.readFile(this.filePath, constants_1.ENCODING);
    }
    async saveContentTo(filePath, content) {
        try {
            if (fs_1.default.existsSync(filePath)) {
                await fs_1.default.promises.access(filePath, fs_1.constants.W_OK);
            }
            await fs_1.default.promises.writeFile(filePath, content, constants_1.ENCODING);
            return true;
        }
        catch (e) {
            if (!vsc_1.vsc) {
                return false;
            }
            // FIXME：
            // 一些系统会报错：Unable to find pkexec or kdesudo.
            // 相关 issue：https://github.com/jorangreef/sudo-prompt/pull/123
            // 测试环境： codercom/code-server:4.4.0
            // uname -a
            // Linux code-server-b6cc684df-sqx9h 5.4.0-77-generic #86-Ubuntu SMP Thu Jun 17 02:35:03 UTC 2021 x86_64 GNU/Linux
            const retry = 'Retry with Admin/Sudo';
            const result = await vsc_1.vsc.window.showErrorMessage(e.message, retry);
            if (result !== retry) {
                return false;
            }
            const tempFilePath = path_1.default.join((0, os_1.tmpdir)(), `vscode-background-${(0, crypto_1.randomUUID)()}.temp`);
            await fs_1.default.promises.writeFile(tempFilePath, content, constants_1.ENCODING);
            try {
                const mvcmd = process.platform === 'win32' ? 'move /Y' : 'mv -f';
                const cmdarg = `${mvcmd} "${tempFilePath}" "${filePath}"`;
                await utils_1._.sudoExec(cmdarg, { name: 'Background Extension' });
                return true;
            }
            catch (e) {
                vsc_1.vsc.window.showErrorMessage(e.message, { title: 'Common Issue' }).then(confirm => {
                    if (!confirm) {
                        return;
                    }
                    const helpLink = 'https://github.com/shalldie/vscode-background/blob/master/docs/common-issues.md#read-only-file-system';
                    vsc_1.vsc.env.openExternal(vsc_1.vsc.Uri.parse(helpLink));
                });
                return false;
            }
            finally {
                await fs_1.default.promises.rm(tempFilePath, { force: true });
            }
        }
    }
    async write(content) {
        if (!content.trim().length) {
            return false;
        }
        return this.saveContentTo(this.filePath, content);
    }
    async restore() {
        try {
            await utils_1._.lock();
            let content = await this.getContent();
            content = this.cleanPatches(content);
            return await this.write(content);
        }
        catch {
            return false;
        }
        finally {
            await utils_1._.unlock();
        }
    }
}
exports.AbsPatchFile = AbsPatchFile;
//# sourceMappingURL=PatchFile.base.js.map