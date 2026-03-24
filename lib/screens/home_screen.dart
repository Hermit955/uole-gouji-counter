import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/counter_provider.dart';
import '../models/card_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF34495E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        title: const Text(
          '多乐够级记牌器',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              context.read<CounterProvider>().reset();
            },
          ),
          IconButton(
            icon: const Icon(Icons.undo, color: Colors.white),
            onPressed: () {
              context.read<CounterProvider>().undoLast();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 模式切换
          _buildModeSelector(),
          
          // 鹰牌区域
          _buildEagleCards(context),
          
          // 建议区域
          _buildSuggestionPanel(context),
          
          // 普通牌区域
          Expanded(
            child: _buildNormalCards(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFloatingWindow(context),
        backgroundColor: const Color(0xFF27AE60),
        icon: const Icon(Icons.picture_in_picture),
        label: const Text('启动悬浮窗'),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'manual', label: Text('手动记牌')),
          ButtonSegment(value: 'auto', label: Text('自动识别')),
        ],
        selected: const {'manual'},
        onSelectionChanged: (set) {},
      ),
    );
  }

  Widget _buildEagleCards(BuildContext context) {
    return Consumer<CounterProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C3E50),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF39C12), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '鹰牌监控',
                style: TextStyle(
                  color: Color(0xFFF39C12),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: CardConfig.eagleCards.map((card) {
                  final remaining = provider.getRemaining(card);
                  return _buildEagleCard(card, remaining);
                }).toList(),
              ),
            ],
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$remaining',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionPanel(BuildContext context) {
    return Consumer<CounterProvider>(
      builder: (context, provider, child) {
        final suggestions = provider.suggestions;
        if (suggestions.isEmpty) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF3498DB).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF3498DB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '智能建议',
                style: TextStyle(
                  color: Color(0xFF3498DB),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...suggestions.map((s) => Text(
                '• $s',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNormalCards(BuildContext context) {
    return Consumer<CounterProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: CardConfig.normalCards.length,
          itemBuilder: (context, index) {
            final card = CardConfig.normalCards[index];
            final remaining = provider.getRemaining(card);
            final total = CardConfig.cards[card]!.total;
            final ratio = remaining / total;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2C3E50),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text(
                      card,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: ratio,
                      backgroundColor: Colors.grey[800],
                      valueColor: AlwaysStoppedAnimation(
                        ratio <= 0.25
                            ? const Color(0xFFC0392B)
                            : ratio <= 0.5
                                ? const Color(0xFFF39C12)
                                : const Color(0xFF27AE60),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: ratio <= 0.25
                          ? const Color(0xFFC0392B)
                          : ratio <= 0.5
                              ? const Color(0xFFF39C12)
                              : const Color(0xFF27AE60),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$remaining',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.white70),
                    onPressed: () => provider.playCard(card),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Color(0xFF27AE60)),
                    onPressed: () => provider.undoCard(card),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showFloatingWindow(BuildContext context) {
    // 显示提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('悬浮窗功能需要在系统设置中开启权限'),
        action: SnackBarAction(
          label: '知道了',
          onPressed: null,
        ),
      ),
    );
  }
}
