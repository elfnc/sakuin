import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:sakuin/database/app_database.dart';
import 'package:sakuin/database/database_provider.dart';
import 'package:drift/drift.dart' as drift;

class OcrState {
  final bool isLoading;
  final String? error;
  final File? selectedImage;
  final double? parsedAmount;
  final DateTime? parsedDate;
  final String? parsedMerchant;

  const OcrState({
    this.isLoading = false,
    this.error,
    this.selectedImage,
    this.parsedAmount,
    this.parsedDate,
    this.parsedMerchant,
  });

  OcrState copyWith({
    bool? isLoading,
    String? error,
    File? selectedImage,
    double? parsedAmount,
    DateTime? parsedDate,
    String? parsedMerchant,
  }) {
    return OcrState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedImage: selectedImage ?? this.selectedImage,
      parsedAmount: parsedAmount ?? this.parsedAmount,
      parsedDate: parsedDate ?? this.parsedDate,
      parsedMerchant: parsedMerchant ?? this.parsedMerchant,
    );
  }
}

class OcrNotifier extends Notifier<OcrState> {
  final _imagePicker = ImagePicker();
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  @override
  OcrState build() {
    return const OcrState();
  }

  Future<void> pickAndScanImage(ImageSource source) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final file = File(pickedFile.path);
      state = state.copyWith(selectedImage: file);

      await _processImage(file);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Gagal membaca gambar: $e');
    }
  }

  Future<void> _processImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      double? highestAmount;
      String? merchant;
      DateTime? date;

      // Simple parsing logic
      final lines = recognizedText.blocks.expand((b) => b.lines).map((l) => l.text).toList();
      
      if (lines.isNotEmpty) {
        // Assume first line might be merchant name
        merchant = lines.first;
      }

      // Regex to find amounts (e.g. 15.000, 15,000, 15000)
      final amountRegex = RegExp(r'(?:Rp\.?\s*)?(\d{1,3}(?:[.,]\d{3})+(?:[.,]\d{2})?)|\b\d{4,}\b');
      // Regex to find date
      final dateRegex = RegExp(r'\b(\d{1,2})[-/](\d{1,2})[-/](\d{2,4})\b');

      for (var line in lines) {
        // Amount parsing
        final amountMatch = amountRegex.firstMatch(line);
        if (amountMatch != null) {
          final matchStr = amountMatch.group(0) ?? '';
          final digitsOnly = matchStr.replaceAll(RegExp(r'[^\d]'), '');
          if (digitsOnly.isNotEmpty) {
            final val = double.tryParse(digitsOnly);
            if (val != null) {
              if (highestAmount == null || val > highestAmount) {
                // Often the total is the largest number on the receipt
                highestAmount = val;
              }
            }
          }
        }

        // Date parsing
        final dateMatch = dateRegex.firstMatch(line);
        if (dateMatch != null && date == null) {
          try {
            final d = int.parse(dateMatch.group(1)!);
            final m = int.parse(dateMatch.group(2)!);
            var y = int.parse(dateMatch.group(3)!);
            if (y < 100) y += 2000;
            date = DateTime(y, m, d);
          } catch (_) {}
        }
      }

      state = state.copyWith(
        isLoading: false,
        parsedAmount: highestAmount,
        parsedDate: date ?? DateTime.now(),
        parsedMerchant: merchant,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Gagal memproses teks: $e');
    }
  }

  void updateParsedData({double? amount, String? merchant, DateTime? date}) {
    state = state.copyWith(
      parsedAmount: amount ?? state.parsedAmount,
      parsedMerchant: merchant ?? state.parsedMerchant,
      parsedDate: date ?? state.parsedDate,
    );
  }

  void reset() {
    state = const OcrState();
  }

  Future<void> saveTransaction({required int categoryId, required int walletId, String? notes}) async {
    final amount = state.parsedAmount;
    if (amount == null) return;
    
    final db = ref.read(databaseProvider);
    
    await db.into(db.transactions).insert(
      TransactionsCompanion.insert(
        userId: 1,
        amount: amount,
        type: 'expense',
        categoryId: categoryId,
        walletId: walletId,
        transactionDate: state.parsedDate ?? DateTime.now(),
        note: drift.Value(notes ?? state.parsedMerchant ?? 'OCR Scan'),
        source: const drift.Value('ocr'),
      )
    );
    
    reset();
  }
}

final ocrProvider = NotifierProvider<OcrNotifier, OcrState>(() {
  return OcrNotifier();
});
