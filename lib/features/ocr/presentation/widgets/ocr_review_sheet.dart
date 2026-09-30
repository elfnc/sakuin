import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sakuin/core/constants/app_colors.dart';
import 'package:sakuin/core/constants/app_spacing.dart';
import 'package:sakuin/features/ocr/providers/ocr_provider.dart';

class OcrReviewSheet extends ConsumerStatefulWidget {
  const OcrReviewSheet({super.key});

  @override
  ConsumerState<OcrReviewSheet> createState() => _OcrReviewSheetState();
}

class _OcrReviewSheetState extends ConsumerState<OcrReviewSheet> {
  late TextEditingController _amountController;
  late TextEditingController _merchantController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(ocrProvider);
    _amountController = TextEditingController(text: state.parsedAmount?.toStringAsFixed(0) ?? '');
    _merchantController = TextEditingController(text: state.parsedMerchant ?? '');
  }

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.s24,
        right: AppSpacing.s24,
        top: AppSpacing.s24,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.s24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          Text(
            'Review Hasil Scan',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s24),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Nominal Terdeteksi (Rp)',
              filled: true,
              fillColor: AppColors.surfaceSoft,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          TextField(
            controller: _merchantController,
            decoration: InputDecoration(
              labelText: 'Merchant / Catatan',
              filled: true,
              fillColor: AppColors.surfaceSoft,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s32),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(_amountController.text);
              if (amount != null) {
                ref.read(ocrProvider.notifier).updateParsedData(
                  amount: amount,
                  merchant: _merchantController.text,
                );
                // Here you would show category/wallet picker, for MVP we save directly
                // Assuming categoryId=1, walletId=1 as defaults for now
                await ref.read(ocrProvider.notifier).saveTransaction(categoryId: 1, walletId: 1, notes: _merchantController.text);
                if (context.mounted) {
                  context.pop(); // Close sheet
                  context.pop(); // Close scanner
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Simpan Transaksi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: AppSpacing.s12),
          TextButton(
            onPressed: () {
              ref.read(ocrProvider.notifier).reset();
              context.pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
            child: const Text('Batal & Ulangi'),
          ),
        ],
      ),
    );
  }
}
