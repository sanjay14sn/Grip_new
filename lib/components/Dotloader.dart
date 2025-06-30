import 'package:flutter/material.dart';

class DotLoader extends StatefulWidget {
  final Color color;
  final double size;
  final int dotCount;

  const DotLoader({
    super.key,
    this.color = Colors.black,
    this.size = 10,
    this.dotCount = 4,
  });

  @override
  State<DotLoader> createState() => _DotLoaderState();
}

class _DotLoaderState extends State<DotLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int activeDot = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
        if (_controller.status == AnimationStatus.completed) {
          _controller.repeat();
        }
        setState(() {
          activeDot = (activeDot + 1) % widget.dotCount;
        });
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: activeDot == index
            ? widget.color
            : widget.color.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.dotCount, (index) => buildDot(index)),
    );
  }
}
