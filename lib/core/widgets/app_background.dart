import 'package:flutter/material.dart';
import 'package:sakuin/core/constants/app_colors.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
    );
  }
}
