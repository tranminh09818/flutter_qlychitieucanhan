"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports._ = void 0;
const sudo_prompt_1 = __importDefault(require("@vscode/sudo-prompt"));
const lockfile_1 = __importDefault(require("lockfile"));
const constants_1 = require("./constants");
const vsc_1 = require("./vsc");
var _;
(function (_) {
    /**
     * if zh-CN
     */
    _.isZHCN = /^zh/.test(vsc_1.vsc?.env.language || '');
    /**
     * if desktop
     *
     * desktop: `desktop`
     * code-server: `server-distro`
     * See: https://code.visualstudio.com/api/references/vscode-api#env
     */
    _.isDesktop = vsc_1.vsc?.env.appHost === 'desktop';
    /**
     * 等待若干时间
     *
     * @export
     * @param {number} [delay=0]
     * @return {*}
     */
    function sleep(delay = 0) {
        return new Promise(resolve => {
            setTimeout(resolve, delay);
        });
    }
    _.sleep = sleep;
    /**
     * 添加文件锁
     *
     * @export
     * @return {*}
     */
    function lock() {
        return new Promise((resolve, reject) => {
            lockfile_1.default.lock(constants_1.LOCK_PATH, {
                // When multiple VSCode instances are running, all instances' commands need to be executed within the `wait` time
                // 在打开了多个vscode实例时，需要所有实例的命令在`wait`时间内执行完毕
                wait: 1000 * 30
            }, err => {
                if (err) {
                    return reject(err);
                }
                resolve();
            });
        });
    }
    _.lock = lock;
    /**
     * 取消文件锁
     *
     * @export
     * @return {*}
     */
    function unlock() {
        return new Promise((resolve, reject) => {
            lockfile_1.default.unlock(constants_1.LOCK_PATH, err => {
                if (err) {
                    return reject(err);
                }
                resolve();
            });
        });
    }
    _.unlock = unlock;
    /**
     * 提权运行
     *
     * @export
     * @param {string} cmd
     * @param {{ name?: string }} [options={}]
     * @return {*}  {Promise<any>}
     */
    function sudoExec(cmd, options = {}) {
        return new Promise((resolve, reject) => {
            sudo_prompt_1.default.exec(cmd, options, (error, stdout, stderr) => {
                if (error) {
                    reject(error);
                }
                resolve([stdout, stderr]);
            });
        });
    }
    _.sudoExec = sudoExec;
    /**
     * wrap with IIFE
     *
     * @export
     * @param {string} source
     * @return {*}
     */
    function withIIFE(source) {
        return `;(function() { ${source} })();`;
    }
    _.withIIFE = withIIFE;
})(_ || (exports._ = _ = {}));
//# sourceMappingURL=index.js.map