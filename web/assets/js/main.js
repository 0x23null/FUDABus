document.addEventListener('DOMContentLoaded', () => {
    const header = document.querySelector('.main-header');
    if (header) {
        const syncHeaderState = () => {
            if (window.scrollY > 8) {
                header.style.background = 'rgba(255, 255, 255, 0.88)';
                header.style.boxShadow = '0 12px 30px -28px rgba(22, 32, 51, 0.45)';
            } else {
                header.style.background = 'rgba(255, 255, 255, 0.8)';
                header.style.boxShadow = 'none';
            }
        };

        syncHeaderState();
        window.addEventListener('scroll', syncHeaderState, { passive: true });
    }

    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const targetSelector = this.getAttribute('href');
            if (!targetSelector || targetSelector === '#') {
                return;
            }

            const target = document.querySelector(targetSelector);
            if (!target) {
                return;
            }

            e.preventDefault();
            target.scrollIntoView({ behavior: 'smooth' });
        });
    });

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('is-visible');
                observer.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.12,
        rootMargin: '0px 0px -48px 0px'
    });

    document.querySelectorAll('.animate-on-scroll, .reveal').forEach(el => {
        observer.observe(el);
    });
});
