import 'package:flutter/material.dart';
import 'dart:math';

class RawPIPView extends StatefulWidget {
  const RawPIPView({
    Key? key,
    required this.initialCorner,
    this.floatingWidth = 200,
    this.floatingHeight = 200,
    this.avoidKeyboard = true,
    required this.topWidget,
    required this.bottomWidget,
    this.onTapTopWidget,
  }) : super(key: key);

  final Alignment initialCorner;
  final double floatingWidth;
  final double floatingHeight;
  final bool avoidKeyboard;
  final Widget topWidget;
  final Widget bottomWidget;
  final VoidCallback? onTapTopWidget;

  @override
  State<RawPIPView> createState() => _RawPIPViewState();
}

class _RawPIPViewState extends State<RawPIPView> with TickerProviderStateMixin {
  late bool _isFloating;
  late Alignment _corner;
  late Offset _dragOffset;

  late AnimationController _toggleFloatingAnimationController;
  late AnimationController _dragAnimationController;
  late AnimationController _rotationController;
  Animation<Alignment>? _dragAnimation;

  @override
  void initState() {
    super.initState();
    _isFloating = true;
    _corner = widget.initialCorner;
    _dragOffset = Offset.zero;

    _toggleFloatingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _dragAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(); // التدوير المستمر
  }

  @override
  void dispose() {
    _toggleFloatingAnimationController.dispose();
    _dragAnimationController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (!_isFloating) return;

    _dragAnimationController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isFloating) return;

    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_isFloating) return;

    _dragAnimation = AlignmentTween(
      begin: _corner,
      end: _calculateNearestCorner(_corner + _offsetToAlignment(_dragOffset)),
    ).animate(CurvedAnimation(
      parent: _dragAnimationController,
      curve: Curves.easeOut,
    ));

    _dragAnimationController
      ..value = 0
      ..forward();

    _dragAnimationController.addListener(() {
      setState(() {
        _corner = _dragAnimation!.value;
      });
    });

    _dragAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _dragAnimationController.removeListener(() {});
      }
    });

    _dragOffset = Offset.zero;
  }

  Alignment _calculateNearestCorner(Alignment alignment) {
    final corners = [
      const Alignment(-1, -1),
      const Alignment(1, -1),
      const Alignment(-1, 1),
      const Alignment(1, 1),
    ];

    Alignment nearestCorner = corners.first;
    double shortestDistance = double.infinity;

    for (final corner in corners) {
      final distance = (alignment.x - corner.x).abs() + (alignment.y - corner.y).abs();
      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestCorner = corner;
      }
    }

    return nearestCorner;
  }

  Offset _alignmentToOffset(Alignment alignment) {
    return Offset(alignment.x * MediaQuery.of(context).size.width / 2,
        alignment.y * MediaQuery.of(context).size.height / 2);
  }

  Alignment _offsetToAlignment(Offset offset) {
    return Alignment(
      offset.dx / (MediaQuery.of(context).size.width / 2),
      offset.dy / (MediaQuery.of(context).size.height / 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final insets = MediaQuery.of(context).viewInsets;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            widget.bottomWidget,
            if (_isFloating)
              AnimatedBuilder(
                animation: _dragAnimationController,
                builder: (context, child) {
                  return Align(
                    alignment: _corner,
                    child: GestureDetector(
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: _onPanEnd,
                      onTap: widget.onTapTopWidget,
                      child: SizedBox(
                        width: widget.floatingWidth,
                        height: widget.floatingHeight,
                        child: Transform.rotate(
                          angle: _rotationController.value * 2 * pi, // تدوير الصورة
                          child: child,
                        ),
                      ),
                    ),
                  );
                },
                child: widget.topWidget,
              ),
          ],
        );
      },
    );
  }
}
