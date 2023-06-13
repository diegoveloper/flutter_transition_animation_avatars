import 'package:flutter/material.dart';

class MyHomeFlow extends StatefulWidget {
  const MyHomeFlow({super.key});

  @override
  State<MyHomeFlow> createState() => _MyHomeFlowState();
}

class _MyHomeFlowState extends State<MyHomeFlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final maxNumberOfItems = 4;
  final numberOfItems = 5;
  final itemRadius = 30.0;
  double get itemSize => itemRadius * 2;

  bool expanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildItem(int index) {
    return GestureDetector(
      onTap: () {
        print('tapped $index');
      },
      child: Container(
        height: itemSize,
        width: itemSize,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        child: ClipOval(
          child: Image.network(
            'https://i.pravatar.cc/300?img=$index',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = itemSize / 2 * numberOfItems;
    final height = itemSize * numberOfItems;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flow widget'),
      ),
      body: Center(
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Flow(
              delegate: _MyFlowDelegate(
                animation: _controller,
                maxNumberOfItems: maxNumberOfItems,
              ),
              children: List.generate(
                numberOfItems,
                (index) {
                  return _buildItem(index);
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller.isCompleted) {
            _controller.reverse();
          } else {
            _controller.forward();
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _MyFlowDelegate extends FlowDelegate {
  _MyFlowDelegate({
    required this.animation,
    required this.maxNumberOfItems,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final int maxNumberOfItems;

  @override
  void paintChildren(FlowPaintingContext context) {
    final numberOfItems = context.childCount;
    for (var i = 0; i < numberOfItems; i++) {
      final childSize = context.getChildSize(i)!;
      final isLast = i >= maxNumberOfItems;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          (i * childSize.width / 2) * (1 - animation.value),
          i * childSize.height * animation.value,
          0,
        ),
        opacity: isLast ? animation.value : 1,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MyFlowDelegate oldDelegate) =>
      animation != oldDelegate.animation ||
      maxNumberOfItems != oldDelegate.maxNumberOfItems;
}
