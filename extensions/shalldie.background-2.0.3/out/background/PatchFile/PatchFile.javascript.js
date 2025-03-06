"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.JsPatchFile = void 0;
const utils_1 = require("../../utils");
const constants_1 = require("../../utils/constants");
const PatchFile_base_1 = require("./PatchFile.base");
// vscode-background-start background.ver.2.0.0
// vscode-background-end
/**
 * js 文件相关操作
 *
 * @export
 * @class JsPatchFile
 * @extends {AbsPatchFile}
 */
class JsPatchFile extends PatchFile_base_1.AbsPatchFile {
    async applyPatches(patchContent) {
        try {
            await utils_1._.lock();
            const curContent = await this.getContent();
            let content = this.cleanPatches(curContent);
            content += [
                //
                `\n// vscode-background-start ${constants_1.BACKGROUND_VER}.${constants_1.VERSION}`,
                patchContent,
                '// vscode-background-end'
            ].join('\n');
            // file unchanged
            if (curContent === content) {
                return true;
            }
            return await this.write(content);
        }
        catch {
            return false;
        }
        finally {
            await utils_1._.unlock();
        }
    }
    cleanPatches(content) {
        content = content.replace(/\n\/\/ vscode-background-start[\s\S]*\/\/ vscode-background-end/, '');
        return content;
    }
}
exports.JsPatchFile = JsPatchFile;
//# sourceMappingURL=PatchFile.javascript.js.map