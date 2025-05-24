import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tik_tak_toe/domain/entity/item_state.dart';

class GridItem extends StatefulWidget {
  final ValueNotifier<ItemState> state;
  final VoidCallback onTap;

  const GridItem({required this.state, required this.onTap, super.key});

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  ItemState _cacheState = ItemState.empty;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
      reverseCurve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: widget.state,
            builder: (context, value, _) {
              if (value != ItemState.empty) {
                _cacheState = value;
                _controller.forward();
              } else {
                _controller.reverse().then((_) {
                  _cacheState = ItemState.empty;
                });
              }
              return AnimatedBuilder(
                animation: _animation,
                builder: (context, _) {
                  return SvgPicture.asset(
                    value == ItemState.empty
                        ? _cacheState == ItemState.x
                            ? 'assets/x.svg'
                            : 'assets/o.svg'
                        : value == ItemState.x
                        ? 'assets/x.svg'
                        : 'assets/o.svg',
                    width: 100 * _animation.value,
                    height: 100 * _animation.value,
                    colorFilter: ColorFilter.mode(
                      getColor(value),
                      BlendMode.srcIn,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Color getColor(ItemState state) {
    switch (state) {
      case ItemState.x:
        return Colors.red;
      case ItemState.o:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
