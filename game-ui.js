// UI Management System
if (typeof GameUI === 'undefined') {
class GameUI {
    constructor() {
        this.currentScreen = 'loading';
        this.selectedCharacterId = null;
        this.selectedChoice = null;
        this.modalCallback = null;
        
        this.initializeEventListeners();
    }
    
    // Initialize all event listeners
    initializeEventListeners() {
        // Character selection
        document.getElementById('confirm-character')?.addEventListener('click', () => {
            this.confirmCharacterSelection();
        });
        
        // Navigation buttons
        document.querySelectorAll('.nav-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const screen = e.currentTarget.dataset.screen;
                this.showScreen(screen);
            });
        });
        
        // Back buttons
        document.querySelectorAll('.back-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const backScreen = e.currentTarget.dataset.back;
                this.showScreen(backScreen);
            });
        });
        
        // Settings buttons
        document.getElementById('save-game')?.addEventListener('click', () => {
            gameState.saveGame();
        });
        
        document.getElementById('load-game')?.addEventListener('click', () => {
            gameState.loadGame();
            this.updateUI();
        });
        
        document.getElementById('reset-game')?.addEventListener('click', () => {
            this.showModal('ゲームリセット', '本当にゲームをリセットしますか？すべてのデータが失われます。', () => {
                if (gameState.resetGame()) {
                    this.showScreen('character-selection');
                    this.updateUI();
                }
            });
        });
        
        // Modal buttons
        document.getElementById('modal-cancel')?.addEventListener('click', () => {
            this.hideModal();
        });
        
        document.getElementById('modal-confirm')?.addEventListener('click', () => {
            if (this.modalCallback) {
                this.modalCallback();
            }
            this.hideModal();
        });
    }
    
    // Show specific screen
    showScreen(screenName) {
        // Hide all screens
        document.querySelectorAll('.screen').forEach(screen => {
            screen.classList.add('hidden');
        });
        
        // Show target screen
        const targetScreen = document.getElementById(`${screenName}-screen`) || document.getElementById(screenName);
        if (targetScreen) {
            targetScreen.classList.remove('hidden');
            this.currentScreen = screenName;
            
            // Update UI based on screen
            this.updateScreenContent(screenName);
        }
    }
    
    // Update screen content based on current screen
    updateScreenContent(screenName) {
        switch (screenName) {
            case 'character-selection':
                this.updateCharacterSelection();
                break;
            case 'main':
                this.updateMainScreen();
                break;
            case 'events':
                this.updateEventsScreen();
                break;
            case 'shop':
                this.updateShopScreen();
                break;
            case 'formation':
                this.updateFormationScreen();
                break;
            case 'settings':
                this.updateSettingsScreen();
                break;
        }
    }
    
    // Update character selection screen
    updateCharacterSelection() {
        const characterGrid = document.getElementById('character-grid');
        if (!characterGrid) return;
        
        characterGrid.innerHTML = '';
        
        CHARACTERS.forEach(character => {
            const characterCard = document.createElement('div');
            characterCard.className = 'character-card';
            characterCard.dataset.characterId = character.id;
            
            characterCard.innerHTML = `
                <div class="character-icon">
                    <img src="10_社畜アイコン/${character.icon}" alt="${character.name}" style="width: 100%; height: 100%; object-fit: contain;">
                </div>
                <div class="character-name">${character.name}</div>
                <div class="character-level">Lv.1</div>
            `;
            
            characterCard.addEventListener('click', () => {
                this.selectCharacter(character.id);
            });
            
            characterGrid.appendChild(characterCard);
        });
    }
    
    // Select character in character selection
    selectCharacter(characterId) {
        // Remove previous selection
        document.querySelectorAll('.character-card').forEach(card => {
            card.classList.remove('selected');
        });
        
        // Add selection to clicked card
        const selectedCard = document.querySelector(`[data-character-id="${characterId}"]`);
        if (selectedCard) {
            selectedCard.classList.add('selected');
        }
        
        this.selectedCharacterId = characterId;
        this.updateCharacterPreview(characterId);
        
        // Enable confirm button
        const confirmBtn = document.getElementById('confirm-character');
        if (confirmBtn) {
            confirmBtn.disabled = false;
        }
    }
    
    // Update character preview
    updateCharacterPreview(characterId) {
        const character = getCharacterById(characterId);
        if (!character) return;
        
        const previewImage = document.querySelector('.preview-image');
        const previewName = document.getElementById('preview-name');
        const previewStress = document.getElementById('preview-stress');
        const previewKnowledge = document.getElementById('preview-knowledge');
        const previewPhysical = document.getElementById('preview-physical');
        const previewCommunication = document.getElementById('preview-communication');
        
        if (previewImage) {
            previewImage.innerHTML = `<img src="10_社畜アイコン/${character.icon}" alt="${character.name}" style="width: 100%; height: 100%; object-fit: contain;">`;
        }
        if (previewName) previewName.textContent = character.name;
        if (previewStress) previewStress.textContent = character.baseStats.stress;
        if (previewKnowledge) previewKnowledge.textContent = character.baseStats.knowledge;
        if (previewPhysical) previewPhysical.textContent = character.baseStats.physical;
        if (previewCommunication) previewCommunication.textContent = character.baseStats.communication;
    }
    
    // Confirm character selection
    confirmCharacterSelection() {
        if (!this.selectedCharacterId) {
            console.error('No character selected');
            return;
        }
        
        console.log('Confirming character selection:', this.selectedCharacterId);
        
        if (gameState.startNewGame(this.selectedCharacterId)) {
            console.log('Game started successfully, switching to main screen');
            this.showScreen('main');
            this.updateUI();
        } else {
            console.error('Failed to start game');
        }
    }
    
    // Update main screen
    updateMainScreen() {
        if (!gameState.isGameStarted()) {
            this.showScreen('character-selection');
            return;
        }
        
        const character = gameState.getCurrentCharacter();
        if (!character) {
            console.error('Character not found, redirecting to character selection');
            this.showScreen('character-selection');
            return;
        }
        
        const stats = gameState.getCurrentStats();
        const currency = gameState.getCurrency();
        const level = gameState.getPlayerLevel();
        
        // Update character display
        const characterImage = document.getElementById('main-character-image');
        const characterName = document.getElementById('character-name');
        const characterLevel = document.getElementById('character-level');
        
        if (characterImage) {
            characterImage.innerHTML = `<img src="10_社畜アイコン/${character.icon}" alt="${character.name}" style="width: 100%; height: 100%; object-fit: contain;">`;
        }
        if (characterName) characterName.textContent = character.name;
        if (characterLevel) characterLevel.textContent = level;
        
        // Update currency
        const currencyAmount = document.getElementById('currency-amount');
        if (currencyAmount) currencyAmount.textContent = currency;
        
        // Update stats
        this.updateStatsDisplay(stats);
    }
    
    // Update stats display
    updateStatsDisplay(stats) {
        const statNames = ['stress', 'knowledge', 'physical', 'communication'];
        const statLabels = ['耐ストレス', '知識', '体力', 'コミュ力'];
        const statIcons = ['😤', '🧠', '💪', '💬'];
        
        statNames.forEach((stat, index) => {
            const value = stats[stat] || 0;
            const percentage = (value / GAME_CONFIG.MAX_STAT_VALUE) * 100;
            
            const statBar = document.getElementById(`${stat}-bar`);
            const statValue = document.getElementById(`${stat}-value`);
            
            if (statBar) {
                statBar.style.width = `${percentage}%`;
                statBar.style.backgroundColor = getStatColor(value);
            }
            if (statValue) {
                statValue.textContent = value;
            }
        });
    }
    
    // Update events screen
    updateEventsScreen() {
        const eventsContent = document.getElementById('events-content');
        const eventsRemaining = document.getElementById('events-remaining');
        
        if (!eventsContent) return;
        
        const availableEvents = gameState.getAvailableEvents();
        const remaining = gameState.getEventsRemaining();
        
        if (eventsRemaining) {
            eventsRemaining.textContent = remaining;
        }
        
        eventsContent.innerHTML = '';
        
        if (availableEvents.length === 0) {
            eventsContent.innerHTML = `
                <div class="event-card">
                    <div class="event-title">今日のイベント完了</div>
                    <p>今日のイベントはすべて完了しました。また明日お越しください！</p>
                </div>
            `;
            return;
        }
        
        availableEvents.forEach((event, index) => {
            const eventCard = document.createElement('div');
            eventCard.className = 'event-card';
            eventCard.innerHTML = `
                <div class="event-title">${event.title}</div>
                <p>${event.description}</p>
                <div class="event-choices">
                    ${event.choices.map((choice, choiceIndex) => `
                        <button class="choice-btn" data-event-id="${event.id}" data-choice-index="${choiceIndex}">
                            ${choice.text}
                        </button>
                    `).join('')}
                </div>
            `;
            
            eventsContent.appendChild(eventCard);
        });
        
        // Add event listeners for choices
        eventsContent.querySelectorAll('.choice-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const eventId = e.currentTarget.dataset.eventId;
                const choiceIndex = parseInt(e.currentTarget.dataset.choiceIndex);
                this.selectEventChoice(eventId, choiceIndex, e.currentTarget);
            });
        });
    }
    
    // Select event choice
    selectEventChoice(eventId, choiceIndex, buttonElement) {
        // Remove previous selection
        document.querySelectorAll('.choice-btn').forEach(btn => {
            btn.classList.remove('selected');
        });
        
        // Add selection to clicked button
        buttonElement.classList.add('selected');
        this.selectedChoice = { eventId, choiceIndex };
        
        // Show confirm button or auto-complete
        setTimeout(() => {
            this.completeEvent(eventId, choiceIndex);
        }, 1000);
    }
    
    // Complete event
    completeEvent(eventId, choiceIndex) {
        if (gameState.completeEvent(eventId, choiceIndex)) {
            const event = EVENTS.find(e => e.id === eventId);
            const choice = event.choices[choiceIndex];
            
            // Show feedback
            const eventCard = document.querySelector(`[data-event-id="${eventId}"]`).closest('.event-card');
            if (eventCard) {
                const feedback = document.createElement('div');
                feedback.className = `event-feedback ${choice.effects.stress < 0 ? 'error' : ''}`;
                feedback.textContent = choice.feedback;
                eventCard.appendChild(feedback);
            }
            
            // Update UI
            this.updateUI();
            
            // Auto-hide after 3 seconds
            setTimeout(() => {
                this.updateEventsScreen();
            }, 3000);
        }
    }
    
    // Update shop screen
    updateShopScreen() {
        const shopItems = document.getElementById('shop-items');
        if (!shopItems) return;
        
        shopItems.innerHTML = '';
        
        SHOP_ITEMS.forEach(item => {
            const shopItem = document.createElement('div');
            shopItem.className = 'shop-item';
            shopItem.innerHTML = `
                <div class="shop-item-icon">${item.icon}</div>
                <div class="shop-item-name">${item.name}</div>
                <div class="shop-item-price">${item.price}シャチ</div>
                <div class="shop-item-effects">
                    ${Object.entries(item.effects).map(([stat, value]) => 
                        `${stat === 'stress' ? '耐ストレス' : 
                          stat === 'knowledge' ? '知識' : 
                          stat === 'physical' ? '体力' : 'コミュ力'}: ${value > 0 ? '+' : ''}${value}`
                    ).join(', ')}
                </div>
                <button class="btn-primary" data-item-id="${item.id}">購入</button>
            `;
            
            // Check if player can afford
            if (gameState.getCurrency() < item.price) {
                shopItem.classList.add('disabled');
                shopItem.querySelector('button').disabled = true;
            }
            
            shopItems.appendChild(shopItem);
        });
        
        // Add event listeners for purchase buttons
        shopItems.querySelectorAll('button[data-item-id]').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const itemId = e.currentTarget.dataset.itemId;
                this.purchaseItem(itemId);
            });
        });
    }
    
    // Purchase item
    purchaseItem(itemId) {
        if (gameState.purchaseItem(itemId)) {
            this.updateUI();
            this.updateShopScreen();
        }
    }
    
    // Update formation screen
    updateFormationScreen() {
        this.updatePartyFormation();
        this.updateOwnedCharacters();
        this.updatePurchasableCharacters();
    }
    
    // Update party formation
    updatePartyFormation() {
        const partySlots = document.getElementById('party-slots');
        if (!partySlots) return;
        
        partySlots.innerHTML = '';
        
        for (let i = 0; i < 4; i++) {
            const slot = document.createElement('div');
            slot.className = 'party-slot';
            slot.dataset.slotIndex = i;
            
            const characterId = gameState.state.partyFormation[i];
            if (characterId) {
                const character = getCharacterById(characterId);
                if (character) {
                    slot.classList.add('occupied');
                    slot.innerHTML = `
                        <div class="character-icon">
                            <img src="10_社畜アイコン/${character.icon}" alt="${character.name}" style="width: 100%; height: 100%; object-fit: contain;">
                        </div>
                    `;
                }
            }
            
            slot.addEventListener('click', () => {
                this.selectPartySlot(i);
            });
            
            partySlots.appendChild(slot);
        }
    }
    
    // Update owned characters
    updateOwnedCharacters() {
        const ownedCharacters = document.getElementById('owned-characters');
        if (!ownedCharacters) return;
        
        ownedCharacters.innerHTML = '';
        
        const owned = gameState.getOwnedCharacters();
        owned.forEach(character => {
            const characterItem = document.createElement('div');
            characterItem.className = 'character-item owned';
            characterItem.dataset.characterId = character.id;
            characterItem.innerHTML = `
                <div class="character-icon">
                    <img src="10_社畜アイコン/${character.icon}" alt="${character.name}" style="width: 100%; height: 100%; object-fit: contain;">
                </div>
                <div class="character-name">${character.name}</div>
            `;
            
            characterItem.addEventListener('click', () => {
                this.selectCharacterForParty(character.id);
            });
            
            ownedCharacters.appendChild(characterItem);
        });
    }
    
    // Update purchasable characters
    updatePurchasableCharacters() {
        const purchasableCharacters = document.getElementById('purchasable-characters');
        if (!purchasableCharacters) return;
        
        purchasableCharacters.innerHTML = '';
        
        const purchasable = gameState.getPurchasableCharacters();
        purchasable.forEach(character => {
            const characterItem = document.createElement('div');
            characterItem.className = 'character-item';
            characterItem.dataset.characterId = character.id;
            characterItem.innerHTML = `
                <div class="character-icon">
                    <img src="10_社畜アイコン/${character.icon}" alt="${character.name}" style="width: 100%; height: 100%; object-fit: contain;">
                </div>
                <div class="character-name">${character.name}</div>
                <div class="character-price">${GAME_CONFIG.CHARACTER_PRICE}シャチ</div>
            `;
            
            // Check if player can afford
            if (gameState.getCurrency() < GAME_CONFIG.CHARACTER_PRICE) {
                characterItem.classList.add('disabled');
            }
            
            characterItem.addEventListener('click', () => {
                this.purchaseCharacter(character.id);
            });
            
            purchasableCharacters.appendChild(characterItem);
        });
    }
    
    // Select party slot
    selectPartySlot(slotIndex) {
        // Implementation for party slot selection
        console.log('Selected party slot:', slotIndex);
    }
    
    // Select character for party
    selectCharacterForParty(characterId) {
        // Implementation for character selection for party
        console.log('Selected character for party:', characterId);
    }
    
    // Purchase character
    purchaseCharacter(characterId) {
        if (gameState.purchaseCharacter(characterId)) {
            this.updateUI();
            this.updateFormationScreen();
        }
    }
    
    // Update settings screen
    updateSettingsScreen() {
        this.updateVideoGallery();
        this.updateGameStats();
    }
    
    // Update video gallery
    updateVideoGallery() {
        const videoGallery = document.getElementById('video-gallery');
        if (!videoGallery) return;
        
        videoGallery.innerHTML = '';
        
        VIDEOS.forEach(video => {
            const videoItem = document.createElement('div');
            videoItem.className = 'video-item';
            videoItem.innerHTML = `
                <div class="video-icon">${video.icon}</div>
                <div class="video-name">${video.name}</div>
            `;
            
            videoItem.addEventListener('click', () => {
                this.playVideo(video.filename);
            });
            
            videoGallery.appendChild(videoItem);
        });
    }
    
    // Play video
    playVideo(filename) {
        // Implementation for video playback
        console.log('Playing video:', filename);
        this.showToast('動画再生機能は準備中です', 'warning');
    }
    
    // Update game stats
    updateGameStats() {
        const gameStats = document.getElementById('game-stats');
        if (!gameStats) return;
        
        const stats = gameState.getGameStats();
        
        gameStats.innerHTML = `
            <div class="stat-card">
                <div class="stat-value">${stats.eventsCompleted}</div>
                <div class="stat-label">完了イベント</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${stats.itemsPurchased}</div>
                <div class="stat-label">購入アイテム</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${stats.charactersUnlocked}</div>
                <div class="stat-label">解放キャラクター</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${stats.currentLevel}</div>
                <div class="stat-label">現在レベル</div>
            </div>
        `;
    }
    
    // Show modal
    showModal(title, message, callback) {
        const modal = document.getElementById('modal');
        const modalTitle = document.getElementById('modal-title');
        const modalMessage = document.getElementById('modal-message');
        
        if (modalTitle) modalTitle.textContent = title;
        if (modalMessage) modalMessage.textContent = message;
        
        this.modalCallback = callback;
        modal.classList.remove('hidden');
    }
    
    // Hide modal
    hideModal() {
        const modal = document.getElementById('modal');
        modal.classList.add('hidden');
        this.modalCallback = null;
    }
    
    // Update entire UI
    updateUI() {
        this.updateMainScreen();
    }
    
    // Initialize game
    initializeGame() {
        console.log('GameUI: Initializing game...');
        
        // Show loading screen first
        this.showScreen('loading');
        
        // Simulate loading
        setTimeout(() => {
            console.log('GameUI: Loading complete, checking game state...');
            if (gameState && gameState.isGameStarted()) {
                console.log('GameUI: Game already started, showing main screen');
                this.showScreen('main');
            } else {
                console.log('GameUI: No game started, showing character selection');
                this.showScreen('character-selection');
            }
            this.updateUI();
        }, 1500);
    }
}

}
