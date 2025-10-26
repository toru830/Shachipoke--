# シャチポケ２ (Shachipoke 2)

A mobile-first web-based office worker character raising simulation game.

## 🎮 Game Overview

シャチポケ２ is a character development simulation game where players raise office worker characters through daily events, shopping, and strategic character management. The game features 16 unique characters, each with distinct personalities and stat distributions.

## 🚀 Features

### Core Gameplay
- **16 Unique Characters**: Each with distinct personalities and base stats
- **4 Core Stats System**: 
  - 耐ストレス (Stress Resistance)
  - 知識 (Knowledge)
  - 体力 (Physical Strength)
  - コミュ力 (Communication Skills)
- **Daily Event System**: 3 daily events with multiple choice scenarios
- **Shop System**: 8 purchasable items with stat effects
- **Character Formation**: Party management with up to 4 characters
- **Progression System**: Level-based character development

### Technical Features
- **Mobile-First Design**: Optimized for mobile devices
- **LocalStorage Persistence**: Auto-save and manual save/load
- **Responsive UI**: Adapts to various screen sizes
- **Accessibility Support**: Keyboard navigation and screen reader support
- **Offline Capable**: Works without internet connection
- **PWA Ready**: Can be installed as a mobile app

## 🎯 How to Play

### Getting Started
1. **Character Selection**: Choose your initial character from 16 options
2. **Daily Events**: Complete 3 daily events to earn シャチ (currency) and stat boosts
3. **Shopping**: Use シャチ to purchase items that improve character stats
4. **Character Management**: Buy additional characters and form parties
5. **Progression**: Level up through stat development and event completion

### Game Mechanics
- **Daily Reset**: Events refresh daily at midnight
- **Stat Caps**: Maximum stat value is 100
- **Level Calculation**: Based on total stat points (Level = Total Stats ÷ 40 + 1)
- **Currency System**: Earn シャチ through events, spend on items and characters

## 🎨 Characters

### Available Characters
1. **武志** - 真面目な新入社員 (Balanced starter character)
2. **雪** - クールな先輩社員 (High stress resistance and knowledge)
3. **健二** - IT系エンジニア (High knowledge, low communication)
4. **美香** - マーケティング担当 (High communication skills)
5. **博** - ベテラン技術者 (High stress resistance and knowledge)
6. **明子** - 研究開発部 (Very high knowledge, low physical)
7. **聡** - 営業部エース (High communication and physical)
8. **直美** - 人事部 (Balanced stats)
9. **亮** - デザイナー (Creative but stress-sensitive)
10. **結衣** - 企画部 (Good communication and knowledge)
11. **大樹** - 管理職候補 (Well-rounded leadership stats)
12. **桜** - 経理部 (High knowledge, low physical)
13. **健太** - システム管理者 (High knowledge, low communication)
14. **真理** - データアナリスト (Very high knowledge, low stress resistance)
15. **太郎** - 現場監督 (High physical strength)
16. **花** - 品質管理 (High knowledge, low physical)

## 🛒 Shop Items

### Available Items
- **胃薬** (50シャチ) - Reduces stress, improves physical
- **トラックボールマウス** (100シャチ) - Reduces stress and physical strain
- **エナジードリンク** (30シャチ) - Boosts physical, increases stress
- **寝袋** (200シャチ) - Significant stress and physical improvement
- **コーヒー** (20シャチ) - Boosts knowledge, slight stress increase
- **ビタミン剤** (40シャチ) - Improves physical and stress resistance
- **コンビニ弁当** (60シャチ) - Good physical boost
- **カップラーメン** (25シャチ) - Cheap physical boost, increases stress

## 📱 Technical Requirements

### Browser Support
- Modern browsers with ES6+ support
- LocalStorage support required
- Touch events for mobile devices

### Mobile Optimization
- Responsive design for screens 320px and up
- Touch-friendly interface elements
- Optimized animations for mobile performance
- PWA installation support

## 🎮 Game Balance

### Economy Balance
- **Initial Currency**: 200シャチ
- **Character Price**: 500シャチ each
- **Event Rewards**: 20-70シャチ per event
- **Daily Income**: ~150-210シャチ (3 events)

### Progression Balance
- **Stat Growth**: Items provide 10-30 point boosts
- **Level Requirements**: ~40 stat points per level
- **Event Difficulty**: Balanced around character capabilities
- **Long-term Progression**: Sustainable growth over multiple days

## 🔧 Development

### File Structure
```
├── index.html          # Main HTML structure
├── styles.css          # Complete CSS styling
├── game-data.js        # Character, item, and event data
├── game-state.js       # Game state management and persistence
├── game-ui.js          # UI management and interactions
├── main.js             # Initialization and optimizations
└── README.md           # This documentation
```

### Key Classes
- **GameState**: Manages all game data and persistence
- **GameUI**: Handles all user interface interactions
- **Character System**: 16 characters with unique stats
- **Event System**: Daily events with choice consequences
- **Shop System**: Item purchasing and stat effects

## 🚀 Getting Started

1. Open `index.html` in a modern web browser
2. Select your initial character
3. Complete daily events to earn currency
4. Purchase items and characters to improve your team
5. Enjoy the office worker simulation experience!

## 🎯 Future Enhancements

- Additional character types and specializations
- More complex event chains and storylines
- Multiplayer features and competitions
- Advanced formation strategies
- Achievement system and rewards
- Sound effects and background music

---

**シャチポケ２** - Where office life meets character development! 🐋💼
