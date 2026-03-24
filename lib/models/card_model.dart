/// 够级牌型模型
class CardType {
  final String name;
  final int total;
  final int priority;
  final bool isEagle;
  final bool isSpecial;
  
  const CardType({
    required this.name,
    required this.total,
    required this.priority,
    this.isEagle = false,
    this.isSpecial = false,
  });
}

/// 够级牌配置（6副牌带鹰）
class CardConfig {
  static const Map<String, CardType> cards = {
    // 鹰牌
    '大王': CardType(name: '大王', total: 6, priority: 15, isEagle: true),
    '小王': CardType(name: '小王', total: 6, priority: 14, isEagle: true),
    '2': CardType(name: '2', total: 24, priority: 13, isSpecial: true),
    
    // 普通牌
    'A': CardType(name: 'A', total: 24, priority: 12),
    'K': CardType(name: 'K', total: 24, priority: 11),
    'Q': CardType(name: 'Q', total: 24, priority: 10),
    'J': CardType(name: 'J', total: 24, priority: 9),
    '10': CardType(name: '10', total: 24, priority: 8),
    '9': CardType(name: '9', total: 24, priority: 7),
    '8': CardType(name: '8', total: 24, priority: 6),
    '7': CardType(name: '7', total: 24, priority: 5),
    '6': CardType(name: '6', total: 24, priority: 4),
    '5': CardType(name: '5', total: 24, priority: 3),
    '4': CardType(name: '4', total: 24, priority: 2),
    '3': CardType(name: '3', total: 24, priority: 1),
  };
  
  static const List<String> eagleCards = ['大王', '小王', '2'];
  static const List<String> normalCards = ['A', 'K', 'Q', 'J', '10', '9', '8', '7', '6', '5', '4', '3'];
  
  /// 获取牌型信息
  static CardType? getCardInfo(String name) => cards[name];
  
  /// 是否是够级牌
  static bool isGoujiCard(String name) {
    return ['2', '小王', '大王'].contains(name);
  }
}

/// 记牌记录
class CardRecord {
  final String cardType;
  final int count;
  final DateTime timestamp;
  final int remaining;
  
  CardRecord({
    required this.cardType,
    required this.count,
    required this.remaining,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
  
  Map<String, dynamic> toJson() => {
    'cardType': cardType,
    'count': count,
    'timestamp': timestamp.toIso8601String(),
    'remaining': remaining,
  };
  
  factory CardRecord.fromJson(Map<String, dynamic> json) => CardRecord(
    cardType: json['cardType'],
    count: json['count'],
    remaining: json['remaining'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

/// 记牌器状态
class CounterState {
  final Map<String, int> remaining;
  final Map<String, int> played;
  final List<CardRecord> history;
  final DateTime? gameStartTime;
  
  CounterState({
    Map<String, int>? remaining,
    Map<String, int>? played,
    List<CardRecord>? history,
    this.gameStartTime,
  })  : remaining = remaining ?? _initRemaining(),
        played = played ?? _initPlayed(),
        history = history ?? [];
  
  static Map<String, int> _initRemaining() {
    return Map.fromEntries(
      CardConfig.cards.entries.map((e) => MapEntry(e.key, e.value.total))
    );
  }
  
  static Map<String, int> _initPlayed() {
    return Map.fromEntries(
      CardConfig.cards.keys.map((k) => MapEntry(k, 0))
    );
  }
  
  CounterState copyWith({
    Map<String, int>? remaining,
    Map<String, int>? played,
    List<CardRecord>? history,
    DateTime? gameStartTime,
  }) {
    return CounterState(
      remaining: remaining ?? this.remaining,
      played: played ?? this.played,
      history: history ?? this.history,
      gameStartTime: gameStartTime ?? this.gameStartTime,
    );
  }
  
  /// 获取剩余概率
  double getProbability(String cardType) {
    final total = CardConfig.cards[cardType]?.total ?? 0;
    if (total == 0) return 0;
    return remaining[cardType]! / total;
  }
  
  /// 获取危险牌列表
  List<MapEntry<String, int>> getDangerCards() {
    return remaining.entries
        .where((e) => CardConfig.eagleCards.contains(e.key) && e.value <= 2)
        .toList();
  }
  
  /// 获取建议
  List<String> getSuggestions() {
    final suggestions = <String>[];
    
    // 检查鹰牌
    final bigJoker = remaining['大王'] ?? 0;
    final smallJoker = remaining['小王'] ?? 0;
    final twos = remaining['2'] ?? 0;
    
    if (bigJoker <= 1) {
      suggestions.add('大王仅剩$bigJoker张，谨慎使用！');
    }
    if (smallJoker <= 1) {
      suggestions.add('小王仅剩$smallJoker张，谨慎使用！');
    }
    if (twos <= 3) {
      suggestions.add('2（钱）仅剩$twos张！');
    }
    
    return suggestions;
  }
}
