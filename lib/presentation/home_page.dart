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
    return Scaffold(
      body: Center(
        child: SizedBox.square(
          dimension: 420,
          child: Stack(
            children: [
              GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  return GridItem(
                    state: _items[index],
                    onTap: () {
                      if (isGameOver.value != GameState.progress) return;
                      _onItemTap(index);
                    },
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: isGameOver,
                builder:
                    (context, value, _) =>
                        value != GameState.progress
                            ? Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      isGameOver.value == GameState.draw
                                          ? 'It\'s a draw!'
                                          : '${step % 2 == 0 ? 'X' : 'O'} Wins!',
                                      style: const TextStyle(
                                        fontSize: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 50,
                                          vertical: 20,
                                        ),
                                      ),
                                      onPressed: _resetGame,
                                      child: Text(
                                        'Restart',
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            : const SizedBox(),
              ),
            ],
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
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (_items[i * 3].value != ItemState.empty &&
          _items[i * 3].value == _items[i * 3 + 1].value &&
          _items[i * 3].value == _items[i * 3 + 2].value) {
        for (var element in _items) {
          if (_items.indexOf(element) == i * 3 ||
              _items.indexOf(element) == i * 3 + 1 ||
              _items.indexOf(element) == i * 3 + 2) {
            continue;
          }
          element.value = ItemState.empty;
        }
        isGameOver.value = GameState.win;

        return;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (_items[i].value != ItemState.empty &&
          _items[i].value == _items[i + 3].value &&
          _items[i].value == _items[i + 6].value) {
        for (var element in _items) {
          if (_items.indexOf(element) == i ||
              _items.indexOf(element) == i + 3 ||
              _items.indexOf(element) == i + 6) {
            continue;
          }
          element.value = ItemState.empty;
        }
        isGameOver.value = GameState.win;

        return;
      }
    }

    // Check diagonals
    if (_items[0].value != ItemState.empty &&
        _items[0].value == _items[4].value &&
        _items[0].value == _items[8].value) {
      for (var element in _items) {
        if (_items.indexOf(element) == 0 ||
            _items.indexOf(element) == 4 ||
            _items.indexOf(element) == 8) {
          continue;
        }
        element.value = ItemState.empty;
      }
      isGameOver.value = GameState.win;

      return;
    }
    if (_items[2].value != ItemState.empty &&
        _items[2].value == _items[4].value &&
        _items[2].value == _items[6].value) {
      for (var element in _items) {
        if (_items.indexOf(element) == 2 ||
            _items.indexOf(element) == 4 ||
            _items.indexOf(element) == 6) {
          continue;
        }
        element.value = ItemState.empty;
      }
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
