"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FullscreenPatchGenerator = exports.FullscreenPatchGeneratorConfig = void 0;
const PatchGenerator_base_1 = require("./PatchGenerator.base");
class FullscreenPatchGeneratorConfig {
    images = [];
    opacity = 0.1; // 建议在 0.1 ~ 0.3
    size = 'cover';
    position = 'center';
    interval = 0;
    random = false;
}
exports.FullscreenPatchGeneratorConfig = FullscreenPatchGeneratorConfig;
class FullscreenPatchGenerator extends PatchGenerator_base_1.AbsPatchGenerator {
    cssvariable = '--background-fullscreen-img';
    get curConfig() {
        const cur = {
            ...new FullscreenPatchGeneratorConfig(),
            ...this.config
        };
        // ------ opacity ------
        if (cur.opacity < 0 || cur.opacity > 0.6) {
            cur.opacity = new FullscreenPatchGeneratorConfig().opacity;
        }
        return cur;
    }
    getStyle() {
        const { size, position, opacity } = this.curConfig;
        return (0, PatchGenerator_base_1.css) `
            body::after {
                content: '';
                display: block;
                position: absolute;
                z-index: 1000;
                inset: 0;
                pointer-events: none;
                background-size: ${size};
                background-repeat: no-repeat;
                /* background-attachment: fixed; // 兼容 code-server，其他的不影响 */
                background-position: ${position};
                opacity: ${opacity};
                transition: 1s;
                background-image: var(${this.cssvariable});
            }
        `;
    }
    getScript() {
        const { images, random, interval } = this.curConfig;
        return `
const cssvariable = '${this.cssvariable}';
const images = ${JSON.stringify(images)};
const random = ${random};
const interval = ${interval};

let curIndex = -1;

function getNextImg() {
    if (random) {
        return images[Math.floor(Math.random() * images.length)];
    }

    curIndex++;
    curIndex = curIndex % images.length;
    return images[curIndex];
}

function setNextImg() {
    document.body.style.setProperty(cssvariable, 'url(' + getNextImg() + ')');
}

if (interval > 0) {
    setInterval(setNextImg, interval * 1000);
}

setNextImg();
        `;
    }
}
exports.FullscreenPatchGenerator = FullscreenPatchGenerator;
//# sourceMappingURL=PatchGenerator.fullscreen.js.map