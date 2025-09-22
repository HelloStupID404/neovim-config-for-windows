// ==UserScript==
// @name         网页缩放
// @namespace    http://tampermonkey.net/
// @version      0.2
// @description  用Ctrl和+/-快捷键动态缩放网页UI
// @author       Minami
// @match        *://*/*
// @grant        GM_addStyle
// ==/UserScript==

(function() {
    'use strict';

    // 获取当前浏览器的缩放比例
    let zoomFactor = parseFloat(getComputedStyle(document.documentElement).zoom) || 1.0;
    const zoomStep = 0.1;  // 缩放增量

    // 添加提示框样式
    GM_addStyle(`
        #zoom-indicator {
            position: fixed;
            top: 10px;
            right: 10px;
            background: white;
            padding: 6px 10px;
            border-radius: 8px;
            font-size: 12px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            font-weight: 600;
            z-index: 999999;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            border: 2px solid black;
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
            pointer-events: none;
            opacity: 0;
            transform: translateY(-10px);
        }

        #zoom-indicator .text-gradient {
            background: linear-gradient(135deg, #3b82f6 0%, #ec4899 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            display: inline-block;
        }

        #zoom-indicator.show {
            opacity: 1;
            transform: translateY(0);
        }
    `);

    // 更新页面的缩放比例
    function applyZoom(showIndicator = true) {
        // 限制缩放范围
        zoomFactor = Math.max(0.3, Math.min(3.0, zoomFactor));

        GM_addStyle(`
            html {
                zoom: ${zoomFactor} !important;
            }
        `);

        // 显示缩放提示
        if (showIndicator) {
            showZoomIndicator();
        }
    }

    // 显示缩放提示
    function showZoomIndicator() {
        let indicator = document.getElementById('zoom-indicator');

        if (!indicator) {
            indicator = document.createElement('div');
            indicator.id = 'zoom-indicator';
            document.body.appendChild(indicator);
        }

        // 更新提示内容
        const zoomPercentage = Math.round(zoomFactor * 100);
        indicator.innerHTML = `<span class="text-gradient">Zoom: ${zoomPercentage}%</span>`;

        // 显示动画
        indicator.classList.add('show');

        // 清除之前的定时器
        clearTimeout(indicator.hideTimer);

        // 1.5秒后隐藏
        indicator.hideTimer = setTimeout(() => {
            indicator.classList.remove('show');
        }, 1500);
    }

    // 监听快捷键事件
    window.addEventListener('keydown', function(event) {
        // 避免在输入框中触发
        const activeElement = document.activeElement;
        if (activeElement && (
            activeElement.tagName === 'INPUT' ||
            activeElement.tagName === 'TEXTAREA' ||
            activeElement.contentEditable === 'true'
        )) {
            return;
        }

        if (event.ctrlKey && event.key === '=') {
            event.preventDefault();
            zoomFactor += zoomStep;  // 放大
            applyZoom();
        } else if (event.ctrlKey && event.key === '-') {
            event.preventDefault();
            zoomFactor -= zoomStep;  // 缩小
            applyZoom();
        } else if (event.ctrlKey && event.key === '0') {
            event.preventDefault();
            zoomFactor = 1.0;  // 重置缩放
            applyZoom();
        }
    });
})();
