import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stirred_backoffice/core/constants/constants.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';
import 'package:stirred_backoffice/presentation/router.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_icon_button.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';

class FastAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const FastAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.backgroundColor,
    this.centerTitle = false,
    this.scrolledUnderElevation = 0.0,
    this.leadingWidth,
    this.titleWidget,
    this.height,
  });

  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final String? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double scrolledUnderElevation;
  final double? leadingWidth;
  final Widget? titleWidget;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.colors;
    final theme = Theme.of(context);

    return AppBar(
      actions: actions,
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      centerTitle: centerTitle,
      elevation: 0.0,
      scrolledUnderElevation: scrolledUnderElevation,
      shadowColor: ref.colors.onSurfaceVariantLowEmphasis.withOpacity(0.5),
      leading: leading ??
          (automaticallyImplyLeading
              ? StirIconButton.standard(
                  iconData: Icons.chevron_left,
                  onPressed: () {
                    if (router.canPop()) router.pop();
                  },
                )
              : null),
      leadingWidth: leadingWidth,
      toolbarHeight: height ?? preferredSize.height,
      surfaceTintColor: colors.surface,
      title: titleWidget ??
          StirText.lsdHeadlineMedium(
            title ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(StirConstants.appBarHeight);
}
