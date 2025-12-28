# 💰 Personal Finance Tracker

A professional command-line application built with Dart to help you manage your personal finances effectively. Track income, expenses, and get detailed insights into your spending habits.

## 📋 Features

- **🔄 Transaction Management**
  - Add income and expense transactions
  - Delete unwanted transactions
  - Automatic data persistence (JSON storage)

- **📊 Financial Insights**
  - Real-time balance calculation
  - Total income and expense tracking
  - Category-wise expense breakdown
  - Comprehensive financial summary

- **🏷️ Categorization**
  - **Income Categories**: Salary, Freelance, Investment, Gift, Other
  - **Expense Categories**: Food & Dining, Transportation, Shopping, Entertainment, Bills & Utilities, Healthcare, Education, Other

- **💾 Data Persistence**
  - Automatic save/load functionality
  - Data stored in `finance_data.json`
  - No data loss between sessions

- **✨ Professional UI**
  - Formatted tables and summaries
  - Color-coded transaction types
  - User-friendly menu system
  - Input validation and error handling

## 🚀 Getting Started

### Prerequisites

- [Dart SDK](https://dart.dev/get-dart) (version 2.12 or higher)

### Installation

1. Clone or download this repository:
   ```bash
   git clone <your-repo-url>
   cd "Personal Finance Tracker"
   ```

2. Verify Dart installation:
   ```bash
   dart --version
   ```

### Running the Application

Run the application using:
```bash
dart run main.dart
```

## 📖 Usage Guide

### Main Menu

Upon launching, you'll see the main menu with 6 options:

```
==================================================
                  MAIN MENU
==================================================
  1. 💵 Add Transaction
  2. 📋 List All Transactions
  3. 📊 View Financial Summary
  4. 🗑️  Delete Transaction
  5. ❓ Help
  6. 🚪 Exit
==================================================
```

### Adding a Transaction

1. Select option `1` from the main menu
2. Choose transaction type:
   - `1` for Income
   - `2` for Expense
3. Select a category from the list
4. Enter a description (e.g., "Grocery shopping", "Monthly salary")
5. Enter the amount (positive number only)

**Example:**
```
Select transaction type:
  1. Income
  2. Expense
Enter choice (1 or 2): 2

Select category:
  1. Food & Dining
  2. Transportation
  3. Shopping
  ...
Enter choice (1-8): 1
Enter description: Lunch at restaurant
Enter amount: $25.50
✓ Transaction added successfully!
```

### Viewing Transactions

Select option `2` to see all your transactions in a formatted table:

```
================================================================================
                             TRANSACTION HISTORY
================================================================================
ID       Date         Type       Category        Description          Amount
--------------------------------------------------------------------------------
abc123   2025-12-28   📈 Income  Salary          Monthly paycheck    +$3000.00
def456   2025-12-28   📉 Expense Food & Dining   Lunch               -$25.50
================================================================================
```

### Financial Summary

Select option `3` to view your financial overview:

```
==================================================
              FINANCIAL SUMMARY
==================================================
         📈 Total Income:      $3000.00
         📉 Total Expenses:    $25.50
--------------------------------------------------
         💰 Current Balance:   $2974.50
==================================================

📊 EXPENSE BREAKDOWN BY CATEGORY:
--------------------------------------------------
  Food & Dining       : $25.50
```

### Deleting a Transaction

1. Select option `4`
2. View the transaction list
3. Enter the transaction ID (first 6 characters)
4. Transaction will be deleted and data automatically saved

## 🗂️ Project Structure

```
Personal Finance Tracker/
│
├── main.dart              # Main application file
├── finance_data.json      # Auto-generated data storage (created on first run)
└── README.md             # This file
```

## 🔧 Technical Details

### Classes

- **`Transaction`**: Model class representing a financial transaction
  - Properties: id, description, amount, type, date, category
  - Methods: JSON serialization/deserialization, formatted output

- **`FinanceTracker`**: Core business logic for managing transactions
  - Methods: addTransaction, deleteTransaction, getBalance, getTotalIncome, getTotalExpenses, listTransactions, showSummary

- **`InputHelper`**: Utility class for user input validation
  - Methods: readString, readDouble, readPositiveDouble, readInt

- **`FinanceApp`**: Main application controller
  - Handles menu navigation and user interactions

### Data Storage

Transactions are stored in `finance_data.json` with the following structure:

```json
[
  {
    "id": "1735401600000",
    "description": "Monthly salary",
    "amount": 3000.0,
    "type": "TransactionType.income",
    "date": "2025-12-28T10:00:00.000Z",
    "category": "Salary"
  }
]
```

## 💡 Best Practices

1. **Regular Updates**: Add transactions as they occur for accurate tracking
2. **Descriptive Entries**: Use clear descriptions for easy identification
3. **Category Consistency**: Use the same categories for similar expenses
4. **Periodic Review**: Check your summary regularly to monitor spending
5. **Backup Data**: Keep a backup of `finance_data.json` for important records

## 🛡️ Error Handling

The application includes robust error handling:
- ✅ Input validation for all user inputs
- ✅ File I/O error handling with warnings
- ✅ Type validation for amounts
- ✅ Empty input protection
- ✅ Invalid choice detection

## 🔮 Future Enhancements

Potential features for future versions:
- Monthly/yearly reports
- Budget setting and alerts
- Export to CSV/Excel
- Graphical charts and visualizations
- Multi-currency support
- Recurring transactions
- Transaction search and filtering

## 📄 License

This project is open source and available for personal and educational use.

## 👨‍💻 Author

Created as a professional finance management tool for learning Dart programming.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page.

---

**Happy Tracking! 💸**
