"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PatchGenerator = void 0;
const uglify_js_1 = __importDefault(require("uglify-js"));
const utils_1 = require("../../utils");
const PatchGenerator_checksums_1 = require("./PatchGenerator.checksums");
const PatchGenerator_editor_1 = require("./PatchGenerator.editor");
const PatchGenerator_fullscreen_1 = require("./PatchGenerator.fullscreen");
const PatchGenerator_panel_1 = require("./PatchGenerator.panel");
const PatchGenerator_sidebar_1 = require("./PatchGenerator.sidebar");
class PatchGenerator {
    static create(options) {
        const script = [
            new PatchGenerator_checksums_1.ChecksumsPatchGenerator().create(), // fix checksums
            new PatchGenerator_editor_1.EditorPatchGenerator(PatchGenerator_editor_1.EditorPatchGenerator.mergeLegacyConfig(options, options.editor)).create(), // editor,
            new PatchGenerator_sidebar_1.SidebarPatchGenerator(options.sidebar).create(), // sidebar
            new PatchGenerator_panel_1.PanelPatchGenerator(options.panel).create(), // panel
            new PatchGenerator_fullscreen_1.FullscreenPatchGenerator(options.fullscreen).create() // fullscreen
        ]
            .map(n => utils_1._.withIIFE(n))
            .join(';');
        // return script;
        return uglify_js_1.default.minify(script).code;
    }
}
exports.PatchGenerator = PatchGenerator;
//# sourceMappingURL=index.js.map