# Async Provider Pattern - Required Rules

## Core Principles

1. **Always use AsyncValue for future operations**
   - Every async operation must utilize the AsyncValue class to represent its state
   - Never expose raw Futures in your provider's public API

2. **State Management Responsibility**
   - Providers are responsible for managing loading, success, and error states
   - UI should never directly manage async operation states

3. **Notification Protocol**
   - Call `notifyListeners()` both before starting async operations and after completion
   - Always notify listeners regardless of success or failure outcome

4. **Repository Delegation**
   - Providers must delegate data fetching to repository classes
   - Direct API calls from providers are prohibited

## Implementation Requirements

### AsyncValue Class
```dart
class AsyncValue<T> {
  final T? data;
  final Object? error;
  final AsyncValueState state;

  AsyncValue.loading() : data = null, error = null, state = AsyncValueState.loading;
  AsyncValue.success(this.data) : error = null, state = AsyncValueState.success;
  AsyncValue.error(this.error) : data = null, state = AsyncValueState.error;
}

enum AsyncValueState {
  loading,
  error,
  success
}
```

### Provider Structure
Every provider that handles async operations MUST:
1. Maintain an AsyncValue property to track operation state
2. Set loading state before async operation begins
3. Set appropriate success/error state after completion
4. Notify listeners at both the beginning and end of operations

```dart
// REQUIRED PROVIDER PATTERN
class ExampleProvider extends ChangeNotifier {
  AsyncValue<DataType>? dataValue;

  Future<void> fetchData(int id) async {
    // REQUIRED: Set loading state and notify
    dataValue = AsyncValue.loading();
    notifyListeners();

    try {
      // REQUIRED: Use repository for data fetching
      DataType data = await _repository.getData(id);
      
      // REQUIRED: Set success state
      dataValue = AsyncValue.success(data);
    } catch (error) {
      // REQUIRED: Set error state
      dataValue = AsyncValue.error(error);
    }
    
    // REQUIRED: Notify after completion
    notifyListeners();
  }
}
```

### UI Implementation Rules
Every widget consuming async providers MUST:
1. Check for null AsyncValue (initial state)
2. Handle all three possible states (loading, success, error)
3. Use appropriate loading indicators for the loading state
4. Display error messages for the error state
5. Render data only when in the success state

```dart
// REQUIRED UI PATTERN
Widget build(BuildContext context) {
  final provider = Provider.of<ExampleProvider>(context);
  final asyncValue = provider.dataValue;

  // REQUIRED: Handle initial null state
  if (asyncValue == null) {
    return Text('No data requested yet');
  }

  // REQUIRED: Handle all three states
  switch (asyncValue.state) {
    case AsyncValueState.loading:
      return CircularProgressIndicator();
    case AsyncValueState.success:
      return DataCard(data: asyncValue.data!);
    case AsyncValueState.error:
      return Text('Error: ${asyncValue.error}');
  }
}
```

## Project Structure Requirements
Follow this structure for all async provider implementations:

```
DATA
 ├── DTO
 │    └── [entity]_dto.dart
 ├── REPOSITORY
 │    ├── [entity]_repository.dart (interface)
 │    └── http_[entity]_repository.dart (implementation)
MODEL
 └── [entity].dart
UI
 ├── PROVIDER
 │    └── [entity]_provider.dart
 └── SCREEN
      └── [entity]_screen.dart
```

## Violation Consequences
Failure to follow these rules will result in:
- Code review rejection
- Required refactoring before merge approval
- Potential technical debt documentation 