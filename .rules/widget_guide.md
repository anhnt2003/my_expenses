# Widget Guidelines

## Keep Widgets Small & Focused
- Each widget should do ONE thing well
- Extract reusable widgets into separate files
- Prefer composition over inheritance

```dart
// Good - Small, focused widget
class ExpenseCard extends StatelessWidget {
  const ExpenseCard({super.key, required this.expense});
  final Expense expense;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpenseCardContent(expense: expense),
    );
  }
}

// Avoid - Large monolithic widget
class ExpenseScreen extends StatelessWidget {
  // 500+ lines of code...
}
```

## Const Constructors
- Always use `const` constructors when possible
- Reduces widget rebuilds and improves performance

```dart
// Good
const SizedBox(height: 16);
const EdgeInsets.all(8);
const Text('Hello');

// Avoid
SizedBox(height: 16); // Missing const
```

## Widget Keys
- Use keys for widgets in lists
- Use `ValueKey` for unique identifiers
- Use `GlobalKey` sparingly (for form state, etc.)

```dart
ListView.builder(
  itemBuilder: (context, index) => ExpenseItem(
    key: ValueKey(expenses[index].id), // Important!
    expense: expenses[index],
  ),
);
```

## Layout Principles
- Use `Flexible`/`Expanded` in Row/Column appropriately
- Avoid deep nesting (max 3-4 levels)
- Use `LayoutBuilder` for responsive layouts
- Prefer `SliverList` for long scrollable content

## Widget Lifecycle
- Use `initState` for initialization (subscriptions, controllers)
- Use `dispose` to clean up resources
- Use `didUpdateWidget` to react to widget changes
- Use `didChangeDependencies` for InheritedWidget changes

```dart
class _MyWidgetState extends State<MyWidget> {
  late TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  
  @override
  void dispose() {
    _controller.dispose(); // Always clean up!
    super.dispose();
  }
}
```

## Error Boundaries
- Use `ErrorWidget.builder` for custom error displays
- Handle async errors with proper UI feedback

## Accessibility
- Add `Semantics` widgets for screen readers
- Use meaningful labels for buttons/icons
- Ensure sufficient color contrast
- Support dynamic text scaling