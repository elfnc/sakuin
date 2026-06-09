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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.go('/onboarding'),
        ),
      ),
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Kenalan Yuk!',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      'Pilih avatar Momo dan masukkan nama panggilanmu biar makin akrab.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s48),
                    
                    // Avatar Selection
                    Center(
                      child: SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _avatars.length,
                          itemBuilder: (context, index) {
                            final avatar = _avatars[index];
                            final isSelected = avatar == _selectedAvatar;
                            
                            return GestureDetector(
                              onTap: () => setState(() => _selectedAvatar = avatar),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
                                padding: const EdgeInsets.all(AppSpacing.s8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
                                  border: isSelected 
                                      ? Border.all(color: AppColors.primary, width: 2)
                                      : Border.all(color: Colors.transparent, width: 2),
                                ),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: AppColors.surface,
                                  child: Image.asset(avatar, width: 60, height: 60),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.s48),
                    
                    // Name Input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.large),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nama panggilan',
                          icon: Icon(Icons.person_outline, color: AppColors.primary),
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    const SizedBox(height: AppSpacing.s24), // Added padding for scroll
                    
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.large),
                          ),
                        ),
                        child: _isLoading 
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text('Simpan & Lanjut', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.surface)),
                      ),
                    ),
                  ],
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
