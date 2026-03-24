import 'package:flutter/foundation.dart';
import '../models/card_model.dart';

/// 记牌器状态管理
class CounterProvider extends ChangeNotifier {
  CounterState _state = CounterState();
  
  CounterState get state => _state;
  
  /// 出牌
  void playCard(String cardType, {int count = 1}) {
    if (!_state.remaining.containsKey(cardType)) return;
    
    final currentRemaining = _state.remaining[cardType]!;
    final newRemaining = (currentRemaining - count).clamp(0, CardConfig.cards[cardType]!.total);
    
    final newRemainingMap = Map<String, int>.from(_state.remaining);
    newRemainingMap[cardType] = newRemaining;
    
    final newPlayedMap = Map<String, int>.from(_state.played);
    newPlayedMap[cardType] = (newPlayedMap[cardType] ?? 0) + count;
    
    final record = CardRecord(
      cardType: cardType,
      count: count,
      remaining: newRemaining,
    );
    
    _state = _state.copyWith(
      remaining: newRemainingMap,
      played: newPlayedMap,
      history: [..._state.history, record],
    );
    
    notifyListeners();
  }
  
  /// 撤销上一步
  void undoLast() {
    if (_state.history.isEmpty) return;
    
    final lastRecord = _state.history.last;
    final cardType = lastRecord.cardType;
    
    final newRemainingMap = Map<String, int>.from(_state.remaining);
    newRemainingMap[cardType] = lastRecord.remaining + lastRecord.count;
    
    final newPlayedMap = Map<String, int>.from(_state.played);
    newPlayedMap[cardType] = (newPlayedMap[cardType] ?? 0) - lastRecord.count;
    
    _state = _state.copyWith(
      remaining: newRemainingMap,
      played: newPlayedMap,
      history: _state.history.sublist(0, _state.history.length - 1),
    );
    
    notifyListeners();
  }
  
  /// 撤销指定牌
  void undoCard(String cardType) {
    if ((_state.played[cardType] ?? 0) <= 0) return;
    
    final newRemainingMap = Map<String, int>.from(_state.remaining);
    newRemainingMap[cardType] = (newRemainingMap[cardType] ?? 0) + 1;
    
    final newPlayedMap = Map<String, int>.from(_state.played);
    newPlayedMap[cardType] = (newPlayedMap[cardType] ?? 0) - 1;
    
    _state = _state.copyWith(
      remaining: newRemainingMap,
      played: newPlayedMap,
    );
    
    notifyListeners();
  }
  
  /// 重置
  void reset() {
    _state = CounterState();
    notifyListeners();
  }
  
  /// 批量出牌（自动识别用）
  void playCards(List<String> cardTypes) {
    for (final cardType in cardTypes) {
      playCard(cardType);
    }
  }
  
  /// 获取剩余数量
  int getRemaining(String cardType) => _state.remaining[cardType] ?? 0;
  
  /// 获取已出数量
  int getPlayed(String cardType) => _state.played[cardType] ?? 0;
  
  /// 获取建议
  List<String> get suggestions => _state.getSuggestions();
  
  /// 获取危险牌
  List<MapEntry<String, int>> get dangerCards => _state.getDangerCards();
}
