import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/counter_provider.dart';
import '../models/card_model.dart';

/// 悬浮窗界面（精简版）
class OverlayScreen extends StatelessWidget {
  const OverlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: 280,
        height: 400,
        decoration: BoxDecoration(
          color: const Color(0xFF34495E).withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF39C12), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            // 标题栏
            _buildTitleBar(),
            
            // 鹰牌
            _buildEagleCards(),
            
            // 快捷按钮
            _buildQuickActions(),
            
            // 最近出牌
            Expanded(
              child: _buildRecentCards(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF2C3E50),
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Row(
        children: [
          const Text(
            '够级记牌器',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              // 关闭悬浮窗
            },
            child: const Icon(Icons.close, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildEagleCards() {
    return Consumer<CounterProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: CardConfig.eagleCards.map((card) {
              final remaining = provider.getRemaining(card);
              return _buildEagleCard(card, remaining);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildEagleCard(String card, int remaining) {
    Color bgColor;
    if (remaining <= 1) {
      bgColor = const Color(0xFFC0392B);
    } else if (remaining <= 2) {
      bgColor = const Color(0xFFE74C3C);
    } else if (remaining <= 3) {
      bgColor = const Color(0xFFF39C12);
    } else {
      bgColor = const Color(0xFF27AE60);
    }

    return GestureDetector(
      onTap: () => context.read<CounterProvider>().playCard(card),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              card,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$remaining',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickButton('A', const Color(0xFF3498DB)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildQuickButton('K', const Color(0xFF3498DB)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildQuickButton('Q', const Color(0xFF3498DB)),
          ),
          const SizedBox(width: 8),
          _buildActionButton(Icons.undo, const Color(0xFFE67E22)),
        ],
      ),
    );
  }

  Widget _buildQuickButton(String card, Color color) {
    return Consumer<CounterProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => provider.playCard(card),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$card (${provider.getRemaining(card)})',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(IconData icon, Color color) {
    return GestureDetector(
      onTap: () => context.read<CounterProvider>().undoLast(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildRecentCards() {
    return Consumer<CounterProvider>(
      builder: (context, provider, child) {
        final history = provider.state.history.reversed.take(5).toList();
        
        return Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '最近记录',
                style: TextStyle(
                  color: Color(0xFF95A5A6),
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 8),
              ...history.map((record) => Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Text(
                      record.cardType,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '剩${record.remaining}张',
                      style: TextStyle(
                        color: record.remaining <= 3 
                            ? const Color(0xFFE74C3C)
                            : const Color(0xFF27AE60),
                        fontSize: 10,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      record.timestamp.toString().substring(11, 19),
                      style: const TextStyle(
                        color: Color(0xFF7F8C8D),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        );
      },
    );
  }
}
