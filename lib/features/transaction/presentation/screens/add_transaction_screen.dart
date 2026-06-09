import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import 'package:sakuin/core/constants/app_colors.dart';
import 'package:sakuin/core/constants/app_spacing.dart';
import 'package:sakuin/core/constants/app_radius.dart';
import 'package:sakuin/core/theme/text_theme.dart';
import 'package:sakuin/database/database_provider.dart';
import 'package:sakuin/database/app_database.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final String initialType;

  const AddTransactionScreen({
    super.key,
    this.initialType = 'expense',
  });

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  late String _type;
  double _amount = 0;
  int? _selectedCategoryId;
  int? _selectedWalletId;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
    
    // Default to the first wallet
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final db = ref.read(databaseProvider);
      final wallets = await db.select(db.wallets).get();
      if (wallets.isNotEmpty && mounted) {
        setState(() {
          _selectedWalletId = wallets.first.id;
        });
      }
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged(String value) {
    // Remove non-digits
    final numericString = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericString.isEmpty) {
      _amount = 0;
      _amountController.text = '';
      return;
    }
    _amount = double.parse(numericString);
    final formatted = NumberFormat('#,###', 'id_ID').format(_amount);
    
    _amountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  Future<void> _saveTransaction() async {
    if (_amount <= 0 || _selectedCategoryId == null || _selectedWalletId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi nominal, kategori, dan dompet')),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    
    await db.transaction(() async {
      // 1. Insert transaction
      await db.into(db.transactions).insert(
        TransactionsCompanion.insert(
          userId: 1, // Default user
          amount: _amount,
          type: _type,
          categoryId: _selectedCategoryId!,
          walletId: _selectedWalletId!,
          transactionDate: _selectedDate,
          note: drift.Value(_noteController.text.isNotEmpty ? _noteController.text : null),
        ),
      );

      // 2. Update wallet balance
      final wallet = await (db.select(db.wallets)..where((w) => w.id.equals(_selectedWalletId!))).getSingle();
      final newBalance = _type == 'income' 
          ? wallet.balance + _amount 
          : wallet.balance - _amount;

      await (db.update(db.wallets)..where((w) => w.id.equals(_selectedWalletId!))).write(
        WalletsCompanion(balance: drift.Value(newBalance)),
      );
    });

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final db = ref.watch(databaseProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _type == 'income' ? 'Tambah Pemasukan' : 'Tambah Pengeluaran',
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Amount Input (Hero)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s32),
                      child: Column(
                        children: [
                          Text(
                            'Nominal',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.s8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Rp',
                                  style: AppTextTheme.moneyAmount.copyWith(
                                    fontSize: 24,
                                    color: _type == 'income' ? AppColors.income : AppColors.expense,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.s8),
                              IntrinsicWidth(
                                child: TextField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  onChanged: _onAmountChanged,
                                  textAlign: TextAlign.center,
                                  style: AppTextTheme.moneyAmount.copyWith(
                                    fontSize: 48,
                                    color: _type == 'income' ? AppColors.income : AppColors.expense,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '0',
                                    hintStyle: TextStyle(color: AppColors.border),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Toggle Type
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _type = 'expense'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                                  decoration: BoxDecoration(
                                    color: _type == 'expense' ? AppColors.expense : Colors.transparent,
                                    borderRadius: BorderRadius.circular(AppRadius.pill),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Pengeluaran',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: _type == 'expense' ? AppColors.surface : AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _type = 'income'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                                  decoration: BoxDecoration(
                                    color: _type == 'income' ? AppColors.income : Colors.transparent,
                                    borderRadius: BorderRadius.circular(AppRadius.pill),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Pemasukan',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: _type == 'income' ? AppColors.surface : AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s32),

                    // Category Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kategori', style: theme.textTheme.headlineMedium),
                          const SizedBox(height: AppSpacing.s16),
                          StreamBuilder(
                            stream: db.select(db.categories).watch(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return const CircularProgressIndicator();
                              final categories = snapshot.data!.where((c) => c.type == _type).toList();
                              
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 0.8,
                                  crossAxisSpacing: AppSpacing.s12,
                                  mainAxisSpacing: AppSpacing.s12,
                                ),
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final cat = categories[index];
                                  final isSelected = _selectedCategoryId == cat.id;
                                  
                                  return GestureDetector(
                                    onTap: () => setState(() => _selectedCategoryId = cat.id),
                                    child: AnimatedScale(
                                      duration: const Duration(milliseconds: 200),
                                      scale: isSelected ? 1.05 : 1.0,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(AppSpacing.s12),
                                            decoration: BoxDecoration(
                                              color: isSelected 
                                                  ? (_type == 'income' ? AppColors.income.withValues(alpha: 0.1) : AppColors.expense.withValues(alpha: 0.1))
                                                  : AppColors.surface,
                                              shape: BoxShape.circle,
                                              border: isSelected ? Border.all(
                                                color: _type == 'income' ? AppColors.income : AppColors.expense,
                                                width: 2,
                                              ) : null,
                                            ),
                                            child: Icon(
                                              Icons.category,
                                              color: isSelected 
                                                  ? (_type == 'income' ? AppColors.income : AppColors.expense)
                                                  : AppColors.textSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: AppSpacing.s4),
                                          Text(
                                            cat.name,
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s24),

                    // Additional Fields (Wallet, Date, Note)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.large),
                        ),
                        child: Column(
                          children: [
                            // Wallet Picker
                            ListTile(
                              leading: const Icon(Icons.account_balance_wallet, color: AppColors.primary),
                              title: const Text('Dompet'),
                              trailing: StreamBuilder(
                                stream: db.select(db.wallets).watch(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) return const SizedBox();
                                  final wallets = snapshot.data!;
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      value: _selectedWalletId,
                                      items: wallets.map((w) => DropdownMenuItem(
                                        value: w.id,
                                        child: Text(w.name),
                                      )).toList(),
                                      onChanged: (val) => setState(() => _selectedWalletId = val),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const Divider(height: 1),
                            // Date Picker
                            ListTile(
                              leading: const Icon(Icons.calendar_today, color: AppColors.primary),
                              title: const Text('Tanggal'),
                              trailing: TextButton(
                                onPressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: _selectedDate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (date != null) {
                                    setState(() => _selectedDate = date);
                                  }
                                },
                                child: Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
                              ),
                            ),
                            const Divider(height: 1),
                            // Note
                            ListTile(
                              leading: const Icon(Icons.notes, color: AppColors.primary),
                              title: TextField(
                                controller: _noteController,
                                decoration: const InputDecoration(
                                  hintText: 'Tambahkan catatan...',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s48),
                  ],
                ),
              ),
            ),
            
            // Save Button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _type == 'income' ? AppColors.income : AppColors.expense,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.large),
                    ),
                  ),
                  child: Text(
                    'Simpan',
                    style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.surface),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
