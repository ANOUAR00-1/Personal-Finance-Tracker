import 'dart:io';
import 'dart:convert';

/// Enum to represent transaction types
enum TransactionType { income, expense }

/// Model class representing a financial transaction
class Transaction {
  final String id;
  final String description;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String category;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
  });

  /// Convert transaction to JSON for persistence
  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'amount': amount,
        'type': type.toString(),
        'date': date.toIso8601String(),
        'category': category,
      };

  /// Create transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      type: json['type'].toString().contains('income')
          ? TransactionType.income
          : TransactionType.expense,
      date: DateTime.parse(json['date']),
      category: json['category'],
    );
  }

  /// Get formatted amount with sign
  String get formattedAmount {
    final sign = type == TransactionType.income ? '+' : '-';
    return '$sign\$${amount.toStringAsFixed(2)}';
  }

  /// Get formatted date
  String get formattedDate {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

/// Main finance tracker class managing all transactions
class FinanceTracker {
  List<Transaction> _transactions = [];
  static const String _dataFile = 'finance_data.json';

  FinanceTracker() {
    _loadTransactions();
  }

  /// Add a new transaction
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    _saveTransactions();
    print('✓ Transaction added successfully!');
  }

  /// Delete a transaction by ID
  bool deleteTransaction(String id) {
    final initialLength = _transactions.length;
    _transactions.removeWhere((t) => t.id == id);
    if (_transactions.length < initialLength) {
      _saveTransactions();
      print('✓ Transaction deleted successfully!');
      return true;
    }
    print('✗ Transaction not found!');
    return false;
  }

  /// Get total income
  double getTotalIncome() {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Get total expenses
  double getTotalExpenses() {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Get current balance
  double getBalance() {
    return getTotalIncome() - getTotalExpenses();
  }

  /// List all transactions with formatting
  void listTransactions() {
    if (_transactions.isEmpty) {
      print('\n📋 No transactions recorded yet.');
      return;
    }

    print('\n${'=' * 80}');
    print('TRANSACTION HISTORY'.padLeft(45));
    print('=' * 80);
    print(
        '${'ID'.padRight(8)} ${'Date'.padRight(12)} ${'Type'.padRight(10)} ${'Category'.padRight(15)} ${'Description'.padRight(20)} ${'Amount'.padLeft(12)}');
    print('-' * 80);

    for (var transaction in _transactions) {
      final typeStr = transaction.type == TransactionType.income ? '📈 Income' : '📉 Expense';
      print(
          '${transaction.id.substring(0, 6).padRight(8)} ${transaction.formattedDate.padRight(12)} ${typeStr.padRight(10)} ${transaction.category.padRight(15)} ${transaction.description.padRight(20)} ${transaction.formattedAmount.padLeft(12)}');
    }
    print('=' * 80);
  }

  /// Display summary statistics
  void showSummary() {
    final income = getTotalIncome();
    final expenses = getTotalExpenses();
    final balance = getBalance();

    print('\n${'=' * 50}');
    print('FINANCIAL SUMMARY'.padLeft(30));
    print('=' * 50);
    print('📈 Total Income:      \$${income.toStringAsFixed(2)}'.padLeft(40));
    print('📉 Total Expenses:    \$${expenses.toStringAsFixed(2)}'.padLeft(40));
    print('-' * 50);
    print('💰 Current Balance:   \$${balance.toStringAsFixed(2)}'.padLeft(40));
    print('=' * 50);

    // Category breakdown
    _showCategoryBreakdown();
  }

  /// Show expense breakdown by category
  void _showCategoryBreakdown() {
    final categoryTotals = <String, double>{};

    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.expense) {
        categoryTotals[transaction.category] =
            (categoryTotals[transaction.category] ?? 0) + transaction.amount;
      }
    }

    if (categoryTotals.isNotEmpty) {
      print('\n📊 EXPENSE BREAKDOWN BY CATEGORY:');
      print('-' * 50);
      categoryTotals.forEach((category, total) {
        print('  ${category.padRight(20)}: \$${total.toStringAsFixed(2)}');
      });
    }
  }

  /// Save transactions to file
  void _saveTransactions() {
    try {
      final file = File(_dataFile);
      final jsonData = _transactions.map((t) => t.toJson()).toList();
      file.writeAsStringSync(json.encode(jsonData));
    } catch (e) {
      print('⚠ Warning: Could not save data: $e');
    }
  }

  /// Load transactions from file
  void _loadTransactions() {
    try {
      final file = File(_dataFile);
      if (file.existsSync()) {
        final jsonData = json.decode(file.readAsStringSync()) as List;
        _transactions = jsonData.map((j) => Transaction.fromJson(j)).toList();
        print('✓ Loaded ${_transactions.length} transaction(s) from file.');
      }
    } catch (e) {
      print('⚠ Warning: Could not load data: $e');
    }
  }

  /// Get transaction count
  int get transactionCount => _transactions.length;
}

/// Utility class for user input handling
class InputHelper {
  /// Read a non-empty string from user
  static String? readString(String prompt) {
    stdout.write(prompt);
    final input = stdin.readLineSync()?.trim();
    return (input != null && input.isNotEmpty) ? input : null;
  }

  /// Read and validate a double from user
  static double? readDouble(String prompt) {
    stdout.write(prompt);
    final input = stdin.readLineSync();
    return double.tryParse(input ?? '');
  }

  /// Read and validate a positive double
  static double? readPositiveDouble(String prompt) {
    final value = readDouble(prompt);
    return (value != null && value > 0) ? value : null;
  }

  /// Read an integer choice
  static int? readInt(String prompt) {
    stdout.write(prompt);
    final input = stdin.readLineSync();
    return int.tryParse(input ?? '');
  }
}

/// Main application class
class FinanceApp {
  final FinanceTracker _tracker = FinanceTracker();

  static const List<String> expenseCategories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Education',
    'Other'
  ];

  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Gift',
    'Other'
  ];

  /// Run the application
  void run() {
    print('💰 Welcome to Professional Personal Finance Tracker 💰');

    while (true) {
      _displayMenu();
      final choice = InputHelper.readInt('Choose an option (1-6): ');

      switch (choice) {
        case 1:
          _addTransaction();
          break;
        case 2:
          _tracker.listTransactions();
          break;
        case 3:
          _tracker.showSummary();
          break;
        case 4:
          _deleteTransaction();
          break;
        case 5:
          _showHelp();
          break;
        case 6:
          print('\n👋 Thank you for using Finance Tracker. Goodbye!');
          return;
        default:
          print('✗ Invalid option. Please choose 1-6.');
      }
    }
  }

  /// Display main menu
  void _displayMenu() {
    print('\n${'=' * 50}');
    print('MAIN MENU'.padLeft(28));
    print('=' * 50);
    print('  1. 💵 Add Transaction');
    print('  2. 📋 List All Transactions');
    print('  3. 📊 View Financial Summary');
    print('  4. 🗑️  Delete Transaction');
    print('  5. ❓ Help');
    print('  6. 🚪 Exit');
    print('=' * 50);
  }

  /// Add a new transaction
  void _addTransaction() {
    print('\n--- ADD NEW TRANSACTION ---');

    // Get transaction type
    print('\nSelect transaction type:');
    print('  1. Income');
    print('  2. Expense');
    final typeChoice = InputHelper.readInt('Enter choice (1 or 2): ');

    TransactionType? type;
    List<String> categories;

    if (typeChoice == 1) {
      type = TransactionType.income;
      categories = incomeCategories;
    } else if (typeChoice == 2) {
      type = TransactionType.expense;
      categories = expenseCategories;
    } else {
      print('✗ Invalid choice!');
      return;
    }

    // Get category
    print('\nSelect category:');
    for (int i = 0; i < categories.length; i++) {
      print('  ${i + 1}. ${categories[i]}');
    }
    final categoryChoice = InputHelper.readInt('Enter choice (1-${categories.length}): ');

    if (categoryChoice == null || categoryChoice < 1 || categoryChoice > categories.length) {
      print('✗ Invalid category!');
      return;
    }
    final category = categories[categoryChoice - 1];

    // Get description
    final description = InputHelper.readString('Enter description: ');
    if (description == null) {
      print('✗ Description cannot be empty!');
      return;
    }

    // Get amount
    final amount = InputHelper.readPositiveDouble('Enter amount: \$');
    if (amount == null) {
      print('✗ Invalid amount! Must be a positive number.');
      return;
    }

    // Create transaction
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: description,
      amount: amount,
      type: type,
      date: DateTime.now(),
      category: category,
    );

    _tracker.addTransaction(transaction);
  }

  /// Delete a transaction
  void _deleteTransaction() {
    if (_tracker.transactionCount == 0) {
      print('\n📋 No transactions to delete.');
      return;
    }

    _tracker.listTransactions();
    print('\n--- DELETE TRANSACTION ---');
    final id = InputHelper.readString('Enter transaction ID (first 6 characters): ');

    if (id == null) {
      print('✗ Invalid ID!');
      return;
    }

    // Find matching transaction
    _tracker.deleteTransaction(id);
  }

  /// Show help information
  void _showHelp() {
    print('\n${'=' * 50}');
    print('HELP & INFORMATION'.padLeft(32));
    print('=' * 50);
    print('''
📖 ABOUT:
   This is a professional personal finance tracking
   application to help you manage your income and expenses.

🎯 FEATURES:
   • Track income and expenses with categories
   • View detailed transaction history
   • See financial summaries and statistics
   • Automatic data persistence
   • Category-wise expense breakdown

💡 TIPS:
   • Add all your transactions regularly
   • Use appropriate categories for better insights
   • Review your summary periodically
   • Keep descriptions clear and concise

📁 DATA STORAGE:
   All data is automatically saved to 'finance_data.json'
   in the same directory as this program.
''');
    print('=' * 50);
  }
}

/// Entry point of the application
void main() {
  final app = FinanceApp();
  app.run();
}
