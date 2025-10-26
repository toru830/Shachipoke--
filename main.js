// Main Game Initialization
document.addEventListener('DOMContentLoaded', () => {
    try {
        console.log('DOM loaded, initializing game...');
        
        // Initialize game state first
        if (typeof GameState !== 'undefined') {
            gameState = new GameState();
            console.log('GameState initialized');
        } else {
            throw new Error('GameState class not found');
        }
        
        // Initialize UI after game state
        if (typeof GameUI !== 'undefined') {
            gameUI = new GameUI();
            console.log('GameUI initialized');
        } else {
            throw new Error('GameUI class not found');
        }
        
        // Add additional mobile optimizations
        addMobileOptimizations();
        
        // Add performance optimizations
        addPerformanceOptimizations();
        
        // Add accessibility features
        addAccessibilityFeatures();
        
        // Initialize game after everything is ready
        setTimeout(() => {
            if (gameState && gameUI) {
                console.log('Initializing game...');
                gameUI.initializeGame();
            } else {
                console.error('Game state or UI not initialized');
                document.body.innerHTML = '<div style="padding: 20px; text-align: center;"><h1>初期化エラー</h1><p>ゲームの初期化に失敗しました。</p><button onclick="location.reload()">再読み込み</button></div>';
            }
        }, 500);
        
    } catch (error) {
        console.error('Initialization error:', error);
        document.body.innerHTML = '<div style="padding: 20px; text-align: center;"><h1>初期化エラー</h1><p>' + error.message + '</p><button onclick="location.reload()">再読み込み</button></div>';
    }
});

// Initialize global game state
let gameState;
let gameUI;

// Mobile optimizations
function addMobileOptimizations() {
    // Prevent zoom on double tap
    let lastTouchEnd = 0;
    document.addEventListener('touchend', (e) => {
        const now = (new Date()).getTime();
        if (now - lastTouchEnd <= 300) {
            e.preventDefault();
        }
        lastTouchEnd = now;
    }, false);
    
    // Prevent scrolling on body when modal is open
    document.addEventListener('touchmove', (e) => {
        if (document.getElementById('modal') && !document.getElementById('modal').classList.contains('hidden')) {
            e.preventDefault();
        }
    }, { passive: false });
    
    // Add viewport meta tag if not present
    if (!document.querySelector('meta[name="viewport"]')) {
        const viewport = document.createElement('meta');
        viewport.name = 'viewport';
        viewport.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
        document.head.appendChild(viewport);
    }
    
    // Add touch feedback for buttons
    document.addEventListener('touchstart', (e) => {
        if (e.target.matches('button, .nav-btn, .character-card, .shop-item, .choice-btn')) {
            e.target.style.transform = 'scale(0.95)';
        }
    });
    
    document.addEventListener('touchend', (e) => {
        if (e.target.matches('button, .nav-btn, .character-card, .shop-item, .choice-btn')) {
            e.target.style.transform = '';
        }
    });
}

// Performance optimizations
function addPerformanceOptimizations() {
    // Debounce resize events
    let resizeTimeout;
    window.addEventListener('resize', () => {
        clearTimeout(resizeTimeout);
        resizeTimeout = setTimeout(() => {
            // Handle resize if needed
            updateResponsiveLayout();
        }, 250);
    });
    
    // Lazy load images and icons
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                // Load content when visible
                loadVisibleContent(entry.target);
            }
        });
    });
    
    // Observe elements that need lazy loading
    document.querySelectorAll('.character-icon, .shop-item-icon').forEach(el => {
        observer.observe(el);
    });
    
    // Optimize animations
    document.documentElement.style.setProperty('--animation-duration', '0.3s');
    
    // Preload critical resources
    preloadCriticalResources();
}

// Accessibility features
function addAccessibilityFeatures() {
    // Add keyboard navigation
    document.addEventListener('keydown', (e) => {
        handleKeyboardNavigation(e);
    });
    
    // Add ARIA labels
    addAriaLabels();
    
    // Add focus management
    addFocusManagement();
    
    // Add screen reader support
    addScreenReaderSupport();
}

// Handle keyboard navigation
function handleKeyboardNavigation(e) {
    const currentScreen = gameState?.getCurrentScreen() || 'loading';
    
    switch (e.key) {
        case 'Escape':
            if (document.getElementById('modal') && !document.getElementById('modal').classList.contains('hidden')) {
                gameUI.hideModal();
            }
            break;
        case 'Enter':
            if (currentScreen === 'character-selection' && gameState?.selectedCharacter) {
                gameUI.confirmCharacterSelection();
            }
            break;
        case 'ArrowLeft':
        case 'ArrowRight':
            if (currentScreen === 'character-selection') {
                navigateCharacterSelection(e.key === 'ArrowRight' ? 1 : -1);
            }
            break;
    }
}

// Navigate character selection with keyboard
function navigateCharacterSelection(direction) {
    const characters = document.querySelectorAll('.character-card');
    const currentIndex = Array.from(characters).findIndex(card => card.classList.contains('selected'));
    let newIndex = currentIndex + direction;
    
    if (newIndex < 0) newIndex = characters.length - 1;
    if (newIndex >= characters.length) newIndex = 0;
    
    const newCard = characters[newIndex];
    if (newCard) {
        newCard.click();
        newCard.focus();
    }
}

// Add ARIA labels
function addAriaLabels() {
    // Add labels to interactive elements
    document.querySelectorAll('.nav-btn').forEach(btn => {
        const screen = btn.dataset.screen;
        const label = btn.querySelector('span:last-child').textContent;
        btn.setAttribute('aria-label', `${label}画面に移動`);
    });
    
    document.querySelectorAll('.character-card').forEach(card => {
        const name = card.querySelector('.character-name').textContent;
        card.setAttribute('aria-label', `キャラクター ${name} を選択`);
    });
    
    document.querySelectorAll('.shop-item').forEach(item => {
        const name = item.querySelector('.shop-item-name').textContent;
        const price = item.querySelector('.shop-item-price').textContent;
        item.setAttribute('aria-label', `${name} - ${price}`);
    });
}

// Add focus management
function addFocusManagement() {
    // Manage focus when screens change
    const originalShowScreen = gameUI.showScreen;
    gameUI.showScreen = function(screenName) {
        originalShowScreen.call(this, screenName);
        
        // Focus first interactive element
        setTimeout(() => {
            const firstFocusable = document.querySelector('.screen:not(.hidden) button, .screen:not(.hidden) [tabindex="0"]');
            if (firstFocusable) {
                firstFocusable.focus();
            }
        }, 100);
    };
}

// Add screen reader support
function addScreenReaderSupport() {
    // Add live region for announcements
    const liveRegion = document.createElement('div');
    liveRegion.setAttribute('aria-live', 'polite');
    liveRegion.setAttribute('aria-atomic', 'true');
    liveRegion.className = 'sr-only';
    liveRegion.id = 'live-region';
    document.body.appendChild(liveRegion);
    
    // Announce important changes
    const originalShowToast = gameState?.showToast;
    if (originalShowToast) {
        gameState.showToast = function(message, type) {
            originalShowToast.call(this, message, type);
            announceToScreenReader(message);
        };
    }
}

// Announce to screen reader
function announceToScreenReader(message) {
    const liveRegion = document.getElementById('live-region');
    if (liveRegion) {
        liveRegion.textContent = message;
        setTimeout(() => {
            liveRegion.textContent = '';
        }, 1000);
    }
}

// Update responsive layout
function updateResponsiveLayout() {
    const screenWidth = window.innerWidth;
    
    // Adjust grid columns based on screen size
    if (screenWidth < 480) {
        document.documentElement.style.setProperty('--grid-columns', '2');
    } else if (screenWidth < 768) {
        document.documentElement.style.setProperty('--grid-columns', '3');
    } else {
        document.documentElement.style.setProperty('--grid-columns', '4');
    }
}

// Load visible content
function loadVisibleContent(element) {
    // Add loading animation
    element.classList.add('loading');
    
    // Simulate content loading
    setTimeout(() => {
        element.classList.remove('loading');
        element.classList.add('loaded');
    }, 200);
}

// Preload critical resources
function preloadCriticalResources() {
    // Preload character icons (using emoji, so no actual preloading needed)
    // Preload shop item icons (using emoji, so no actual preloading needed)
    // Preload any other critical assets
    
    // Add preload hints for better performance
    const preloadLink = document.createElement('link');
    preloadLink.rel = 'preload';
    preloadLink.href = 'styles.css';
    preloadLink.as = 'style';
    document.head.appendChild(preloadLink);
}

// Add error handling
window.addEventListener('error', (e) => {
    console.error('Game error:', e.error);
    
    // Show user-friendly error message
    if (gameState) {
        gameState.showToast('エラーが発生しました。ページを再読み込みしてください。', 'error');
    }
});

// Add unhandled promise rejection handling
window.addEventListener('unhandledrejection', (e) => {
    console.error('Unhandled promise rejection:', e.reason);
    
    // Show user-friendly error message
    if (gameState) {
        gameState.showToast('エラーが発生しました。ページを再読み込みしてください。', 'error');
    }
});

// Add service worker for offline support (if needed)
if ('serviceWorker' in navigator) {
    window.addEventListener('load', () => {
        // Register service worker for offline support
        // This would be implemented if we had actual assets to cache
    });
}

// Add PWA features
function addPWAFeatures() {
    // Add manifest for PWA installation
    const manifest = {
        name: 'Shachipoke2',
        short_name: 'Shachipoke2',
        description: 'Office Worker Character Raising Simulation Game',
        start_url: '/',
        display: 'standalone',
        background_color: '#667eea',
        theme_color: '#764ba2',
        icons: [
            {
                src: 'icon-192.png',
                sizes: '192x192',
                type: 'image/png'
            },
            {
                src: 'icon-512.png',
                sizes: '512x512',
                type: 'image/png'
            }
        ]
    };
    
    // Create manifest link
    const manifestLink = document.createElement('link');
    manifestLink.rel = 'manifest';
    manifestLink.href = 'data:application/json;base64,' + btoa(JSON.stringify(manifest));
    document.head.appendChild(manifestLink);
}

// Initialize PWA features (disabled for now)
// addPWAFeatures();

// Add analytics (placeholder)
function addAnalytics() {
    // Add game analytics tracking
    const trackEvent = (eventName, parameters = {}) => {
        console.log('Analytics event:', eventName, parameters);
        // Implement actual analytics tracking here
    };
    
    // Track game events
    window.trackGameEvent = trackEvent;
}

// Initialize analytics
addAnalytics();

// Add debug tools (development only)
if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
    window.debugGame = {
        addCurrency: (amount) => gameState?.addCurrency(amount),
        setStats: (stats) => gameState?.updateStats(stats),
        resetGame: () => gameState?.resetGame(),
        getState: () => gameState?.state,
        showScreen: (screen) => gameUI?.showScreen(screen)
    };
    
    console.log('Debug tools available: window.debugGame');
}
