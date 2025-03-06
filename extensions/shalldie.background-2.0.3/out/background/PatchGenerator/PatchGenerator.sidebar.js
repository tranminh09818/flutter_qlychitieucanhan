"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SidebarPatchGenerator = exports.SidebarPatchGeneratorConfig = void 0;
const PatchGenerator_base_1 = require("./PatchGenerator.base");
const PatchGenerator_fullscreen_1 = require("./PatchGenerator.fullscreen");
class SidebarPatchGeneratorConfig extends PatchGenerator_fullscreen_1.FullscreenPatchGeneratorConfig {
}
exports.SidebarPatchGeneratorConfig = SidebarPatchGeneratorConfig;
class SidebarPatchGenerator extends PatchGenerator_fullscreen_1.FullscreenPatchGenerator {
    cssvariable = '--background-sidebar-img';
    getStyle() {
        const { size, position, opacity } = this.curConfig;
        return (0, PatchGenerator_base_1.css) `
            .split-view-view > .part.sidebar::after {
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
exports.SidebarPatchGenerator = SidebarPatchGenerator;
//# sourceMappingURL=PatchGenerator.sidebar.js.map