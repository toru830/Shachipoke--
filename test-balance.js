// Game Balance Testing
console.log('=== シャチポケ２ Game Balance Test ===\n');

// Test character stat distributions
console.log('1. Character Stat Analysis:');
CHARACTERS.forEach(char => {
    const totalStats = Object.values(char.baseStats).reduce((sum, stat) => sum + stat, 0);
    const avgStat = totalStats / 4;
    console.log(`${char.name}: Total=${totalStats}, Avg=${avgStat.toFixed(1)}, Stats=${JSON.stringify(char.baseStats)}`);
});

// Test shop item value analysis
console.log('\n2. Shop Item Value Analysis:');
SHOP_ITEMS.forEach(item => {
    const totalEffect = Object.values(item.effects).reduce((sum, effect) => sum + Math.abs(effect), 0);
    const valuePerShachi = totalEffect / item.price;
    console.log(`${item.name}: Price=${item.price}, TotalEffect=${totalEffect}, Value/Shachi=${valuePerShachi.toFixed(3)}`);
});

// Test event reward analysis
console.log('\n3. Event Choice Analysis:');
EVENTS.forEach(event => {
    console.log(`\n${event.title}:`);
    event.choices.forEach((choice, index) => {
        const totalEffect = Object.values(choice.effects).reduce((sum, effect) => sum + Math.abs(effect), 0);
        const positiveEffects = Object.values(choice.effects).filter(effect => effect > 0).length;
        const negativeEffects = Object.values(choice.effects).filter(effect => effect < 0).length;
        console.log(`  Choice ${index + 1}: TotalEffect=${totalEffect}, +Effects=${positiveEffects}, -Effects=${negativeEffects}`);
    });
});

// Test progression simulation
console.log('\n4. Progression Simulation:');
function simulateProgression() {
    let currency = GAME_CONFIG.INITIAL_CURRENCY;
    let stats = { stress: 0, knowledge: 0, physical: 0, communication: 0 };
    let level = 1;
    let days = 0;
    
    console.log('Simulating 7 days of gameplay:');
    
    for (let day = 1; day <= 7; day++) {
        // Daily events (3 per day)
        for (let event = 0; event < 3; event++) {
            const randomEvent = EVENTS[Math.floor(Math.random() * EVENTS.length)];
            const randomChoice = randomEvent.choices[Math.floor(Math.random() * randomEvent.choices.length)];
            
            // Apply stat changes
            Object.keys(randomChoice.effects).forEach(stat => {
                stats[stat] = Math.max(0, Math.min(100, stats[stat] + randomChoice.effects[stat]));
            });
            
            // Add currency reward
            currency += Math.floor(Math.random() * 50) + 20;
        }
        
        // Calculate new level
        const newLevel = calculateLevel(stats);
        if (newLevel > level) {
            level = newLevel;
        }
        
        // Try to buy items
        const affordableItems = SHOP_ITEMS.filter(item => item.price <= currency);
        if (affordableItems.length > 0) {
            const randomItem = affordableItems[Math.floor(Math.random() * affordableItems.length)];
            currency -= randomItem.price;
            Object.keys(randomItem.effects).forEach(stat => {
                stats[stat] = Math.max(0, Math.min(100, stats[stat] + randomItem.effects[stat]));
            });
        }
        
        console.log(`Day ${day}: Currency=${currency}, Level=${level}, Stats=${JSON.stringify(stats)}`);
    }
}

simulateProgression();

// Test character purchase feasibility
console.log('\n5. Character Purchase Feasibility:');
const dailyIncome = 3 * 45; // Average 45 shachi per event
const daysToBuyCharacter = Math.ceil(GAME_CONFIG.CHARACTER_PRICE / dailyIncome);
console.log(`Average daily income: ${dailyIncome}シャチ`);
console.log(`Days to buy first character: ${daysToBuyCharacter}`);
console.log(`Days to buy all 15 additional characters: ${daysToBuyCharacter * 15}`);

// Test stat cap effectiveness
console.log('\n6. Stat Cap Analysis:');
const maxPossibleStats = GAME_CONFIG.MAX_STAT_VALUE * 4;
const maxPossibleLevel = calculateLevel({
    stress: GAME_CONFIG.MAX_STAT_VALUE,
    knowledge: GAME_CONFIG.MAX_STAT_VALUE,
    physical: GAME_CONFIG.MAX_STAT_VALUE,
    communication: GAME_CONFIG.MAX_STAT_VALUE
});
console.log(`Maximum possible stats: ${maxPossibleStats}`);
console.log(`Maximum possible level: ${maxPossibleLevel}`);

console.log('\n=== Balance Test Complete ===');
