# Performance Guidelines

## Image Optimization
- Use `cached_network_image` for network images
- Compress images before bundling
- Use appropriate image formats (WebP for better compression)
- Specify image dimensions when possible

```dart
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
  width: 100,
  height: 100,
  fit: BoxFit.cover,
);
```

## ListView Optimization
- Use `ListView.builder` for long lists (lazy loading)
- Set `itemExtent` when items have fixed height
- Use `const` constructors in list items
- Implement pagination for large datasets

```dart
// Good - Lazy loading
ListView.builder(
  itemCount: items.length,
  itemExtent: 72, // Fixed height improves performance
  itemBuilder: (context, index) => ItemTile(item: items[index]),
);

// Avoid - All items built at once
ListView(
  children: items.map((item) => ItemTile(item: item)).toList(),
);
```

## Build Method Optimization
- Avoid heavy computation in `build()`
- Cache expensive operations
- Use `const` widgets wherever possible
- Split large widgets into smaller ones

```dart
// Good - Computed outside build
class _MyState extends State<MyWidget> {
  late final List<Widget> _expensiveWidgets;
  
  @override
  void initState() {
    super.initState();
    _expensiveWidgets = _computeWidgets(); // Computed once
  }
}
```

## State Management Optimization
- Use `BlocSelector` to rebuild only what's needed
- Use `Equatable` for proper state comparison
- Avoid storing UI state in global state

```dart
// Good - Only rebuilds when count changes
BlocSelector<CounterBloc, CounterState, int>(
  selector: (state) => state.count,
  builder: (context, count) => Text('$count'),
);
```

## Memory Management
- Dispose controllers, streams, subscriptions
- Use `AutomaticKeepAliveClientMixin` sparingly
- Avoid storing large objects in state
- Use weak references for callbacks when appropriate

## Platform Channels
- Use for native functionality only
- Keep data transfer minimal
- Handle errors on both sides
- Consider using packages first (camera, location, etc.)

## Compilation Optimization
- Use `--release` for production builds
- Enable tree shaking
- Use `--split-debug-info` to reduce app size
- Profile with DevTools before optimizing

```bash
flutter build apk --release --split-debug-info=./debug-info
```
