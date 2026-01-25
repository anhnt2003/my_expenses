# Flutter Best Practices

## Core Principles
- ✅ Use Flutter 3.x features and Material 3 design
- ✅ Implement clean architecture with BLoC pattern
- ✅ Follow proper state management principles
- ✅ Use proper dependency injection (GetIt)
- ✅ Implement proper error handling (Either type)
- ✅ Follow platform-specific design guidelines
- ✅ Use proper localization techniques

## Material 3
```dart
MaterialApp(
  theme: ThemeData(
    useMaterial3: true, // Enable Material 3
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
  ),
);
```

## Localization (l10n)
1. Add to `pubspec.yaml`:
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any

flutter:
  generate: true
```

2. Create `l10n.yaml`:
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

3. Create `lib/l10n/app_en.arb`:
```json
{
  "appTitle": "My Expenses",
  "addExpense": "Add Expense",
  "@addExpense": {
    "description": "Button to add new expense"
  }
}
```

4. Use in code:
```dart
Text(AppLocalizations.of(context)!.addExpense)
```

## Platform-Specific Guidelines

### iOS
- Use Cupertino widgets for iOS-specific UI
- Follow Apple HIG for navigation patterns
- Handle safe areas properly

### Android
- Use Material widgets
- Follow Material Design guidelines
- Handle back button properly

```dart
// Adaptive widget example
Widget build(BuildContext context) {
  return Platform.isIOS
      ? CupertinoButton(child: Text('Tap'), onPressed: onTap)
      : ElevatedButton(child: Text('Tap'), onPressed: onTap);
}
```

## Quick Reference

| Topic | Package | Guide |
|-------|---------|-------|
| State | flutter_bloc | [coding_guide.md](./coding_guide.md) |
| DI | get_it | [coding_guide.md](./coding_guide.md) |
| Routing | go_router | [coding_guide.md](./coding_guide.md) |
| Errors | dartz/fpdart | [coding_guide.md](./coding_guide.md) |
| Architecture | - | [architecture_guide.md](./architecture_guide.md) |
| Widgets | - | [widget_guide.md](./widget_guide.md) |
| Performance | - | [performance_guide.md](./performance_guide.md) |
| Testing | mocktail | [testing_guide.md](./testing_guide.md) |

## Recommended Packages
```yaml
dependencies:
  # State Management
  flutter_bloc: ^8.1.0
  equatable: ^2.0.0
  
  # DI
  get_it: ^7.6.0
  injectable: ^2.3.0
  
  # Routing
  go_router: ^13.0.0
  
  # Error Handling
  dartz: ^0.10.1
  # or fpdart: ^1.1.0
  
  # Network
  dio: ^5.4.0
  
  # Local Storage
  hive: ^2.2.3
  # or sqflite: ^2.3.0
  
  # Utilities
  intl: ^0.18.0
  cached_network_image: ^3.3.0

dev_dependencies:
  # Testing
  mocktail: ^1.0.0
  bloc_test: ^9.1.0
  
  # Code Generation
  build_runner: ^2.4.0
  injectable_generator: ^2.4.0
```
