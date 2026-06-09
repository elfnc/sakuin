import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakuin/core/constants/app_colors.dart';
import 'package:sakuin/core/constants/app_radius.dart';
import 'package:sakuin/core/constants/app_spacing.dart';
import 'package:sakuin/core/constants/app_assets.dart';
import 'package:sakuin/core/widgets/app_background.dart';
import 'package:sakuin/database/database_provider.dart';
import 'package:sakuin/database/app_database.dart';
import 'package:drift/drift.dart' as drift;

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedAvatar = AppAssets.momoHappy;
  bool _isLoading = false;

  final List<String> _avatars = [
    AppAssets.momoHappy,
    AppAssets.momoCalm,
    AppAssets.momoThinking,
    AppAssets.momoConcerned,
    AppAssets.momoSuccess,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong'), backgroundColor: AppColors.expense),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final db = ref.read(databaseProvider);

      await db.transaction(() async {
        // Update user 1
        await (db.update(db.users)..where((u) => u.id.equals(1))).write(
          UsersCompanion(
            name: drift.Value(name),
            avatar: drift.Value(_selectedAvatar),
          ),
        );

        // Set onboarding completed
        final settings = await db.select(db.appSettings).getSingleOrNull();
        if (settings != null) {
          await db.update(db.appSettings).replace(
            settings.copyWith(isOnboardingCompleted: true),
          );
        }
      });

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan profil: $e'), backgroundColor: AppColors.expense),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.s8),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                      onPressed: () => context.go('/onboarding'),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.s32),
                            decoration: BoxDecoration(
                              color: AppColors.surface.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: AppColors.surface.withValues(alpha: 0.5), width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Kenalan Yuk!',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.s8),
                                Text(
                                  'Pilih avatar Momo dan masukkan nama panggilanmu.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.s32),
                                
                                // Avatar Grid
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  alignment: WrapAlignment.center,
                                  children: _avatars.map((avatar) {
                                    final isSelected = avatar == _selectedAvatar;
                                    return GestureDetector(
                                      onTap: () => setState(() => _selectedAvatar = avatar),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeOutBack,
                                        transform: Matrix4.diagonal3Values(isSelected ? 1.1 : 0.9, isSelected ? 1.1 : 0.9, 1.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : Colors.transparent,
                                          boxShadow: isSelected ? [
                                            BoxShadow(
                                              color: AppColors.primary.withValues(alpha: 0.3),
                                              blurRadius: 15,
                                              spreadRadius: 2,
                                            )
                                          ] : [],
                                          border: Border.all(
                                            color: isSelected ? AppColors.primary : Colors.transparent,
                                            width: 3,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 36,
                                          backgroundColor: AppColors.surface.withValues(alpha: 0.5),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              AnimatedOpacity(
                                                duration: const Duration(milliseconds: 200),
                                                opacity: isSelected ? 1.0 : 0.6,
                                                child: Image.asset(avatar, width: 50, height: 50),
                                              ),
                                              if (isSelected)
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: Container(
                                                    padding: const EdgeInsets.all(2),
                                                    decoration: const BoxDecoration(
                                                      color: AppColors.primary,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(Icons.check, color: AppColors.surface, size: 14),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                
                                const SizedBox(height: AppSpacing.s48),
                                
                                // Name Input
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s4),
                                  decoration: BoxDecoration(
                                    color: AppColors.background, // Slightly darker than surface
                                    borderRadius: BorderRadius.circular(AppRadius.large),
                                    border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                                  ),
                                  child: TextField(
                                    controller: _nameController,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Nama panggilan',
                                      hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: AppSpacing.s32),
                                
                                // Save Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _saveProfile,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
                                      backgroundColor: AppColors.primary,
                                      elevation: 8,
                                      shadowColor: AppColors.primary.withValues(alpha: 0.5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(AppRadius.large),
                                      ),
                                    ),
                                    child: _isLoading 
                                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                        : Text(
                                            'Mulai Sekarang!', 
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              color: AppColors.surface,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
