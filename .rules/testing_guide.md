# Testing Guidelines

## Test Structure
```
test/
├── unit/
│   ├── domain/usecases/
│   └── data/repositories/
├── widget/
│   └── features/expenses/widgets/
└── integration/
    └── app_test.dart
```

## Unit Tests (Business Logic)
- Test use cases and repositories
- Mock dependencies with `mocktail`
- Test success and failure cases

```dart
// expense_repository_test.dart
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockExpenseDataSource extends Mock implements ExpenseDataSource {}

void main() {
  late ExpenseRepositoryImpl repository;
  late MockExpenseDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockExpenseDataSource();
    repository = ExpenseRepositoryImpl(mockDataSource);
  });

  group('getExpenses', () {
    test('should return list of expenses on success', () async {
      // Arrange
      when(() => mockDataSource.getExpenses())
          .thenAnswer((_) async => [ExpenseModel(...)]);
      
      // Act
      final result = await repository.getExpenses();
      
      // Assert
      expect(result.isRight(), true);
      verify(() => mockDataSource.getExpenses()).called(1);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      when(() => mockDataSource.getExpenses()).thenThrow(Exception());
      
      // Act
      final result = await repository.getExpenses();
      
      // Assert
      expect(result.isLeft(), true);
    });
  });
}
```

## Widget Tests (UI Components)
- Test widget rendering and interactions
- Use `find.byType`, `find.byKey`, `find.text`
- Test different states (loading, error, success)

```dart
// expense_card_test.dart
void main() {
  testWidgets('displays expense amount', (tester) async {
    final expense = Expense(amount: 50.0, category: 'Food');
    
    await tester.pumpWidget(
      MaterialApp(
        home: ExpenseCard(expense: expense),
      ),
    );
    
    expect(find.text('\$50.00'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    var tapped = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: ExpenseCard(
          expense: expense,
          onTap: () => tapped = true,
        ),
      ),
    );
    
    await tester.tap(find.byType(ExpenseCard));
    expect(tapped, true);
  });
}
```

## Integration Tests
- Test complete user flows
- Use `integration_test` package
- Run on real device/emulator

```dart
// integration_test/app_test.dart
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('add expense flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Navigate to add expense
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Fill form
    await tester.enterText(find.byKey(Key('amount_field')), '50');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify expense added
    expect(find.text('\$50.00'), findsOneWidget);
  });
}
```

## BLoC Testing
```dart
blocTest<ExpenseBloc, ExpenseState>(
  'emits [Loading, Loaded] when GetExpenses is added',
  build: () {
    when(() => mockGetExpenses()).thenAnswer(
      (_) async => Right([expense]),
    );
    return ExpenseBloc(getExpenses: mockGetExpenses);
  },
  act: (bloc) => bloc.add(GetExpensesEvent()),
  expect: () => [
    ExpenseLoading(),
    ExpenseLoaded([expense]),
  ],
);
```

## Test Naming Convention
- `should [expected result] when [condition]`
- Group related tests with `group()`

## CI/CD
```yaml
# .github/workflows/test.yml
- name: Run tests
  run: flutter test --coverage
- name: Upload coverage
  uses: codecov/codecov-action@v3
```
