import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tik_tak_toe/domain/entity/item_state.dart';

class GridItem extends StatefulWidget {
  final ValueNotifier<List<ItemState>> state;
  final ValueNotifier<bool> isGameOver;
  final int index;
  final VoidCallback onTap;

  const GridItem({
    required this.state,
    required this.onTap,
    required this.index,
    required this.isGameOver,
    super.key,
  });

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  ItemState _itemState = ItemState.empty;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    widget.state.addListener(() {
      setState(() {
        _itemState = widget.state.value[widget.index];
        if (_itemState != ItemState.empty) {
          _controller.forward();
        }
      });
    });
    widget.isGameOver.addListener(() {
      setState(() {
        if (_itemState != ItemState.empty) {
          print('Game Over');
          _controller.reverse();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child:
              _itemState == ItemState.empty
                  ? SizedBox()
                  : AnimatedBuilder(
                    animation: _animation,
                    builder:
                        (BuildContext context, Widget? child) =>
                            SvgPicture.asset(
                              _itemState == ItemState.x
                                  ? 'assets/x.svg'
                                  : 'assets/o.svg',
                              width: 120 * _controller.value,
                              height: 120 * _controller.value,

                              colorFilter: ColorFilter.mode(
                                _itemState == ItemState.x
                                    ? Colors.red
                                    : Colors.green,
                                BlendMode.srcIn,
                              ),
                            ),
                  ),
        ),
      ),
    );
  }
}
