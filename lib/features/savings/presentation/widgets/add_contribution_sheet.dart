import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:sakuin/core/constants/app_colors.dart';
import 'package:sakuin/core/constants/app_spacing.dart';
import 'package:sakuin/database/app_database.dart';
import 'package:sakuin/features/savings/providers/savings_provider.dart';

class AddContributionSheet extends ConsumerStatefulWidget {
  final SavingsGoal goal;

  const AddContributionSheet({super.key, required this.goal});

  @override
  ConsumerState<AddContributionSheet> createState() => _AddContributionSheetState();
}

class _AddContributionSheetState extends ConsumerState<AddContributionSheet> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isLoading = false;
  
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -30.0).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: -30.0, end: 0.0).chain(CurveTween(curve: Curves.bounceOut)), weight: 50),
    ]).animate(_bounceController);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final amount = double.tryParse(_amountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;
      final note = _noteController.text.trim();
      
      try {
        await ref.read(savingsProvider.notifier).addContribution(widget.goal.id, amount, note);
        // Play bounce animation before popping
        await _bounceController.forward();
        if (mounted) {
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menabung: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.goal.targetAmount - widget.goal.currentAmount;
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s24),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.s24),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Animated Coin Icon
              AnimatedBuilder(
                animation: _bounceAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _bounceAnimation.value),
                    child: child,
                  );
                },
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.income.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.monetization_on, size: 48, color: AppColors.income),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              
              Text(
                'Isi Celengan: ${widget.goal.title}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                'Kurang ${currencyFormat.format(remaining)} lagi!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s32),
              
              Text('Jumlah', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.s8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Rp 0',
                  prefixText: 'Rp ',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Nominal wajib diisi';
                  final val = double.tryParse(v) ?? 0.0;
                  if (val <= 0) return 'Nominal tidak valid';
                  if (val > remaining) return 'Maksimal tabungan ${currencyFormat.format(remaining)}';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.s16),
              
              Text('Catatan (Opsional)', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.s8),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: 'Sisa uang jajan',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: AppSpacing.s32),
              
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // Coral
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: AppColors.surface)
                      : const Text('Masukkin ke Celengan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.surface)),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
      ),
    );
  }
}
