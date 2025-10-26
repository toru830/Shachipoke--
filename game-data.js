// Character Data Structure
if (typeof CHARACTERS === 'undefined') {
const CHARACTERS = [
    {
        id: 'ikisui_shachiku',
        name: '生粋の社畜',
        icon: '001.png',
        description: '生粋の社畜',
        baseStats: {
            stress: 90,
            knowledge: 70,
            physical: 80,
            communication: 60
        },
        personality: '生粋の社畜として、ストレス耐性と体力が高い'
    },
    {
        id: 'genkai_toppa_shachiku',
        name: '限界突破社畜',
        icon: '002.png',
        description: '限界突破社畜',
        baseStats: {
            stress: 95,
            knowledge: 75,
            physical: 85,
            communication: 65
        },
        personality: '限界を突破した社畜として、全能力が高い'
    },
    {
        id: 'muhai_shokunin_shachiku',
        name: '無敗の職人社畜',
        icon: '003.png',
        description: '無敗の職人社畜',
        baseStats: {
            stress: 85,
            knowledge: 90,
            physical: 75,
            communication: 70
        },
        personality: '職人としての技術力が高く、知識とストレス耐性に優れる'
    },
    {
        id: 'kokou_seikashugi_shachiku',
        name: '孤高の成果主義社畜',
        icon: '004.png',
        description: '孤高の成果主義社畜',
        baseStats: {
            stress: 80,
            knowledge: 85,
            physical: 70,
            communication: 50
        },
        personality: '成果主義で孤高だが、コミュニケーションは苦手'
    },
    {
        id: 'kokoro_yasashiki_shachiku',
        name: '心優しき社畜',
        icon: '005.png',
        description: '心優しき社畜',
        baseStats: {
            stress: 70,
            knowledge: 60,
            physical: 65,
            communication: 85
        },
        personality: '心優しくコミュニケーション能力が高い'
    },
    {
        id: 'seijitsu_kansatsu_shain',
        name: '誠実な観察社員',
        icon: '006.png',
        description: '誠実な観察社員',
        baseStats: {
            stress: 75,
            knowledge: 80,
            physical: 60,
            communication: 75
        },
        personality: '誠実で観察力があり、知識とコミュニケーションに優れる'
    },
    {
        id: 'kyousou_leader_shain',
        name: '共創リーダー社員',
        icon: '007.png',
        description: '共創リーダー社員',
        baseStats: {
            stress: 80,
            knowledge: 75,
            physical: 70,
            communication: 90
        },
        personality: 'リーダーシップがあり、特にコミュニケーション能力が高い'
    },
    {
        id: 'my_pace_shain',
        name: 'マイペース社員',
        icon: '008.png',
        description: 'マイペース社員',
        baseStats: {
            stress: 60,
            knowledge: 65,
            physical: 70,
            communication: 60
        },
        personality: 'マイペースでバランスの取れた能力を持つ'
    },
    {
        id: 'yurufuwa_shachiku',
        name: 'ゆるふわ社畜',
        icon: '009.png',
        description: 'ゆるふわ社畜',
        baseStats: {
            stress: 50,
            knowledge: 55,
            physical: 50,
            communication: 80
        },
        personality: 'ゆるふわでコミュニケーション能力が高いが、他の能力は控えめ'
    },
    {
        id: 'kakure_hirou_shachiku',
        name: '隠れ疲労社畜',
        icon: '010.png',
        description: '隠れ疲労社畜',
        baseStats: {
            stress: 40,
            knowledge: 70,
            physical: 45,
            communication: 65
        },
        personality: '隠れ疲労でストレス耐性が低いが、知識は高い'
    },
    {
        id: 'ohitoyoshi_shain',
        name: 'お人好し社員',
        icon: '011.png',
        description: 'お人好し社員',
        baseStats: {
            stress: 65,
            knowledge: 60,
            physical: 60,
            communication: 85
        },
        personality: 'お人好しでコミュニケーション能力が高い'
    },
    {
        id: 'genjitsuha_shain',
        name: '現実派社員',
        icon: '012.png',
        description: '現実派社員',
        baseStats: {
            stress: 75,
            knowledge: 80,
            physical: 70,
            communication: 70
        },
        personality: '現実的でバランスの取れた能力を持つ'
    },
    {
        id: 'katei_daiji_shain',
        name: '家庭が大事社員',
        icon: '013.png',
        description: '家庭が大事社員',
        baseStats: {
            stress: 70,
            knowledge: 65,
            physical: 60,
            communication: 75
        },
        personality: '家庭を大切にし、コミュニケーション能力が高い'
    },
    {
        id: 'balancer_shain',
        name: 'バランサー社員',
        icon: '014.png',
        description: 'バランサー社員',
        baseStats: {
            stress: 75,
            knowledge: 75,
            physical: 75,
            communication: 75
        },
        personality: 'すべての能力がバランス良く高い'
    },
    {
        id: 'seika_saitekika_shachiku',
        name: '成果最適化社畜',
        icon: '015.png',
        description: '成果最適化社畜',
        baseStats: {
            stress: 85,
            knowledge: 90,
            physical: 80,
            communication: 70
        },
        personality: '成果最適化に特化し、全能力が高い'
    },
    {
        id: 'jiyujin',
        name: '自由人',
        icon: '016.png',
        description: '自由人',
        baseStats: {
            stress: 60,
            knowledge: 70,
            physical: 80,
            communication: 85
        },
        personality: '自由人として、コミュニケーションと体力に優れる'
    }
];

// Shop Items Data
const SHOP_ITEMS = [
    {
        id: 'stomach_medicine',
        name: '胃薬',
        icon: '💊',
        price: 50,
        effects: {
            stress: 20,
            physical: 10
        },
        description: 'ストレスによる胃の不調を和らげる'
    },
    {
        id: 'trackball_mouse',
        name: 'トラックボールマウス',
        icon: '🖱️',
        price: 100,
        effects: {
            stress: 15,
            physical: 15
        },
        description: '手首への負担を軽減する'
    },
    {
        id: 'energy_drink',
        name: 'エナジードリンク',
        icon: '🥤',
        price: 30,
        effects: {
            physical: 25,
            stress: -10
        },
        description: '一時的に体力を回復するが、ストレスが増加'
    },
    {
        id: 'sleeping_bag',
        name: '寝袋',
        icon: '🛌',
        price: 200,
        effects: {
            stress: 30,
            physical: 20
        },
        description: 'オフィスで仮眠を取るための必需品'
    },
    {
        id: 'coffee',
        name: 'コーヒー',
        icon: '☕',
        price: 20,
        effects: {
            knowledge: 15,
            stress: 5
        },
        description: '集中力を高めるが、少しストレスが増加'
    },
    {
        id: 'vitamin',
        name: 'ビタミン剤',
        icon: '💊',
        price: 40,
        effects: {
            physical: 20,
            stress: 10
        },
        description: '体調管理に欠かせないサプリメント'
    },
    {
        id: 'convenience_bento',
        name: 'コンビニ弁当',
        icon: '🍱',
        price: 60,
        effects: {
            physical: 30,
            stress: 5
        },
        description: '手軽に栄養を補給できる'
    },
    {
        id: 'cup_ramen',
        name: 'カップラーメン',
        icon: '🍜',
        price: 25,
        effects: {
            physical: 15,
            stress: 10
        },
        description: '安くて手軽だが、栄養バランスは悪い'
    }
];

// Event Data
const EVENTS = [
    {
        id: 'boss_talk',
        title: '上司が話しかけてきた！',
        description: '部長があなたの席まで来て、何か話しかけようとしています。',
        choices: [
            {
                text: '素早く立ち上がって挨拶する',
                effects: { stress: 10, communication: 15 },
                feedback: '上司に好印象を与えました！コミュニケーション能力が向上しました。'
            },
            {
                text: '作業を続けながら軽く返事する',
                effects: { stress: 5, knowledge: 5 },
                feedback: '効率的な対応でした。知識が少し向上しました。'
            },
            {
                text: '慌てて資料を隠す',
                effects: { stress: 20, communication: -10 },
                feedback: '焦ってしまいました。ストレスが増加し、コミュニケーション能力が下がりました。'
            }
        ]
    },
    {
        id: 'senior_complaint',
        title: 'お局様からの嫌味',
        description: '先輩社員の田中さんが、あなたの仕事ぶりについて嫌味を言ってきました。',
        choices: [
            {
                text: '素直に謝って改善を約束する',
                effects: { stress: 15, communication: 20 },
                feedback: '謙虚な態度が評価されました。コミュニケーション能力が大幅に向上しました。'
            },
            {
                text: '冷静に事実を説明する',
                effects: { stress: 10, knowledge: 10 },
                feedback: '論理的な対応でした。知識とストレス耐性が向上しました。'
            },
            {
                text: '反論して言い返す',
                effects: { stress: 30, communication: -15 },
                feedback: '感情的になってしまいました。ストレスが大幅に増加し、関係が悪化しました。'
            }
        ]
    },
    {
        id: 'difficult_customer',
        title: 'カスハラ客からの電話',
        description: '理不尽な要求をする顧客から電話がかかってきました。',
        choices: [
            {
                text: '丁寧に説明して理解を求める',
                effects: { stress: 20, communication: 25 },
                feedback: 'プロフェッショナルな対応でした。コミュニケーション能力が大幅に向上しました。'
            },
            {
                text: '上司に相談して対応を任せる',
                effects: { stress: 5, knowledge: 10 },
                feedback: '適切な判断でした。知識が向上し、ストレスを軽減できました。'
            },
            {
                text: '感情的になって電話を切る',
                effects: { stress: 40, communication: -20 },
                feedback: '最悪の対応でした。ストレスが大幅に増加し、コミュニケーション能力が低下しました。'
            }
        ]
    },
    {
        id: 'overtime_request',
        title: '残業の依頼',
        description: '急な仕事が入り、残業を求められています。',
        choices: [
            {
                text: '喜んで引き受ける',
                effects: { stress: 25, physical: -15, knowledge: 20 },
                feedback: '仕事熱心な姿勢が評価されました。知識は向上しましたが、体力とストレスに影響しました。'
            },
            {
                text: '条件を確認してから判断する',
                effects: { stress: 10, communication: 15, knowledge: 10 },
                feedback: 'バランスの取れた判断でした。全体的に能力が向上しました。'
            },
            {
                text: '断る',
                effects: { stress: 15, communication: -10 },
                feedback: '断りましたが、関係性に影響が出ました。ストレスが増加しました。'
            }
        ]
    },
    {
        id: 'meeting_presentation',
        title: '会議でのプレゼン',
        description: '突然、会議でプレゼンテーションを求められました。',
        choices: [
            {
                text: '自信を持ってプレゼンする',
                effects: { stress: 20, communication: 30, knowledge: 10 },
                feedback: '素晴らしいプレゼンでした！コミュニケーション能力が大幅に向上しました。'
            },
            {
                text: '資料を確認してから対応する',
                effects: { stress: 10, knowledge: 20, communication: 5 },
                feedback: '慎重な対応でした。知識が向上し、適切な判断ができました。'
            },
            {
                text: '緊張してうまく話せない',
                effects: { stress: 30, communication: -20 },
                feedback: '緊張してしまいました。ストレスが増加し、コミュニケーション能力が低下しました。'
            }
        ]
    },
    {
        id: 'team_conflict',
        title: 'チーム内の対立',
        description: 'チームメンバー同士の意見の対立が起きています。',
        choices: [
            {
                text: '仲裁に入って解決を図る',
                effects: { stress: 15, communication: 25, knowledge: 10 },
                feedback: '優秀な仲裁でした！コミュニケーション能力が大幅に向上しました。'
            },
            {
                text: '上司に報告して判断を仰ぐ',
                effects: { stress: 5, knowledge: 15, communication: 10 },
                feedback: '適切な判断でした。知識とコミュニケーション能力が向上しました。'
            },
            {
                text: '関わらないようにする',
                effects: { stress: 10, communication: -10 },
                feedback: '問題を避けましたが、チームワークに影響が出ました。'
            }
        ]
    }
];

// Video Gallery Data
const VIDEOS = [
    {
        id: 'intro01',
        name: 'イントロ動画',
        filename: 'intro01.mp4',
        description: 'ゲームの紹介動画',
        icon: '🎬'
    }
];

// Game Configuration
const GAME_CONFIG = {
    INITIAL_CURRENCY: 200,
    CHARACTER_PRICE: 500,
    MAX_STAT_VALUE: 100,
    DAILY_EVENTS: 3,
    SAVE_KEY: 'shachipoke2_save',
    VERSION: '1.0.0'
};

// Utility Functions
function getRandomEvent() {
    return EVENTS[Math.floor(Math.random() * EVENTS.length)];
}

function getCharacterById(id) {
    return CHARACTERS.find(char => char.id === id);
}

function getShopItemById(id) {
    return SHOP_ITEMS.find(item => item.id === id);
}

function calculateLevel(stats) {
    const totalStats = Object.values(stats).reduce((sum, stat) => sum + stat, 0);
    return Math.floor(totalStats / 40) + 1;
}

function getStatColor(stat, maxStat = 100) {
    const percentage = (stat / maxStat) * 100;
    if (percentage >= 80) return '#28a745';
    if (percentage >= 60) return '#ffc107';
    if (percentage >= 40) return '#fd7e14';
    return '#dc3545';
}

}
