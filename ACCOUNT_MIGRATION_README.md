# Account Feature Migration Documentation

## Overview
This document describes the migration of the account feature to use the Palm HR design system and coding conventions.

## New Models Created

### 1. AccountBalance (`/model/payroll/account/account_balance.dart`)
- Represents master account information
- Fields: `accountName`, `accountNo`, `currentBalance`, `status`
- Includes validation methods and type conversions
- Follows immutable pattern with `copyWith()`, `==`, `hashCode`, and `toString()`

### 2. AccountStatement (`/model/payroll/account/account_statement.dart`)
- Represents individual transaction records
- Fields: `id`, `amount`, `balance`, `date`, `note`, `transaction`
- Includes helper methods for date formatting and amount calculations
- Supports date grouping for UI display

### 3. StatementDetail (`/model/payroll/account/statement_detail.dart`)
- Represents detailed popup information for transactions
- Fields: `originalAmount`, `toMemberId`, `remark`, `amount`
- Used for PDF generation and detailed transaction views

## New Service Layer

### AccountService (`/services/account_service.dart`)
- Centralized data access for account-related operations
- Currently provides static test data
- Methods:
  - `getAccountBalance()` - Fetches account master data
  - `getAccountStatements()` - Fetches transaction list
  - `getGroupedStatements()` - Groups transactions by date
  - `getStatementDetail(id)` - Fetches popup details
  - `isAccountValid()` - Validates account status

## New Screen Components

### 1. PalmAccountScreen (`/screens/payroll/account/palm_account_screen.dart`)
Main screen following Palm HR conventions:
- Uses Palm color scheme and typography
- Implements proper loading states
- Handles error scenarios gracefully
- Follows three-part comment structure

### 2. Screen Widgets (`/screens/payroll/account/widgets/`)

#### AccountHeaderCard
- Displays account name, number, and balance
- Uses primary color theme with card styling
- Responsive design with proper spacing

#### AccountStatementTile
- Individual transaction display
- Color-coded for credit/debit transactions
- Includes formatted amounts and icons

#### AccountDateHeader
- Date grouping header for transactions
- Formatted date display
- Consistent styling with background accent

#### AccountStatementDetailDialog
- Modal dialog for transaction details
- Table layout for information display
- Download PDF functionality

## Design System Integration

### Colors Used
- `PalmColors.primary` - Main brand color
- `PalmColors.success/danger` - Transaction type indicators
- `PalmColors.white` - Card backgrounds
- `PalmColors.textNormal/textLight` - Text hierarchy
- `PalmColors.backgroundAccent` - Section headers

### Typography
- `PalmTextStyles.heading` - Main titles
- `PalmTextStyles.subheading` - Section headers
- `PalmTextStyles.body` - Regular content
- `PalmTextStyles.label` - Secondary information

### Spacing
- `PalmSpacings.m` - Standard padding (16px)
- `PalmSpacings.l` - Large spacing (24px)
- `PalmSpacings.s` - Small spacing (12px)
- `PalmSpacings.radius` - Border radius (16px)

## Migration Benefits

1. **Consistency**: Follows established design system
2. **Maintainability**: Organized code structure with proper separation
3. **Reusability**: Modular components and services
4. **Type Safety**: Proper models with validation
5. **User Experience**: Loading states, error handling, responsive design

## Usage Example

```dart
import 'package:flutter/material.dart';
import '../screens/payroll/account/palm_account_screen.dart';

// Navigate to account screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const PalmAccountScreen(),
  ),
);
```

## API Integration Notes

The current implementation uses static test data in `AccountService`. To integrate with real APIs:

1. Replace static methods in `AccountService` with HTTP calls
2. Add proper error handling for network requests
3. Implement loading states during API calls
4. Add authentication token handling

## Files Structure

```
lib/
├── model/payroll/account/
│   ├── account_balance.dart
│   ├── account_statement.dart
│   └── statement_detail.dart
├── services/
│   └── account_service.dart
├── screens/payroll/account/
│   ├── palm_account_screen.dart
│   └── widgets/
│       ├── account_header_card.dart
│       ├── account_statement_tile.dart
│       ├── account_date_header.dart
│       └── account_statement_detail_dialog.dart
└── examples/
    └── account_screen_example.dart
```

## Testing Recommendations

1. Unit tests for model classes (validation, type conversion)
2. Unit tests for service layer methods
3. Widget tests for individual components
4. Integration tests for complete user flows
5. Test error scenarios and loading states
