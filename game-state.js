// Game State Management
if (typeof GameState === 'undefined') {
class GameState {
    constructor() {
        this.state = {
            // Game progress
            currentScreen: 'loading',
            gameStarted: false,
            selectedCharacter: null,
            playerLevel: 1,
            currency: GAME_CONFIG.INITIAL_CURRENCY,
            
            // Character data
            ownedCharacters: [],
            partyFormation: [null, null, null, null],
            currentCharacterStats: {
                stress: 0,
                knowledge: 0,
                physical: 0,
                communication: 0
            },
            
            // Daily system
            lastPlayDate: null,
            eventsCompletedToday: 0,
            dailyEvents: [],
            
            // Shop data
            purchasedItems: [],
            
            // Game statistics
            totalPlayTime: 0,
            eventsCompleted: 0,
            itemsPurchased: 0,
            charactersUnlocked: 0,
            
            // Settings
            audioEnabled: true,
            notificationsEnabled: true,
            
            // Version control
            version: GAME_CONFIG.VERSION,
            saveDate: null
        };
        
        this.loadGame();
    }
    
    // Save game to localStorage
    saveGame() {
        try {
            this.state.saveDate = new Date().toISOString();
            const saveData = JSON.stringify(this.state);
            localStorage.setItem(GAME_CONFIG.SAVE_KEY, saveData);
            this.showToast('ゲームを保存しました', 'success');
            return true;
        } catch (error) {
            console.error('Save failed:', error);
            this.showToast('保存に失敗しました', 'error');
            return false;
        }
    }
    
    // Load game from localStorage
    loadGame() {
        try {
            const saveData = localStorage.getItem(GAME_CONFIG.SAVE_KEY);
            if (saveData) {
                const loadedState = JSON.parse(saveData);
                
                // Check version compatibility
                if (loadedState.version === GAME_CONFIG.VERSION) {
                    // Check if selected character still exists
                    if (loadedState.selectedCharacter) {
                        const character = getCharacterById(loadedState.selectedCharacter);
                        if (!character) {
                            console.warn('Selected character no longer exists, clearing save data');
                            localStorage.removeItem(GAME_CONFIG.SAVE_KEY);
                            return false;
                        }
                    }
                    
                    this.state = { ...this.state, ...loadedState };
                    this.checkDailyReset();
                    return true;
                } else {
                    console.warn('Save version mismatch, starting fresh');
                    localStorage.removeItem(GAME_CONFIG.SAVE_KEY);
                    this.showToast('セーブデータのバージョンが異なります', 'warning');
                }
            }
        } catch (error) {
            console.error('Load failed:', error);
            localStorage.removeItem(GAME_CONFIG.SAVE_KEY);
            this.showToast('読み込みに失敗しました', 'error');
        }
        return false;
    }
    
    // Reset game to initial state
    resetGame() {
        if (confirm('本当にゲームをリセットしますか？すべてのデータが失われます。')) {
            localStorage.removeItem(GAME_CONFIG.SAVE_KEY);
            this.state = new GameState().state;
            this.showToast('ゲームをリセットしました', 'success');
            return true;
        }
        return false;
    }
    
    // Check if daily reset is needed
    checkDailyReset() {
        const today = new Date().toDateString();
        if (this.state.lastPlayDate !== today) {
            this.state.lastPlayDate = today;
            this.state.eventsCompletedToday = 0;
            this.state.dailyEvents = [];
            this.generateDailyEvents();
        }
    }
    
    // Generate daily events
    generateDailyEvents() {
        this.state.dailyEvents = [];
        for (let i = 0; i < GAME_CONFIG.DAILY_EVENTS; i++) {
            this.state.dailyEvents.push(getRandomEvent());
        }
    }
    
    // Start new game with selected character
    startNewGame(characterId) {
        const character = getCharacterById(characterId);
        if (!character) {
            console.error('Character not found:', characterId);
            this.showToast('無効なキャラクターです', 'error');
            return false;
        }
        
        console.log('Starting new game with character:', character);
        
        this.state.gameStarted = true;
        this.state.selectedCharacter = characterId;
        this.state.ownedCharacters = [characterId];
        this.state.currentCharacterStats = { ...character.baseStats };
        this.state.playerLevel = calculateLevel(this.state.currentCharacterStats);
        this.state.currency = GAME_CONFIG.INITIAL_CURRENCY;
        this.state.currentScreen = 'main';
        this.state.lastPlayDate = new Date().toDateString();
        this.generateDailyEvents();
        
        this.saveGame();
        this.showToast(`${character.name}でゲームを開始しました！`, 'success');
        return true;
    }
    
    // Update character stats
    updateStats(stats) {
        Object.keys(stats).forEach(stat => {
            if (this.state.currentCharacterStats.hasOwnProperty(stat)) {
                this.state.currentCharacterStats[stat] = Math.max(0, 
                    Math.min(GAME_CONFIG.MAX_STAT_VALUE, 
                        this.state.currentCharacterStats[stat] + stats[stat]
                    )
                );
            }
        });
        
        // Update player level based on total stats
        const newLevel = calculateLevel(this.state.currentCharacterStats);
        if (newLevel > this.state.playerLevel) {
            this.state.playerLevel = newLevel;
            this.showToast(`レベルアップ！レベル ${newLevel} になりました！`, 'success');
        }
        
        this.saveGame();
    }
    
    // Add currency
    addCurrency(amount) {
        this.state.currency = Math.max(0, this.state.currency + amount);
        this.saveGame();
    }
    
    // Spend currency
    spendCurrency(amount) {
        if (this.state.currency >= amount) {
            this.state.currency -= amount;
            this.saveGame();
            return true;
        }
        return false;
    }
    
    // Purchase shop item
    purchaseItem(itemId) {
        const item = getShopItemById(itemId);
        if (!item) {
            this.showToast('アイテムが見つかりません', 'error');
            return false;
        }
        
        if (this.state.currency < item.price) {
            this.showToast('シャチが足りません', 'error');
            return false;
        }
        
        if (this.spendCurrency(item.price)) {
            this.state.purchasedItems.push({
                id: itemId,
                purchaseDate: new Date().toISOString()
            });
            this.updateStats(item.effects);
            this.state.itemsPurchased++;
            this.showToast(`${item.name}を購入しました！`, 'success');
            return true;
        }
        return false;
    }
    
    // Purchase character
    purchaseCharacter(characterId) {
        const character = getCharacterById(characterId);
        if (!character) {
            this.showToast('キャラクターが見つかりません', 'error');
            return false;
        }
        
        if (this.state.ownedCharacters.includes(characterId)) {
            this.showToast('既に所有しているキャラクターです', 'warning');
            return false;
        }
        
        if (this.state.currency < GAME_CONFIG.CHARACTER_PRICE) {
            this.showToast('シャチが足りません', 'error');
            return false;
        }
        
        if (this.spendCurrency(GAME_CONFIG.CHARACTER_PRICE)) {
            this.state.ownedCharacters.push(characterId);
            this.state.charactersUnlocked++;
            this.showToast(`${character.name}を購入しました！`, 'success');
            return true;
        }
        return false;
    }
    
    // Update party formation
    updatePartyFormation(slotIndex, characterId) {
        if (characterId && !this.state.ownedCharacters.includes(characterId)) {
            this.showToast('所有していないキャラクターです', 'error');
            return false;
        }
        
        this.state.partyFormation[slotIndex] = characterId;
        this.saveGame();
        return true;
    }
    
    // Complete event
    completeEvent(eventId, choiceIndex) {
        const event = this.state.dailyEvents.find(e => e.id === eventId);
        if (!event) {
            this.showToast('イベントが見つかりません', 'error');
            return false;
        }
        
        if (this.state.eventsCompletedToday >= GAME_CONFIG.DAILY_EVENTS) {
            this.showToast('今日のイベントは完了しています', 'warning');
            return false;
        }
        
        const choice = event.choices[choiceIndex];
        if (!choice) {
            this.showToast('無効な選択です', 'error');
            return false;
        }
        
        // Apply stat changes
        this.updateStats(choice.effects);
        
        // Add currency reward
        const currencyReward = Math.floor(Math.random() * 50) + 20;
        this.addCurrency(currencyReward);
        
        // Update completion tracking
        this.state.eventsCompletedToday++;
        this.state.eventsCompleted++;
        
        this.saveGame();
        this.showToast(`イベント完了！+${currencyReward}シャチ`, 'success');
        return true;
    }
    
    // Get current character data
    getCurrentCharacter() {
        if (!this.state.selectedCharacter) {
            console.log('No selected character');
            return null;
        }
        const character = getCharacterById(this.state.selectedCharacter);
        if (!character) {
            console.error('Character not found:', this.state.selectedCharacter);
        }
        return character;
    }
    
    // Get owned characters data
    getOwnedCharacters() {
        return this.state.ownedCharacters.map(id => getCharacterById(id)).filter(Boolean);
    }
    
    // Get purchasable characters
    getPurchasableCharacters() {
        return CHARACTERS.filter(char => !this.state.ownedCharacters.includes(char.id));
    }
    
    // Get available events
    getAvailableEvents() {
        return this.state.dailyEvents.slice(0, GAME_CONFIG.DAILY_EVENTS - this.state.eventsCompletedToday);
    }
    
    // Get game statistics
    getGameStats() {
        return {
            playTime: this.state.totalPlayTime,
            eventsCompleted: this.state.eventsCompleted,
            itemsPurchased: this.state.itemsPurchased,
            charactersUnlocked: this.state.charactersUnlocked,
            currentLevel: this.state.playerLevel,
            currency: this.state.currency
        };
    }
    
    // Show toast notification
    showToast(message, type = 'success') {
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;
        toast.textContent = message;
        
        const container = document.getElementById('toast-container');
        if (container) {
            container.appendChild(toast);
            
            setTimeout(() => {
                toast.remove();
            }, 3000);
        }
    }
    
    // Change screen
    changeScreen(screenName) {
        this.state.currentScreen = screenName;
        this.saveGame();
    }
    
    // Get current screen
    getCurrentScreen() {
        return this.state.currentScreen;
    }
    
    // Check if game is started
    isGameStarted() {
        return this.state.gameStarted;
    }
    
    // Get current stats
    getCurrentStats() {
        return { ...this.state.currentCharacterStats };
    }
    
    // Get currency
    getCurrency() {
        return this.state.currency;
    }
    
    // Get player level
    getPlayerLevel() {
        return this.state.playerLevel;
    }
    
    // Get events remaining today
    getEventsRemaining() {
        return GAME_CONFIG.DAILY_EVENTS - this.state.eventsCompletedToday;
    }
}

}
