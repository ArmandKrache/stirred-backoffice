import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';
import 'dart:math' as math;
import 'package:stirred_backoffice/presentation/widgets/tools/wave_painter.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key, this.child = const SizedBox()});

  final Widget child;

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _heightController;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2700),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller);

    // Height animation controller
    _heightController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _heightAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _heightController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the height animation
    _heightController.forward();

    _heightController.addListener(() {
      if (_heightAnimation.value < 1) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _heightController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final colors = ref.colors;
    final screenHeight = MediaQuery.of(context).size.height;
    final baseBackWaveHeight = screenHeight * 0.1;
    final baseFrontWaveHeight = screenHeight * 0.08;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Back wave
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: _heightAnimation.isAnimating ? Curves.linear : Curves.easeInOut,
            bottom: 0,
            left: 0,
            right: 0,
            height: baseBackWaveHeight * 2 * _heightAnimation.value,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(
                    animation: _animation.value,
                    color: colors.tertiary,
                    isBackWave: true,
                  ),
                );
              },
            ),
          ),
          // Front wave
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: _heightAnimation.isAnimating ? Curves.linear : Curves.easeInOut,
            bottom: 0,
            left: 0,
            right: 0,
            height: baseFrontWaveHeight * 2 * _heightAnimation.value,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(
                    animation: _animation.value + math.pi / 3.5,
                    color: colors.primaryVariant,
                    isBackWave: false,
                  ),
                );
              },
            ),
          ),
          if (!_heightAnimation.isAnimating) widget.child,
        ],
      ),
    );
  }
}
