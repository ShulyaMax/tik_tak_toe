import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tik_tak_toe/domain/entity/game_state.dart';
import 'package:tik_tak_toe/domain/entity/item_state.dart';
import 'package:tik_tak_toe/presentation/widgets/grid_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<GameState> isGameOver = ValueNotifier(GameState.progress);
  int step = 1;
  final List<ValueNotifier<ItemState>> _items = List.generate(
    9,
    (index) => ValueNotifier(ItemState.empty),
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final minSide = min(size.width, size.height);
    final fieldSize = min(minSide * 0.9, 420).toDouble();
    final fontSize = fieldSize / 10;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  spacing: 30,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: isGameOver,
                      builder: (context, value, _) {
                        return AnimatedOpacity(
                          opacity: value == GameState.progress ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            value == GameState.draw
                                ? 'draw!!!'
                                : '${step % 2 == 0 ? 'X' : 'O'} you WIN!!!',
                            key: ValueKey(value),
                            style: TextStyle(
                              height: 0.8,
                              fontSize: fontSize,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: fieldSize,
                      height: fieldSize,
                      child: GridView.builder(
                        itemCount: 9,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1.0,
                            ),
                        itemBuilder: (context, index) {
                          return GridItem(
                            state: _items[index],
                            onTap: () {
                              if (isGameOver.value != GameState.progress) {
                                return;
                              }
                              _onItemTap(index);
                            },
                          );
                        },
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: isGameOver,
                      builder: (context, value, _) {
                        return AnimatedOpacity(
                          opacity: value == GameState.progress ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: ElevatedButton(
                            key: const ValueKey('restart'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: _resetGame,
                            child: Text(
                              'Restart Game',
                              style: TextStyle(
                                fontSize: fontSize,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTap(int index) {
    if (_items[index].value == ItemState.empty) {
      _items[index].value = step % 2 == 0 ? ItemState.o : ItemState.x;
      step++;
      if (step > 4) {
        _checkWinner();
      }
      if (step > 9 && isGameOver.value == GameState.progress) {
        isGameOver.value = GameState.draw;
      }
    }
  }

  void _checkWinner() {
    for (int i = 0; i < 3; i++) {
      if (_items[i * 3].value != ItemState.empty &&
          _items[i * 3].value == _items[i * 3 + 1].value &&
          _items[i * 3].value == _items[i * 3 + 2].value) {
        isGameOver.value = GameState.win;
        return;
      }
    }
    for (int i = 0; i < 3; i++) {
      if (_items[i].value != ItemState.empty &&
          _items[i].value == _items[i + 3].value &&
          _items[i].value == _items[i + 6].value) {
        isGameOver.value = GameState.win;
        return;
      }
    }
    if (_items[0].value != ItemState.empty &&
        _items[0].value == _items[4].value &&
        _items[0].value == _items[8].value) {
      isGameOver.value = GameState.win;
      return;
    }
    if (_items[2].value != ItemState.empty &&
        _items[2].value == _items[4].value &&
        _items[2].value == _items[6].value) {
      isGameOver.value = GameState.win;
      return;
    }
  }

  void _resetGame() {
    isGameOver.value = GameState.progress;
    step = 1;
    for (var element in _items) {
      element.value = ItemState.empty;
    }
  }
}
