document.addEventListener('DOMContentLoaded', () => {
    const shell = document.getElementById('aiAssistantShell');
    const launcher = document.getElementById('aiAssistantLauncher');
    const launcherIcon = launcher ? launcher.querySelector('i') : null;
    const panel = document.getElementById('aiAssistantPanel');
    const closeButton = document.getElementById('aiAssistantClose');
    const form = document.getElementById('aiAssistantForm');
    const input = document.getElementById('aiAssistantInput');
    const messages = document.getElementById('aiAssistantMessages');
    const sendButton = form ? form.querySelector('.ai-send-button') : null;
    const config = window.FUDA_AI_CONFIG || { contextPath: '', currentPath: window.location.pathname };

    if (!shell || !launcher || !launcherIcon || !panel || !form || !input || !messages || !sendButton) {
        return;
    }

    const setOpenState = (isOpen) => {
        shell.classList.toggle('is-open', isOpen);
        panel.setAttribute('aria-hidden', String(!isOpen));
        launcher.setAttribute('aria-expanded', String(isOpen));
        launcherIcon.className = isOpen ? 'fas fa-chevron-down' : 'fas fa-robot';
        if (isOpen) {
            window.setTimeout(() => input.focus(), 160);
        }
    };

    const updateComposerState = () => {
        sendButton.classList.toggle('is-ready', input.value.trim().length > 0);
    };

    const appendMessage = (role, content) => {
        const wrapper = document.createElement('div');
        wrapper.className = `ai-message ai-message-${role}`;

        const bubble = document.createElement('div');
        bubble.className = 'ai-message-bubble';

        const text = document.createElement('p');
        text.className = 'ai-message-text';
        text.textContent = content;
        bubble.appendChild(text);
        wrapper.appendChild(bubble);

        if (role === 'assistant') {
            const meta = document.createElement('div');
            meta.className = 'ai-message-meta';
            meta.textContent = 'FUAI • AI Agent • Vừa xong';
            wrapper.appendChild(meta);
        }

        messages.appendChild(wrapper);
        messages.scrollTop = messages.scrollHeight;
    };

    const setLoading = (isLoading) => {
        shell.classList.toggle('is-loading', isLoading);
        sendButton.disabled = isLoading;
        input.disabled = isLoading;
    };

    const sendMessage = async () => {
        const text = input.value.trim();
        if (!text) {
            return;
        }

        appendMessage('user', text);
        input.value = '';
        input.style.height = 'auto';
        updateComposerState();
        setLoading(true);
        setOpenState(true);

        try {
            const body = new URLSearchParams();
            body.set('message', text);
            body.set('page', config.currentPath || window.location.pathname);

            const response = await fetch(`${config.contextPath}/ai-chat`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                },
                body: body.toString()
            });

            if (!response.ok) {
                throw new Error('request_failed');
            }

            const data = await response.json();
            appendMessage('assistant', data.reply || 'FUAI tạm bận, Quý khách thử lại giúp mình nhé.');
        } catch (error) {
            appendMessage('assistant', 'FUAI chưa kết nối được lúc này. Quý khách vui lòng thử lại sau ít phút nhé.');
        } finally {
            setLoading(false);
            updateComposerState();
        }
    };

    launcher.addEventListener('click', (event) => {
        event.preventDefault();
        event.stopPropagation();
        setOpenState(!shell.classList.contains('is-open'));
    });

    closeButton.addEventListener('click', (event) => {
        event.preventDefault();
        event.stopPropagation();
        setOpenState(false);
    });

    panel.addEventListener('click', (event) => {
        event.stopPropagation();
    });

    form.addEventListener('submit', (event) => {
        event.preventDefault();
        sendMessage();
    });

    input.addEventListener('input', () => {
        input.style.height = 'auto';
        input.style.height = `${Math.min(input.scrollHeight, 180)}px`;
        updateComposerState();
    });

    input.addEventListener('keydown', (event) => {
        if (event.key === 'Enter' && !event.shiftKey) {
            event.preventDefault();
            sendMessage();
        }
    });

    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape' && shell.classList.contains('is-open')) {
            setOpenState(false);
        }
    });

    updateComposerState();
});