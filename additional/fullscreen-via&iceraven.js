// ==UserScript==
// @name         FullScreen
// @namespace    http://example.com/
// @version      1.0
// @description  可拖动悬浮全屏按钮
// @author       Minami
// @match        *://*/*
// @grant        none
// ==/UserScript==

(function () {
    'use strict';

    // 切换全屏
    function toggleFullscreen() {
        if (!document.fullscreenElement) {
            document.documentElement.requestFullscreen().catch(err => {
                console.warn(`全屏失败: ${err.message}`);
            });
        } else {
            document.exitFullscreen();
        }
    }

    function addFullscreenButton() {
        const btn = document.createElement("div");
        btn.innerText = "⛶";
        btn.title = "进入/退出全屏";
        Object.assign(btn.style, {
            position: "fixed",
            bottom: "100px",
            right: "20px",
            zIndex: 99999,
            width: "56px",
            height: "56px",
            lineHeight: "56px",
            borderRadius: "50%",
            background: "black",
            color: "white",
            fontSize: "24px",
            fontWeight: "bold",
            textAlign: "center",
            cursor: "pointer",
            userSelect: "none",
            transition: "all 0.3s ease",
            boxShadow: "0 4px 12px rgba(0,0,0,0.3)",
        });

        document.body.appendChild(btn);

        let hideTimer = null;

        // 备用点击事件（主要用于鼠标右键等情况）
        btn.addEventListener("click", (e) => {
            // 只有在没有拖拽的情况下才响应普通点击
            if (!isDragging && !dragStarted) {
                e.preventDefault();
                btn.style.transform = btn.style.transform.replace(/scale\([^)]*\)/g, '') + ' scale(0.85)';
                setTimeout(() => {
                    btn.style.transform = btn.style.transform.replace(/scale\([^)]*\)/g, '') + ' scale(1)';
                }, 150);
                toggleFullscreen();
            }
        });

        // 拖动功能（支持鼠标和触屏）
        let isDragging = false;
        let dragStarted = false;
        let offsetX = 0, offsetY = 0;
        let startTime = 0;
        let startPos = { x: 0, y: 0 };

        // 获取事件坐标（兼容鼠标和触摸）
        function getEventPos(e) {
            if (e.touches && e.touches.length > 0) {
                return { x: e.touches[0].clientX, y: e.touches[0].clientY };
            } else if (e.changedTouches && e.changedTouches.length > 0) {
                // 处理 touchend 事件
                return { x: e.changedTouches[0].clientX, y: e.changedTouches[0].clientY };
            }
            return { x: e.clientX, y: e.clientY };
        }

        // 开始拖拽
        function startDrag(e) {
            e.preventDefault();
            
            // 先显示完整按钮
            showFull();
            clearTimeout(hideTimer);
            
            const pos = getEventPos(e);
            startTime = Date.now();
            startPos = { x: pos.x, y: pos.y };
            
            // 获取当前实际位置（考虑transform偏移）
            const rect = btn.getBoundingClientRect();
            offsetX = pos.x - rect.left;
            offsetY = pos.y - rect.top;
            
            isDragging = true;
            dragStarted = false;
            btn.style.transition = "none";
        }

        // 拖拽移动
        function onDrag(e) {
            if (!isDragging) return;
            e.preventDefault();
            
            const pos = getEventPos(e);
            const distance = Math.sqrt(
                Math.pow(pos.x - startPos.x, 2) + Math.pow(pos.y - startPos.y, 2)
            );
            
            // 移动距离超过15px才认为是拖拽
            if (!dragStarted && distance > 15) {
                dragStarted = true;
                console.log('Drag started'); // 调试信息
            }
            
            if (dragStarted) {
                const x = pos.x - offsetX;
                const y = pos.y - offsetY;
                
                btn.style.left = `${x}px`;
                btn.style.top = `${y}px`;
                btn.style.right = "auto";
                btn.style.bottom = "auto";
            }
        }

        // 结束拖拽
        function endDrag(e) {
            if (!isDragging) return;
            
            const duration = Date.now() - startTime;
            let pos;
            
            // 特别处理 touchend 事件
            if (e.type === 'touchend') {
                pos = getEventPos(e);
            } else {
                pos = getEventPos(e);
            }
            
            const distance = Math.sqrt(
                Math.pow(pos.x - startPos.x, 2) + Math.pow(pos.y - startPos.y, 2)
            );
            
            console.log('Touch end:', { duration, distance, dragStarted }); // 调试信息
            
            isDragging = false;
            
            // 如果是快速点击（时间短且移动距离小），则直接切换全屏
            if (duration < 500 && distance < 15 && !dragStarted) {
                console.log('Triggering fullscreen'); // 调试信息
                // 点击动画
                btn.style.transform = btn.style.transform.replace(/scale\([^)]*\)/g, '') + ' scale(0.85)';
                setTimeout(() => {
                    btn.style.transform = btn.style.transform.replace(/scale\([^)]*\)/g, '') + ' scale(1)';
                }, 150);
                toggleFullscreen();
            } else if (dragStarted) {
                console.log('Snapping to edge'); // 调试信息
                snapToEdge();
            }
            
            dragStarted = false;
        }

        // 鼠标事件
        btn.addEventListener("mousedown", startDrag);
        document.addEventListener("mousemove", onDrag);
        document.addEventListener("mouseup", endDrag);

        // 触摸事件
        btn.addEventListener("touchstart", startDrag, { passive: false });
        document.addEventListener("touchmove", onDrag, { passive: false });
        document.addEventListener("touchend", endDrag, { passive: false });

        // 贴边 + 自动隐藏
        function snapToEdge() {
            const rect = btn.getBoundingClientRect();
            const vw = window.innerWidth;
            const vh = window.innerHeight;
            const margin = 8; // 与边缘保持8px距离

            let leftDist = rect.left;
            let rightDist = vw - rect.right;
            let topDist = rect.top;
            let bottomDist = vh - rect.bottom;

            let minDist = Math.min(leftDist, rightDist, topDist, bottomDist);

            btn.style.transition = "all 0.3s ease";

            if (minDist === leftDist) {
                btn.style.left = `${margin}px`;
                btn.style.right = "auto";
            } else if (minDist === rightDist) {
                btn.style.left = "auto";
                btn.style.right = `${margin}px`;
            } else if (minDist === topDist) {
                btn.style.top = `${margin}px`;
                btn.style.bottom = "auto";
            } else {
                btn.style.top = "auto";
                btn.style.bottom = `${margin}px`;
            }

            // 延迟自动隐藏
            hideTimer = setTimeout(() => hidePartial(), 1500);
        }

        function hidePartial() {
            if (isDragging) return;
            
            const rect = btn.getBoundingClientRect();
            const vw = window.innerWidth;
            const vh = window.innerHeight;
            const margin = 8;
            
            // 检查是否贴边
            if (rect.left <= margin + 5) {
                btn.style.transform = "translateX(-60%) scale(1)";
            } else if (vw - rect.right <= margin + 5) {
                btn.style.transform = "translateX(60%) scale(1)";
            } else if (rect.top <= margin + 5) {
                btn.style.transform = "translateY(-60%) scale(1)";
            } else if (vh - rect.bottom <= margin + 5) {
                btn.style.transform = "translateY(60%) scale(1)";
            }
            btn.style.opacity = "0.5";
        }

        function showFull() {
            clearTimeout(hideTimer);
            btn.style.transform = "translate(0,0) scale(1)";
            btn.style.opacity = "1";
        }

        // 悬浮显示
        btn.addEventListener("mouseenter", () => {
            if (!isDragging) {
                showFull();
            }
        });
        
        btn.addEventListener("mouseleave", () => {
            if (!isDragging) {
                hideTimer = setTimeout(() => hidePartial(), 1500);
            }
        });

        // 监听全屏状态变化
        document.addEventListener("fullscreenchange", () => {
            setTimeout(() => {
                if (!isDragging) {
                    snapToEdge();
                }
            }, 100);
        });

        // 窗口大小改变时重新贴边
        window.addEventListener("resize", () => {
            if (!isDragging) {
                snapToEdge();
            }
        });

        // 初始自动贴边
        setTimeout(() => snapToEdge(), 100);
    }

    // F11快捷键
    document.addEventListener("keydown", function (e) {
        if (e.code === "F11") {
            e.preventDefault();
            toggleFullscreen();
        }
    });

    // 页面加载完成后添加按钮
    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", addFullscreenButton);
    } else {
        addFullscreenButton();
    }
})();
