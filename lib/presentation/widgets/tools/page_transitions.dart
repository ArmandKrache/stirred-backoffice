import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// An enum indicating which direction a page transition should take.
enum TransitionDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
}

/// A page transition using a [SlideTransition].
///
/// `child` is the page to animate.
class SlideTransitionPage<T> extends CustomTransitionPage<T> {
  SlideTransitionPage({
    super.key,
    required this.direction,
    required super.child,
  }) : super(
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            final begin = () {
              switch (direction) {
                case TransitionDirection.leftToRight:
                  return const Offset(-1.0, 0.0);
                case TransitionDirection.rightToLeft:
                  return const Offset(1.0, 0.0);
                case TransitionDirection.topToBottom:
                  return const Offset(0.0, -1.0);
                case TransitionDirection.bottomToTop:
                  return const Offset(0.0, 1.0);
              }
            }();

            return SlideTransition(
              position: Tween<Offset>(
                begin: begin,
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );

  /// Indicates which direction the transition should take.
  final TransitionDirection direction;
}

/// A page transition using a [FadeTransition].
///
/// `child` is the page to animate.
class FadeTransitionPage<T> extends CustomTransitionPage<T> {
  FadeTransitionPage({
    super.key,
    required super.child,
  }) : super(
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
