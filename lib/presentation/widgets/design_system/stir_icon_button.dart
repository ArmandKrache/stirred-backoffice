import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stirred_backoffice/core/theme/color.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_icon.dart';

enum _StirIconButtonType {
  primary,
  primaryGradient,
  standard,
  outlined,
  outlinedInverted,
  inversedTransparent,
}

const _smallIconButtonSize = 40.0;
const _largeIconButtonSize = 64.0;
const _iconButtonDecorationWidth = 1.0;

enum StirIconButtonSize {
  small(_smallIconButtonSize, _iconButtonDecorationWidth),
  medium(_smallIconButtonSize, _iconButtonDecorationWidth),
  large(_largeIconButtonSize, _iconButtonDecorationWidth);

const StirIconButtonSize(
    this.buttonSize,
    this.decorationWidth,
  );

  final double buttonSize;
  final double decorationWidth;
}

class StirIconButton extends ConsumerStatefulWidget {
  const StirIconButton.primary({
    super.key,
    required this.iconData,
    this.onPressed,
    this.size = StirIconButtonSize.small,
    this.isSlashed = false,
    this.foregroundColor,
  }) : _type = _StirIconButtonType.primary;

  const StirIconButton.primaryGradient({
    super.key,
    required this.iconData,
    this.onPressed,
    this.size = StirIconButtonSize.small,
    this.isSlashed = false,
  })  : _type = _StirIconButtonType.primaryGradient,
        foregroundColor = null;

  const StirIconButton.standard({
    super.key,
    required this.iconData,
    this.onPressed,
    this.size = StirIconButtonSize.small,
    this.isSlashed = false,
  })  : _type = _StirIconButtonType.standard,
        foregroundColor = null;

  const StirIconButton.outlined({
    super.key,
    required this.iconData,
    this.onPressed,
    this.size = StirIconButtonSize.small,
    this.isSlashed = false,
  })  : _type = _StirIconButtonType.outlined,
        foregroundColor = null;

  const StirIconButton.outlinedInverted({
    super.key,
    required this.iconData,
    this.onPressed,
    this.size = StirIconButtonSize.small,
    this.isSlashed = false,
  })  : _type = _StirIconButtonType.outlinedInverted,
        foregroundColor = null;

  const StirIconButton.inversedTransparent({
    super.key,
    required this.iconData,
    this.onPressed,
    this.size = StirIconButtonSize.small,
    this.isSlashed = false,
    required this.foregroundColor,
  }) : _type = _StirIconButtonType.inversedTransparent;

  final IconData iconData;
  final _StirIconButtonType _type;
  final VoidCallback? onPressed;
  final StirIconButtonSize size;
  final bool isSlashed;
  final Color? foregroundColor;

  @override
  ConsumerState<StirIconButton> createState() => _StirIconButtonState();
}

class _StirIconButtonState extends ConsumerState<StirIconButton> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  static const _animationDuration = Duration(milliseconds: 200);

  double get _animationValue => _animation.value;
  bool get _isDisabled => widget.onPressed == null;
  StirColorTheme get colors => ref.colors;
  _StirIconButtonType get type => widget._type;
  StirIconButtonSize get size => widget.size;

  @override
  void initState() {
    super.initState();

    const animationBegin = 0.0;
    const animationEnd = 1.0;

    _controller = AnimationController(
      vsync: this,
      value: animationBegin,
      duration: _animationDuration,
      reverseDuration: _animationDuration,
    );
    _animation = Tween<double>(
      begin: animationBegin,
      end: animationEnd,
    ).animate(_controller)
      ..addListener(_animationListener);
  }

  @override
  void dispose() {
    _animation.removeListener(_animationListener);
    _controller.dispose();
    super.dispose();
  }

  void _animationListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasGradient = type == _StirIconButtonType.primaryGradient;
    const scaleRatio = 0.9;

    final button = ClipRRect(
      borderRadius: BorderRadius.circular(StirSpacings.large96),
      clipBehavior: Clip.hardEdge,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          gradient: hasGradient && !_isDisabled ? colors.primaryGradient : null,
          shape: BoxShape.circle,
          border: _getBorder(),
        ),
        child: CustomPaint(
          foregroundPainter: widget.isSlashed
              ? _SlashPainter(
                  color: _getForegroundColor(),
                  width: size.decorationWidth,
                )
              : null,
          child: SizedBox.square(
            dimension: size.buttonSize,
            child: Center(
              child: () {
                switch (size) {
                  case StirIconButtonSize.small:
                    return StirIcon.standard(
                      iconData: widget.iconData,
                      color: _getForegroundColor(),
                    );
                  case StirIconButtonSize.medium:
                    return StirIcon.medium(
                      iconData: widget.iconData,
                      color: _getForegroundColor(),
                    );
                  case StirIconButtonSize.large:
                    return StirIcon.large(
                      iconData: widget.iconData,
                      color: _getForegroundColor(),
                    );
                }
              }(),
            ),
          ),
        ),
      ),
    );

    // Forbid any interactions if the button is disabled.
    if (_isDisabled) return button;

    return GestureDetector(
      onTapDown: (_) => _onTapStarted(),
      onTapUp: (_) => _onTapFinished(),
      onTapCancel: _onTapFinished,
      child: AnimatedScale(
        scale: _isPressed ? scaleRatio : 1,
        duration: _animationDuration,
        child: button,
      ),
    );
  }

  void _setPressedState(bool isPressed) {
    setState(() {
      _isPressed = isPressed;
    });
  }

  void _onTapStarted() {
    _setPressedState(true);

    if (_controller.isAnimating) {
      _controller.stop();
    }

    _controller.forward();
  }

  void _onTapFinished() {
    _setPressedState(false);

    if (_controller.isAnimating) {
      _controller.stop();
    }

    _controller.reverse();

    widget.onPressed?.call();
  }

  Color _getForegroundColor() {
    if (_isDisabled) {
      switch (type) {
        case _StirIconButtonType.standard:
          return colors.disabled;
        default:
          return colors.onDisabled;
      }
    }

    final idleColor = switch (type) {
      _StirIconButtonType.primaryGradient => colors.onPrimaryGradient,
      _StirIconButtonType.primary => colors.onPrimary,
      _StirIconButtonType.standard => colors.onSurface,
      _StirIconButtonType.outlined => colors.primary,
      _StirIconButtonType.outlinedInverted => colors.onSurfaceVariantLowEmphasis,
      _StirIconButtonType.inversedTransparent => widget.foregroundColor ?? colors.transparent,
    };

    return idleColor;
}

  Color? _getBackgroundColor() {
    if (_isDisabled) {
      switch (type) {
        case _StirIconButtonType.standard:
          return colors.transparent;
        default:
          return colors.disabled;
      }
    }

    switch (type) {
      case _StirIconButtonType.primaryGradient:
        return null;
      case _StirIconButtonType.primary:
        return widget.foregroundColor ?? colors.primary;
      case _StirIconButtonType.standard:
        final idleColor = colors.transparent;
        final pressedColor = colors.secondary;

        return Color.lerp(
              idleColor,
              pressedColor,
              _animationValue,
            ) ??
            (_isPressed ? pressedColor : idleColor);
      case _StirIconButtonType.outlined:
        return colors.transparent;
      case _StirIconButtonType.outlinedInverted:
        return colors.transparent;
      case _StirIconButtonType.inversedTransparent:
        final idleColor = colors.surface;
        final pressedColor = colors.onPrimary;

        return Color.lerp(
              idleColor,
              pressedColor,
              _animationValue,
            ) ??
            (_isPressed ? pressedColor : idleColor);
    }
  }

  BoxBorder? _getBorder() {
    if (_isDisabled) {
      return null;
    }

    switch (type) {
      case _StirIconButtonType.primaryGradient:
      case _StirIconButtonType.primary:
      case _StirIconButtonType.standard:
      case _StirIconButtonType.inversedTransparent:
        return null;
      case _StirIconButtonType.outlined:
        final idleColor = colors.primary;
        final pressedColor = colors.onPrimary;

        return Border.all(
          width: size.decorationWidth,
          color: Color.lerp(
                idleColor,
                pressedColor,
                _animationValue,
              ) ??
              (_isPressed ? pressedColor : idleColor),
        );
      case _StirIconButtonType.outlinedInverted:
        final idleColor = colors.onSurfaceVariantLowEmphasis;
        final pressedColor = colors.onPrimary;

        return Border.all(
          width: size.decorationWidth,
          color: Color.lerp(
                idleColor,
                pressedColor,
                _animationValue,
              ) ??
              (_isPressed ? pressedColor : idleColor),
        );
    }
  }
}

class _SlashPainter extends CustomPainter {
  const _SlashPainter({
    required this.color,
    required this.width,
  });

  final Color color;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(0, size.width)
      ..lineTo(size.height, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SlashPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
