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
exports.AbsPatchGenerator = void 0;
exports.css = css;
const stylis = __importStar(require("stylis"));
const vscode_1 = __importDefault(require("vscode"));
const utils_1 = require("../../utils");
/**
 * 用于触发开发工具 css in js 语言支持
 *
 * @export
 * @param {TemplateStringsArray} template
 * @param {...any[]} args
 * @return {*}
 */
function css(template, ...args) {
    return template.reduce((prev, curr, i) => {
        let arg = args[i];
        // 注意顺序, 内嵌函数可能返回 Array
        if (typeof arg === 'function') {
            arg = arg();
        }
        if (Array.isArray(arg)) {
            arg = arg.join('');
        }
        return prev + curr + (arg ?? '');
    }, '');
}
class AbsPatchGenerator {
    config;
    constructor(config) {
        this.config = {
            ...config,
            images: this.normalizeImageUrls(config?.images || [])
        };
    }
    /**
     * 归一化图片路径
     * 在 v1.51.1 版本之后, vscode 将工作区放入 sandbox 中运行并添加了 file 协议的访问限制, 导致使用 file 协议的背景图片无法显示
     * 当检测到配置文件使用 file 协议时, 需要将其转换为 vscode-file 协议
     * @protected
     * @param {string[]} images 图片列表
     * @return {*}
     * @memberof AbsPatchGenerator
     */
    normalizeImageUrls(images) {
        return images.map(imageUrl => {
            if (!imageUrl.startsWith('file://')) {
                return imageUrl;
            }
            // file:///Users/foo/bar.png => vscode-file://vscode-app/Users/foo/bar.png
            const url = imageUrl.replace('file://', 'vscode-file://vscode-app');
            return vscode_1.default.Uri.parse(url).toString();
        });
    }
    /**
     * 编译 css
     *
     * @protected
     * @param {string} source
     * @return {*}
     * @memberof AbsPatchGenerator
     */
    compileCSS(source) {
        return stylis.serialize(stylis.compile(source), stylis.stringify);
    }
    getPreload() {
        const images = (this.config?.images || []).filter(n => n.length);
        // 10个以内图片，做预加载进行优化
        if (!images.length || images.length > 10) {
            return '';
        }
        return `
const images = ${JSON.stringify(images)};

const container = (() => {
    const cid = 'backgroundPreloadContainer';
    let c = document.getElementById(cid);
    if (!c) {
        c = document.createElement('div');
        c.id = cid;
        c.style.width = 0;
        c.style.height = 0;
        c.style.opacity = 0;
        c.style.overflow = 'hidden';
        document.body.appendChild(c);
    }
    return c;
})();

const div = document.createElement('div');
div.style.backgroundImage = images.map(url => 'url(' + url + ')').join(',');
container.appendChild(div);
`;
    }
    getStyle() {
        return '';
    }
    getScript() {
        return '';
    }
    create() {
        if (!this.config?.images.length) {
            return '';
        }
        const style = this.compileCSS(this.getStyle());
        const script = this.getScript().trim();
        return [
            this.getPreload(),
            `
                var style = document.createElement("style");
                style.textContent = ${JSON.stringify(style)};
                document.head.appendChild(style);
            `,
            script
        ]
            .filter(n => !!n.length)
            .map(n => utils_1._.withIIFE(n))
            .join(';');
    }
}
exports.AbsPatchGenerator = AbsPatchGenerator;
//# sourceMappingURL=PatchGenerator.base.js.map