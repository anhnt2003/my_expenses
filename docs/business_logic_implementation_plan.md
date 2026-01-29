# My Expenses - Business Logic Implementation Plan

> **Goal**: Implement domain layer, data layer, state management, and dependency injection to complete the app's business logic, connecting the existing UI to real data persistence.

---

## User Review Required

> [!IMPORTANT]
> This plan introduces **Hive for local storage**, **Riverpod for state management**, and **fpdart for error handling**. New dependencies will be added to `pubspec.yaml`.

> [!WARNING]
> After implementation, the UI will need modifications to consume real providers instead of mock data. This will be done incrementally per feature.

---

## Proposed Changes

### Phase 1: Dependencies Update

#### [MODIFY] [pubspec.yaml](file:///Users/mac/work%20space%20/my_expenses/pubspec.yaml)
Add required dependencies:
- `hive: ^2.2.3` + `hive_flutter: ^1.1.0` - Local NoSQL database
- `get_it: ^7.6.7` - Dependency injection
- `fpdart: ^1.1.0` - Functional programming (Either type)
- `uuid: ^4.3.3` - Unique ID generation
- `riverpod_annotation: ^2.3.5` - Riverpod code generation
- **Dev deps**: `build_runner`, `riverpod_generator`, `hive_generator`

---

### Phase 2: Core Utilities & Error Handling

#### [NEW] [hive_constants.dart](file:///Users/mac/work%20space%20/my_expenses/lib/core/constants/hive_constants.dart)
- Hive box names and type IDs

#### [NEW] [failures.dart](file:///Users/mac/work%20space%20/my_expenses/lib/core/errors/failures.dart)
- `Failure` sealed class with `DatabaseFailure`, `ValidationFailure`

#### [NEW] [exceptions.dart](file:///Users/mac/work%20space%20/my_expenses/lib/core/errors/exceptions.dart)
- `CacheException`, `ValidationException`

#### [NEW] [date_utils.dart](file:///Users/mac/work%20space%20/my_expenses/lib/core/utils/date_utils.dart)
- Date formatting and comparison helpers

#### [NEW] [currency_formatter.dart](file:///Users/mac/work%20space%20/my_expenses/lib/core/utils/currency_formatter.dart)
- Currency formatting utilities

---

### Phase 3: Domain Layer

#### [NEW] [expense.dart](file:///Users/mac/work%20space%20/my_expenses/lib/domain/entities/expense.dart)
- `Expense` entity with id, title, amount, date, categoryId, note

#### [NEW] [category.dart](file:///Users/mac/work%20space%20/my_expenses/lib/domain/entities/category.dart)
- `Category` entity with id, name, icon, color, isDefault

#### [NEW] [expense_repository.dart](file:///Users/mac/work%20space%20/my_expenses/lib/domain/repositories/expense_repository.dart)
- Abstract interface defining CRUD operations returning `Either<Failure, T>`

#### [NEW] [category_repository.dart](file:///Users/mac/work%20space%20/my_expenses/lib/domain/repositories/category_repository.dart)
- Abstract interface for category operations

#### [NEW] Use Cases (lib/domain/usecases/expense/)
- `add_expense.dart`, `get_expenses.dart`, `update_expense.dart`, `delete_expense.dart`
- `get_expenses_by_category.dart`, `get_expenses_by_date_range.dart`

#### [NEW] Use Cases (lib/domain/usecases/category/)
- `add_category.dart`, `get_categories.dart`, `update_category.dart`, `delete_category.dart`

---

### Phase 4: Data Layer

#### [NEW] [expense_model.dart](file:///Users/mac/work%20space%20/my_expenses/lib/data/models/expense_model.dart)
- Hive model with `@HiveType(typeId: 0)` annotations
- `toEntity()` and `fromEntity()` conversion methods

#### [NEW] [category_model.dart](file:///Users/mac/work%20space%20/my_expenses/lib/data/models/category_model.dart)
- Hive model with `@HiveType(typeId: 1)`

#### [NEW] [expense_local_datasource.dart](file:///Users/mac/work%20space%20/my_expenses/lib/data/datasources/local/expense_local_datasource.dart)
- Interface + implementation for Hive expense operations

#### [NEW] [category_local_datasource.dart](file:///Users/mac/work%20space%20/my_expenses/lib/data/datasources/local/category_local_datasource.dart)
- Interface + implementation for Hive category operations

#### [NEW] [expense_repository_impl.dart](file:///Users/mac/work%20space%20/my_expenses/lib/data/repositories/expense_repository_impl.dart)
- Implements `ExpenseRepository`, wraps data source with try/catch → Either

#### [NEW] [category_repository_impl.dart](file:///Users/mac/work%20space%20/my_expenses/lib/data/repositories/category_repository_impl.dart)
- Implements `CategoryRepository`

---

### Phase 5: Riverpod Providers

#### [NEW] [providers.dart](file:///Users/mac/work%20space%20/my_expenses/lib/core/providers/providers.dart)
- Core providers: datasources, repositories, use cases

#### [NEW] Feature Providers:
- `lib/feature/home/providers/home_provider.dart` - Dashboard stats
- `lib/feature/expenses/providers/expenses_provider.dart` - Expense list state
- `lib/feature/expenses/providers/expense_form_provider.dart` - Form state
- `lib/feature/categories/providers/categories_provider.dart` - Category list
- `lib/feature/statistics/providers/statistics_provider.dart` - Chart data

---

### Phase 6: Dependency Injection

#### [NEW] [injection.dart](file:///Users/mac/work%20space%20/my_expenses/lib/injection/injection.dart)
- GetIt setup with Hive box registration
- DataSource and repository registrations

#### [MODIFY] [main.dart](file:///Users/mac/work%20space%20/my_expenses/lib/main.dart)
- Initialize Hive before `runApp`
- Register Hive adapters
- Call `configureDependencies()`
- Seed default categories on first run

---

### Phase 7: Connect UI to Providers

#### [MODIFY] Feature Screens:
- Replace mock data imports with provider watches
- Add loading/error states using `AsyncValue`
- Connect form submissions to repository methods

---

## File Structure Summary

```
lib/
├── main.dart                              [MODIFY]
├── core/
│   ├── constants/
│   │   └── hive_constants.dart           [NEW]
│   ├── errors/
│   │   ├── failures.dart                 [NEW]
│   │   └── exceptions.dart               [NEW]
│   ├── utils/
│   │   ├── date_utils.dart               [NEW]
│   │   └── currency_formatter.dart       [NEW]
│   └── providers/
│       └── providers.dart                [NEW]
├── domain/
│   ├── entities/
│   │   ├── expense.dart                  [NEW]
│   │   └── category.dart                 [NEW]
│   ├── repositories/
│   │   ├── expense_repository.dart       [NEW]
│   │   └── category_repository.dart      [NEW]
│   └── usecases/
│       ├── expense/
│       │   ├── add_expense.dart          [NEW]
│       │   ├── get_expenses.dart         [NEW]
│       │   ├── update_expense.dart       [NEW]
│       │   ├── delete_expense.dart       [NEW]
│       │   └── get_expenses_by_*.dart    [NEW]
│       └── category/
│           ├── add_category.dart         [NEW]
│           ├── get_categories.dart       [NEW]
│           ├── update_category.dart      [NEW]
│           └── delete_category.dart      [NEW]
├── data/
│   ├── models/
│   │   ├── expense_model.dart            [NEW]
│   │   └── category_model.dart           [NEW]
│   ├── datasources/
│   │   └── local/
│   │       ├── expense_local_datasource.dart   [NEW]
│   │       └── category_local_datasource.dart  [NEW]
│   └── repositories/
│       ├── expense_repository_impl.dart  [NEW]
│       └── category_repository_impl.dart [NEW]
├── feature/
│   ├── home/providers/home_provider.dart         [NEW]
│   ├── expenses/providers/expenses_provider.dart [NEW]
│   ├── expenses/providers/expense_form_provider.dart [NEW]
│   ├── categories/providers/categories_provider.dart [NEW]
│   └── statistics/providers/statistics_provider.dart [NEW]
└── injection/
    └── injection.dart                    [NEW]
```

**Total: ~25 new files, 2+ modified files**

---

## Verification Plan

### Build Verification

```bash
# Install new dependencies
cd "/Users/mac/work space /my_expenses"
flutter pub get

# Generate Hive adapters and Riverpod providers
dart run build_runner build --delete-conflicting-outputs

# Verify compilation
flutter analyze
flutter build ios --debug --no-codesign
```

### Manual Testing

1. **App Launch Test**
   - Run `flutter run` and verify app launches without errors
   - Navigate through all tabs (Home, Expenses, Statistics, Settings)

2. **Expense CRUD Test**
   - Add a new expense → verify it appears in the list
   - Edit an expense → verify changes persist
   - Delete an expense → verify removal

3. **Category Management Test**
   - View default categories
   - Add a custom category
   - Assign category to expense

4. **Data Persistence Test**
   - Add expenses, close app, reopen → verify data persists

5. **Statistics Test**
   - Add multiple expenses across categories
   - Verify pie chart reflects correct proportions

---

## Implementation Order

| Order | Phase | Description | Estimated Files |
|-------|-------|-------------|-----------------|
| 1 | Dependencies | Update pubspec.yaml | 1 file |
| 2 | Core Utilities | Error handling, utils | 5 files |
| 3 | Domain Layer | Entities, repos, use cases | 12 files |
| 4 | Data Layer | Hive models, datasources, repo impls | 6 files |
| 5 | Providers | Riverpod providers per feature | 6 files |
| 6 | DI & Main | GetIt setup, main.dart update | 2 files |
| 7 | UI Integration | Connect screens to providers | 5+ files |

---

## Notes

- All entities use immutable classes
- Repository methods return `Either<Failure, T>` for functional error handling
- Providers use `@riverpod` annotation for code generation
- Default 8 categories will be seeded on first app launch
- UI screens will use `ref.watch()` for reactive updates
