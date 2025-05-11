import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stirred_backoffice/core/theme/text.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';

/// {@template fast_text}
/// A Widget enclosing a [Text] widget.
///
/// If no `style` is specified, [StirTextTheme.bodyLarge] is used by default.
///
/// If no `color` is specified, `onSurface` color from `FastColorTheme` is used
/// by default.
/// {@endtemplate}
class StirText extends ConsumerWidget {
  /// {@macro fast_text}
  const StirText(
    this.data, {
    super.key,
    this.style,
    this.color,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
  });

  /// {@macro fast_text}
  ///
  /// This [StirText] uses the [StirTextTheme.labelSmall] style.
  const StirText.labelSmall(
    this.data, {
    super.key,
    this.color,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
  }) : style = StirTextTheme.labelSmall;

  /// {@macro fast_text}
  ///
  /// This [StirText] uses the [StirTextTheme.labelMedium] style.
  const StirText.labelMedium(
    this.data, {
    super.key,
    this.color,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
  }) : style = StirTextTheme.labelMedium;

  /// {@macro fast_text}
  ///
  /// This [StirText] uses the [FastTextTheme.labelLarge] style.
  const StirText.labelLarge(
    this.data, {
    super.key,
    this.color,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
  }) : style = StirTextTheme.labelLarge;

  /// {@macro fast_text}
  ///
  /// This [StirText] uses the [StirTextTheme.labelInlineButton] style.
  const StirText.labelInlineButton(
    this.data, {
    super.key,
    this.color,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
  }) : style = StirTextTheme.labelInlineButton;

  /// {@macro fast_text}
  ///
  /// This [StirText] uses the [StirTextTheme.bodySmall] style.
  const StirText.bodySmall(
    this.data, {
    super.key,
    this.color,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
  }) : style = StirTextTheme.bodySmall;

  /// {@macro fast_text}
  ///
  /// This [StirText] uses the [StirTextTheme.bodyMedium] style.
  const StirText.bodyMedium(
    this.data, {
    super.key,
    this.color,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
  }) : style = StirTextTheme.bodyMedium;

  /// {@macro fast_text}
  ///
  /// This [StirText] uses the [StirTextTheme.bodyLarge] style.
  const StirText.bodyLarge(
    this.data, {
    super.key,
    this.color,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
  }) : style = StirTextTheme.bodyLarge;

  /// {@macro fast_text}
  ///
  /// This [StirText] uses the [StirTextTheme.titleSmall] style.
  const StirText.titleSmall(
    this.data, {
    super.key,
    this.color,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
  }) : style = StirTextTheme.titleSmall;

  /// {@macro fast_text}
  ///
  /// This [StirText] uses the [StirTextTheme.titleMedium] style.
  const StirText.titleMedium(
    this.data, {
    super.key,
    this.color,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
  }) : style = StirTextTheme.titleMedium;

  /// {@macro fast_text}
  ///
  /// This [StirText] uses the [StirTextTheme.titleLarge] style.
  const StirText.titleLarge(
    this.data, {
    super.key,
    this.color,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
  }) : style = StirTextTheme.titleLarge;

  /// {@macro fast_text}
  ///
  /// This [StirText] uses the [StirTextTheme.headlineSmall] style.
  const StirText.headlineSmall(
    this.data, {
    super.key,
    this.color,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
  }) : style = StirTextTheme.headlineSmall;

  /// {@macro fast_text}
  ///
  /// This [StirText] uses the [StirTextTheme.headlineMedium] style.
  const StirText.headlineMedium(
    this.data, {
    super.key,
    this.color,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
  }) : style = StirTextTheme.headlineMedium;

  /// {@macro fast_text}
  ///
  /// This [StirText] uses the [StirTextTheme.lsdHeadlineXs] style.
  const StirText.lsdHeadlineXs(
    this.data, {
    super.key,
    this.color,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
  }) : style = StirTextTheme.lsdHeadlineXs;

  /// {@macro fast_text}
  ///
  /// This [StirText] uses the [StirTextTheme.lsdHeadlineSmall] style.
  const StirText.lsdHeadlineSmall(
    this.data, {
    super.key,
    this.color,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
  }) : style = StirTextTheme.lsdHeadlineSmall;

  /// {@macro fast_text}
  ///
  /// This [StirText] uses the [StirTextTheme.lsdHeadlineMedium] style.
  const StirText.lsdHeadlineMedium(
    this.data, {
    super.key,
    this.color,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
  }) : style = StirTextTheme.lsdHeadlineMedium;

  /// {@macro fast_text}
  ///
  /// This [StirText] uses the [StirTextTheme.lsdHeadlineLarge] style.
  const StirText.lsdHeadlineLarge(
    this.data, {
    super.key,
    this.color,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
  }) : style = StirTextTheme.lsdHeadlineLarge;

  final String data;
  final TextStyle? style;
  final Color? color;
  final Color? backgroundColor;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? fontSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textColor = color ?? ref.colors.onSurface;
    final textStyle = (style ?? StirTextTheme.bodyLarge).copyWith(
      color: textColor,
      backgroundColor: backgroundColor,
      decoration: decoration,
      decorationColor: decorationColor,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );

    return Text(
      data,
      style: textStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  StirText copyWith({
    String? data,
    TextStyle? style,
    Color? color,
    Color? backgroundColor,
    TextDecoration? decoration,
    Color? decorationColor,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? fontSize,
  }) {
    return StirText(
      data ?? this.data,
      style: style ?? this.style,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      decoration: decoration ?? this.decoration,
      decorationColor: decorationColor ?? this.decorationColor,
      fontWeight: fontWeight ?? this.fontWeight,
      textAlign: textAlign ?? this.textAlign,
      overflow: overflow ?? this.overflow,
      maxLines: maxLines ?? this.maxLines,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}
