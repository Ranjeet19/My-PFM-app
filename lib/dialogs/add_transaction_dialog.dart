import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class AddTransactionDialog extends StatefulWidget {
  final FinanceTransaction? existingTransaction;
  final int? index;

  const AddTransactionDialog({super.key, this.existingTransaction, this.index});

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = true;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  final List<String> _incomeCategories = ["Salary", "Borrow", "Other"];
  final List<String> _expenseCategories = [
    "Food",
    "Transport",
    "Rent",
    "Utilities",
    "Entertainment",
    "Shopping",
    "Health",
    "Other"
  ];

  @override
  void initState() {
    super.initState();
    _isIncome = widget.existingTransaction?.isIncome ?? true;
    _amountController = TextEditingController(
        text: widget.existingTransaction?.amount.toString() ?? '');
    _descriptionController = TextEditingController(
        text: widget.existingTransaction?.description ?? '');
    _selectedCategory = widget.existingTransaction?.category;
    _selectedDate = widget.existingTransaction?.date ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFE8FCEF), // Soft green background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add Transaction",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),

              const SizedBox(height: 20),

              // Type Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text("Income"),
                    selected: _isIncome,
                    selectedColor: Colors.green.shade100,
                    onSelected: (_) => setState(() => _isIncome = true),
                    labelStyle: TextStyle(
                        color: _isIncome ? Colors.green : Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text("Expense"),
                    selected: !_isIncome,
                    selectedColor: Colors.red.shade100,
                    onSelected: (_) => setState(() => _isIncome = false),
                    labelStyle:
                        TextStyle(color: !_isIncome ? Colors.red : Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g., Coffee with friends',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Enter description'
                    : null,
              ),

              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  hintText: '0.00',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || double.tryParse(val) == null
                    ? 'Enter valid amount'
                    : null,
              ),

              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: const Text('Select a category'),
                items: (_isIncome ? _incomeCategories : _expenseCategories)
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (val) => setState(() => _selectedCategory = val),
                validator: (val) =>
                    val == null ? 'Please select a category' : null,
              ),

              const SizedBox(height: 16),

              // Date Picker
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    DateFormat.yMMMMd().format(_selectedDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Save Button
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final txn = FinanceTransaction(
                      amount: double.parse(_amountController.text.trim()),
                      isIncome: _isIncome,
                      category: _selectedCategory!,
                      date: _selectedDate,
                      description: _descriptionController.text.trim(),
                    );

                    final box = Hive.box<FinanceTransaction>('transactions');
                    if (widget.index != null) {
                      box.putAt(widget.index!, txn);
                    } else {
                      box.add(txn);
                    }

                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add),
                label: const Text("Add Transaction"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
