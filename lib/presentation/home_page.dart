import 'package:flutter/material.dart';
import 'package:tik_tak_toe/domain/entity/item_state.dart';
import 'package:tik_tak_toe/presentation/widgets/grid_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<bool> isGameOver = ValueNotifier(false);
  int step = 1;
  final ValueNotifier<List<ItemState>> _items = ValueNotifier(
    List.generate(9, (index) => ItemState.empty),
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
                    isGameOver: isGameOver,
                    state: _items,
                    index: index,
                    onTap: () {
                      if (isGameOver.value) return;
                      _onItemTap(index);
                    },
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: isGameOver,
                builder:
                    (context, value, _) =>
                        value
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
                                      step > 9
                                          ? 'It\'s a draw!'
                                          : '${step % 2 == 0 ? 'O' : 'X'} Wins!',
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
    final value = _items.value.toList();
    if (value[index] == ItemState.empty) {
      value[index] = step % 2 == 0 ? ItemState.x : ItemState.o;
      step++;
      if (step > 4) {
        _checkWinner(value);
      }
      if (step > 9) {
        isGameOver.value = true;
      }
      _items.value = value;
    }
  }

  void _checkWinner(List<ItemState> items) {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (items[i * 3] != ItemState.empty &&
          items[i * 3] == items[i * 3 + 1] &&
          items[i * 3] == items[i * 3 + 2]) {
        isGameOver.value = true;

        return;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (items[i] != ItemState.empty &&
          items[i] == items[i + 3] &&
          items[i] == items[i + 6]) {
        isGameOver.value = true;

        return;
      }
    }

    // Check diagonals
    if (items[0] != ItemState.empty &&
        items[0] == items[4] &&
        items[0] == items[8]) {
      for (var element in items) {
        if (items.indexOf(element) == 0 ||
            items.indexOf(element) == 4 ||
            items.indexOf(element) == 8) {
          continue;
        }
        element = ItemState.empty;
      }
      isGameOver.value = true;

      return;
    }
    if (items[2] != ItemState.empty &&
        items[2] == items[4] &&
        items[2] == items[6]) {
      isGameOver.value = true;

      return;
    }
  }

  void _resetGame() {
    isGameOver.value = false;
    step = 1;
    _items.value = List.generate(9, (index) => ItemState.empty);
  }
}
