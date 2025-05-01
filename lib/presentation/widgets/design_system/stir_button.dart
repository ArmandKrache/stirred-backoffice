import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stirred_backoffice/core/theme/color.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/core/theme/text.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_icon.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';

enum StirButtonType {
  gradient,
  primary,
  outlined;
}

class StirButton extends ConsumerStatefulWidget {
  const StirButton({
    super.key,
    required this.label,
    required this.type,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.foregroundColor,
    this.backgroundColor,
    this.textStyle,
    this.outlined = false,
    this.padding,
  });

  const StirButton.gradient({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.foregroundColor,
    this.backgroundColor,
    this.textStyle,
    this.outlined = false,
    this.padding,
  }) : type = StirButtonType.gradient;

  const StirButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.foregroundColor,
    this.backgroundColor,
    this.textStyle,
    this.outlined = false,
    this.padding,
  }) : type = StirButtonType.primary;

  const StirButton.outlined({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.foregroundColor,
    this.backgroundColor,
    this.textStyle,
    this.outlined = true,
    this.padding,
  }) : type = StirButtonType.outlined;

  final String label;
  final StirButtonType type;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final bool outlined;
  final EdgeInsets? padding;

  @override
  ConsumerState<StirButton> createState() => StirButtonState();
}

class StirButtonState extends ConsumerState<StirButton> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  bool _isLoading = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  double? _buttonWidth;

  static const _animationDuration = Duration(milliseconds: 200);

  bool get _isDisabled => widget.onPressed == null;

  StirColorTheme get colors => ref.colors;

  StirButtonType get type => widget.type;

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
    final localLeadingIcon = widget.leadingIcon;
    final localTrailingIcon = widget.trailingIcon;
    final foregroundColor = widget.foregroundColor ?? _getForegroundColor();
    const buttonIdleHeight = 54.0;
    const scaleRatio = 0.9;
    const loaderSize = buttonIdleHeight - 2 * StirSpacings.small16;
    final contentKey = GlobalKey();

    final buttonContent = Row(
      key: contentKey,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (localLeadingIcon != null) ...[
          StirIcon.standard(
            iconData: localLeadingIcon,
            color: foregroundColor,
          ),
          const Gap(StirSpacings.small8),
        ],
        Flexible(
          child: StirText(
            widget.label,
            textAlign: TextAlign.center,
            color: foregroundColor,
            overflow: TextOverflow.ellipsis,
            style: widget.textStyle ?? StirTextTheme.bodyLarge,
          ),
        ),
        if (localTrailingIcon != null) ...[
          const Gap(StirSpacings.small8),
          StirIcon.standard(
            iconData: localTrailingIcon,
            color: foregroundColor,
          ),
        ],
      ],
    );

    final button = ClipRRect(
      borderRadius: BorderRadius.circular(StirSpacings.small8),
      clipBehavior: Clip.hardEdge,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? _getBackgroundColor(),
          gradient: _getGradient(),
          border: _getBorder(),
          borderRadius: BorderRadius.circular(StirSpacings.small8),
        ),
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.all(StirSpacings.small16),
          child: _isLoading
              ? SizedBox(
                  width: _buttonWidth,
                  child: Center(
                    child: SizedBox.square(
                      dimension: loaderSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: foregroundColor,
                      ),
                    ),
                  ),
                )
              : buttonContent,
        ),
      ),
    );

    if (_isDisabled || _isLoading) {
      return button;
    }

    return GestureDetector(
      onTapDown: (_) => _onTapStarted(),
      onTapUp: (_) async => onTapFinished(),
      onTapCancel: onTapFinished,
      child: AnimatedScale(
        scale: _isPressed ? scaleRatio : 1,
        duration: _animationDuration,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (_buttonWidth == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _buttonWidth = contentKey.currentContext?.size?.width ?? 0.0;
                });
              });
            }
            return button;
          },
        ),
      ),
    );
  }

  void _setPressedState(bool isPressed) {
    if (mounted) {
      setState(() {
        _isPressed = isPressed;
      });
    }
  }

  void _setLoadingState(bool isLoading) {
    if (mounted) {
      setState(() {
        _isLoading = isLoading;
      });
    }
  }

  void _onTapStarted() {
    _setPressedState(true);

    if (_controller.isAnimating) {
      _controller.stop();
    }

    _controller.forward();
  }

  Future<void> onTapFinished() async {
    final onPressed = widget.onPressed;

    _setPressedState(false);

    if (_controller.isAnimating) {
      _controller.stop();
    }

    unawaited(_controller.reverse());

    if (onPressed != null) {
      final isFutureCallback = onPressed is Future<void> Function();

      if (isFutureCallback) {
        _setLoadingState(true);
        await onPressed.call();
        _setLoadingState(false);
      } else {
        onPressed.call();
      }
    }
  }

  Color _getForegroundColor() {
    if (_isDisabled) {
      return colors.onDisabled;
    }

    final idleColor = switch (type) {
      StirButtonType.gradient => colors.onPrimaryGradient,
      StirButtonType.primary => colors.onPrimary,
      StirButtonType.outlined => colors.primary,
    };

    return idleColor;
  }

  Color? _getBackgroundColor() {
    if (_isDisabled) {
      return colors.disabled;
    }

    switch (type) {
      case StirButtonType.gradient:
        return null;
      case StirButtonType.primary:
        return colors.primary;
      case StirButtonType.outlined:
        return colors.transparent;
    }
  }

  Gradient? _getGradient() {
    if (type != StirButtonType.gradient || _isDisabled) {
      return null;
    }

    return colors.primaryGradient;
  }

  BoxBorder? _getBorder() {
    if (!widget.outlined || _isDisabled) {
      return null;
    }

    return Border.all(color: widget.foregroundColor ?? colors.primary);
  }
}
