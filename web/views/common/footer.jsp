<%@page contentType="text/html" pageEncoding="UTF-8" %>
<footer>
    <div class="container">
        <div class="footer-grid">
            <div class="footer-col">
                <a href="${pageContext.request.contextPath}/" class="logo" style="margin-bottom: 20px; display: inline-block;">
                    <i class="fas fa-bus-alt"></i> FUDA Bus
                </a>
                <p style="color: var(--text-secondary); max-width: 320px;">
                    &#272;&#7863;t v&#233; xe &#273;&#432;&#7901;ng d&#224;i nhanh g&#7885;n, r&#245; r&#224;ng v&#224; d&#7877; d&#249;ng. FUDA Bus t&#7853;p trung v&#224;o tr&#7843;i nghi&#7879;m m&#432;&#7907;t,
                    th&#244;ng tin minh b&#7841;ch v&#224; h&#7895; tr&#7907; k&#7883;p th&#7901;i cho t&#7915;ng h&#224;nh tr&#236;nh.
                </p>
                <div style="display: flex; gap: 15px; margin-top: 20px;">
                    <a href="#" style="color: var(--text-secondary); font-size: 20px;"><i class="fab fa-facebook"></i></a>
                    <a href="#" style="color: var(--text-secondary); font-size: 20px;"><i class="fab fa-instagram"></i></a>
                    <a href="#" style="color: var(--text-secondary); font-size: 20px;"><i class="fab fa-youtube"></i></a>
                </div>
            </div>

            <div class="footer-col">
                <h4>Kh&#225;m ph&#225;</h4>
                <ul>
                    <li><a href="#">V&#7873; FUDA Bus</a></li>
                    <li><a href="#">Tuy&#7871;n ph&#7893; bi&#7871;n</a></li>
                    <li><a href="#">&#272;&#7897;i xe</a></li>
                    <li><a href="#">Tin t&#7913;c</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4>H&#7895; tr&#7907;</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/support">Trung t&#226;m h&#7895; tr&#7907;</a></li>
                    <li><a href="#">Ch&#237;nh s&#225;ch &#273;&#7863;t v&#233;</a></li>
                    <li><a href="#">Ch&#237;nh s&#225;ch b&#7843;o m&#7853;t</a></li>
                    <li><a href="#">&#272;i&#7873;u kho&#7843;n d&#7883;ch v&#7909;</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4>Li&#234;n h&#7879;</h4>
                <ul>
                    <li><i class="fas fa-phone-alt" style="margin-right: 8px; font-size: 12px;"></i> 1900 3636</li>
                    <li><i class="fas fa-envelope" style="margin-right: 8px; font-size: 12px;"></i> hello@fudabus.vn</li>
                    <li><i class="fas fa-map-marker-alt" style="margin-right: 8px; font-size: 12px;"></i> &#272;&#224; N&#7861;ng, Vi&#7879;t Nam</li>
                </ul>
            </div>
        </div>

        <div style="text-align: center; padding-top: 30px; border-top: 1px solid var(--border-color); color: var(--text-secondary); font-size: 14px;">
            &copy; 2026 FUDA Bus. B&#7843;o l&#432;u m&#7885;i quy&#7873;n.
        </div>
    </div>
</footer>

<div class="ai-assistant-shell" id="aiAssistantShell">
    <div class="ai-assistant-panel" id="aiAssistantPanel" aria-hidden="true">
        <div class="ai-assistant-header">
            <div class="ai-assistant-identity">
                <div class="ai-assistant-avatar">
                    <i class="fas fa-robot"></i>
                </div>
                <div class="ai-assistant-heading">
                    <strong>FUAI</strong>
                    <p>Tr&#7907; l&#253; &#7843;o c&#7911;a FUDA Bus</p>
                </div>
            </div>
            <button type="button" class="ai-assistant-close" id="aiAssistantClose" aria-label="&#272;&#243;ng tr&#7907; l&#253; AI">
                <i class="fas fa-times"></i>
            </button>
        </div>

        <div class="ai-assistant-body">
            <div class="ai-assistant-messages" id="aiAssistantMessages">
                <div class="ai-message ai-message-assistant">
                    <div class="ai-message-bubble">
                        <p class="ai-message-text">Ch&#224;o b&#7841;n, m&#236;nh l&#224; FUAI c&#7911;a FUDA Bus. B&#7841;n mu&#7889;n t&#236;m chuy&#7871;n, tra c&#7913;u v&#233; hay c&#7847;n h&#7895; tr&#7907; thanh to&#225;n?</p>
                    </div>
                    <div class="ai-message-meta">FUAI &#8226; Tr&#7907; l&#253; &#7843;o &#8226; V&#7915;a xong</div>
                </div>
            </div>
        </div>

        <form class="ai-assistant-form" id="aiAssistantForm">
            <div class="ai-composer">
                <textarea id="aiAssistantInput" rows="1" placeholder="Nh&#7855;n cho FUAI..."></textarea>
                <div class="ai-composer-toolbar ai-composer-toolbar-simple">
                    <button type="submit" class="ai-send-button" aria-label="G&#7917;i tin nh&#7855;n">
                        <i class="fas fa-arrow-up"></i>
                    </button>
                </div>
            </div>
        </form>
    </div>

    <button type="button" class="ai-assistant-launcher" id="aiAssistantLauncher" aria-label="M&#7903; tr&#7907; l&#253; AI" aria-expanded="false">
        <i class="fas fa-robot"></i>
    </button>
</div>

<script>
window.FUDA_AI_CONFIG = {
    contextPath: '${pageContext.request.contextPath}',
    currentPath: '${pageContext.request.requestURI}'
};
</script>
<script src="${pageContext.request.contextPath}/assets/js/ai-chat.js?v=5"></script>

