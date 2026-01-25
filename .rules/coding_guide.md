# Coding Guidelines

## Null Safety
- Always use null safety (`?`, `!`, `??`, `?.`)
- Prefer non-nullable types when possible
- Use `late` keyword sparingly and only when initialization is guaranteed

## Error Handling
- Use `Either<Failure, Success>` pattern with dartz/fpdart package
- Create custom Failure classes for different error types
- Never catch generic `Exception` without proper handling

```dart
// Good
Future<Either<Failure, User>> getUser(String id);

// Avoid
Future<User?> getUser(String id); // Null doesn't explain failure reason
```

## Naming Conventions
| Type | Convention | Example |
|------|------------|---------|
| Classes | PascalCase | `UserRepository` |
| Variables/Functions | camelCase | `getUserById` |
| Constants | lowerCamelCase | `defaultTimeout` |
| Files | snake_case | `user_repository.dart` |
| Private | prefix `_` | `_privateMethod` |

## Const Usage (Performance & Best Practices)
- Always use `const` constructors whenever possible
- Prefer `const` widgets for stateless widgets and widgets without runtime-dependent parameters
- Mark constructors as `const` if all fields are `final`
- Use `const` for design system values such as:
  - Colors
  - TextStyles
  - BorderRadius
  - EdgeInsets
- If a widget cannot be `const` due to runtime values, still use `const` for its child widgets whenever possible
- Do NOT force `const` when values depend on runtime logic (method calls, current time, theme context)

## State Management (BLoC)
- Use `flutter_bloc` package
- Separate Events, States, and BLoC logic
- Keep BLoCs focused on single features
- Use `Equatable` for state comparison

```dart
// Event
abstract class AuthEvent extends Equatable {}
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
}

// State
abstract class AuthState extends Equatable {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthFailure extends AuthState {}
```

## Routing (GoRouter)
- Define routes in a central location
- Use named routes for navigation
- Implement proper route guards for authentication

## Dependency Injection (GetIt)
- Register dependencies in a separate file (`injection_container.dart`)
- Use lazy singleton for services
- Register factories for BLoCs

```dart
final sl = GetIt.instance;

void init() {
  // BLoC
  sl.registerFactory(() => AuthBloc(loginUseCase: sl()));
  
  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  
  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
}
```

## Form Validation
- Create reusable validators
- Use `FormBuilder` or native `Form` widget
- Show validation errors clearly

## Testing
- Write unit tests for use cases and repositories
- Write widget tests for UI components
- Use `mocktail` or `mockito` for mocking