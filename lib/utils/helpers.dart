import 'package:flutter/material.dart';
import 'app_colors.dart';

PreferredSizeWidget buildAppBar(String title,
    {List<Widget>? actions, bool centerTitle = true}) {
  return AppBar(
    title: Text(title),
    centerTitle: centerTitle,
    actions: actions,
    backgroundColor: AbColors.primary,
  );
}

Widget emptyState(String message) {
  return Center(
    child: Text(
      message,
      style: const TextStyle(color: AbColors.muted),
      textAlign: TextAlign.center,
    ),
  );
}
