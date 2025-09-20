// ==UserScript==
// @name         网页缩放
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  快捷键动态缩放网页UI
// @author       Minami
// @match        *://*/*
// @grant        GM_addStyle
// ==/UserScript==

(function() {
    'use strict';

    let zoomFactor = 1.1;  // 初始缩放比例
    const zoomStep = 0.1;  // 缩放增量

    // 更新页面的缩放比例
    function applyZoom() {
        GM_addStyle(`
            html {
                zoom: ${zoomFactor};
            }
        `);
    }

    // 监听快捷键事件
    window.addEventListener('keydown', function(event) {
        if (event.ctrlKey && event.key === '=') {
            zoomFactor += zoomStep;  // 放大
            applyZoom();
        } else if (event.ctrlKey && event.key === '-') {
            zoomFactor -= zoomStep;  // 缩小
            applyZoom();
        }
    });

    // 初始化应用
    applyZoom();
})();
