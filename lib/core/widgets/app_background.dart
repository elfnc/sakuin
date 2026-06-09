import 'package:flutter/material.dart';
import 'package:sakuin/core/constants/app_colors.dart';
import 'dart:ui';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.background),
        // Top right coral blob
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
          ),
        ),
        // Bottom left tosca blob
        Positioned(
          bottom: -100,
          left: -150,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary.withValues(alpha: 0.15),
            ),
          ),
        ),
        // Middle soft yellow blob
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          left: -50,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.softAccent.withValues(alpha: 0.2),
            ),
          ),
        ),
        // Blur filter to create glassmorphism mesh effect
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 80.0),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
