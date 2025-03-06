"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PanelPatchGenerator = exports.PanelPatchGeneratorConfig = void 0;
const PatchGenerator_base_1 = require("./PatchGenerator.base");
const PatchGenerator_fullscreen_1 = require("./PatchGenerator.fullscreen");
class PanelPatchGeneratorConfig extends PatchGenerator_fullscreen_1.FullscreenPatchGeneratorConfig {
}
exports.PanelPatchGeneratorConfig = PanelPatchGeneratorConfig;
class PanelPatchGenerator extends PatchGenerator_fullscreen_1.FullscreenPatchGenerator {
    cssvariable = '--background-panel-img';
    getStyle() {
        const { size, position, opacity } = this.curConfig;
        return (0, PatchGenerator_base_1.css) `
            .split-view-view > .part.panel::after {
                content: '';
                position: absolute;
                width: 100%;
                height: 100%;
                top: 0;
                left: 0;
                background-position: ${position};
                background-repeat: no-repeat;
                background-size: ${size};
                pointer-events: none;
                opacity: ${opacity};
                transition: 1s;
                background-image: var(${this.cssvariable});
            }
        `;
    }
}
exports.PanelPatchGenerator = PanelPatchGenerator;
//# sourceMappingURL=PatchGenerator.panel.js.map