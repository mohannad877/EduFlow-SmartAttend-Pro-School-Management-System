import 'package:flutter/material.dart';

/// شريط التطبيق المميز — موحّد لجميع الشاشات
/// يستخدم Theme.of(context) تلقائياً بدون حاجة لضبط يدوي
class PremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double? elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const PremiumAppBar({
    super.key,
    this.title,
    this.titleText,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
  }) : assert(
          title != null || titleText != null,
          'Either title or titleText must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;

    final effectiveBg = backgroundColor ??
        appBarTheme.backgroundColor ??
        theme.colorScheme.surface;

    final effectiveFg = foregroundColor ??
        appBarTheme.foregroundColor ??
        theme.colorScheme.onSurface;

    final titleWidget = title ??
        Text(
          titleText!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: appBarTheme.titleTextStyle ??
              theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: effectiveFg,
              ),
        );

    return AppBar(
      title: titleWidget,
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: effectiveBg,
      foregroundColor: effectiveFg,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withOpacity(0.08),
      actions: actions,
      leading: leading,
      shape: elevation != null && elevation! > 0
          ? null
          : const Border(
              bottom: BorderSide(color: Colors.transparent, width: 0),
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
