# Smart Scroll Refresh

A lightweight, flexible Flutter pagination package that automatically loads more data when the user scrolls near the end of a scrollable with built-in pull-to-refresh support.

Unlike many pagination packages, **Smart Scroll Refresh works with any scrollable** — `ListView.builder`, `GridView.builder`, `CustomScrollView`, or even custom layouts using `.map()` or `for` loops.

---

## Features

- Automatic infinite scroll detection
- Built-in pull-to-refresh
- Works with **any scrollable widget**
- Supports ListView, GridView, Column, `.map()`, `for` loops
- Builder-based API (no brittle widget copying)
- Optional custom loading indicator
- Custom refresh indicator support
- Works with any state management (setState, Bloc, Riverpod, Provider, GetX)

---

## Quick Start (ListView.builder)

```dart
PaginatedScrollView(
  hasMore: hasMore,
  onLoadMore: fetchNextPage,
  builder: (context, controller) {
    return ListView.builder(
      controller: controller, 
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index]),
        );
      },
    );
  },
)
```

> **Note:** The `ScrollController` is provided via the builder callback. **Do not create your own controller**; just assign the one passed to your scrollable.

---

## Pull To Refresh

Enable pull-to-refresh easily:

```dart
PaginatedScrollView(
  hasMore: hasMore,
  enablePullToRefresh: true,
  onRefresh: fetchFirstPage,
  onLoadMore: fetchNextPage,
  builder: (context, controller) {
    return ListView(
      controller: controller,
      children: items.map((item) {
        return ListTile(title: Text(item));
      }).toList(),
    );
  },
)
```


---

## Custom Refresh Indicator

Fully Customizable Refresh Indicator

```dart
PaginatedScrollView(
  enablePullToRefresh: true,
  onRefresh: fetchFirstPage,
  refreshIndicatorWidget: Padding(
    padding: EdgeInsets.all(16),
    child: CircularProgressIndicator()
    ),
  hasMore: hasMore,
  onLoadMore: fetchNextPage,
  builder: (context, controller) {
    return ListView(
      controller: controller,
      children: items.map((item) {
        return ListTile(title: Text(item));
      }).toList(),
    );
  },
)
```

---

## Using Any Layout

`PaginatedScrollView` works with any scrollable. Just assign the **provided controller**.

### Using `.map()`

```dart
PaginatedScrollView(
  hasMore: hasMore,
  onLoadMore: fetchNextPage,
  builder: (context, controller) {
    return ListView(
      controller: controller,
      children: items.map((item) {
        return ListTile(title: Text(item));
      }).toList(),
    );
  },
)
```

---

### Using `for` loops

```dart
PaginatedScrollView(
  hasMore: hasMore,
  onLoadMore: fetchNextPage,
  builder: (context, controller) {
    return SingleChildScrollView(
      controller: controller,
      child: Column(
        children: [
          for (final item in items)
            ListTile(title: Text(item)),
        ],
      ),
    );
  },
)
```

---

### Using `List.generate`

```dart
PaginatedScrollView(
  hasMore: hasMore,
  onLoadMore: fetchNextPage,
  builder: (context, controller) {
    return ListView(
      controller: controller,
      children: List.generate(
        items.length,
        (index) => ListTile(title: Text(items[index])),
      ),
    );
  },
)
```

---

## ListView Pagination

```dart
PaginatedListView(
  itemCount: items.length,
  hasMore: hasMore,
  onLoadMore: fetchNextPage,
  itemBuilder: (context, index) {
    return Card(
      child: Center(child: Text(items[index])),
    );
  },
)
```

> `PaginatedGridView` works similarly to `PaginatedScrollView` but with a grid layout.

---

---

## Grid Pagination

```dart
PaginatedGridView(
  itemCount: items.length,
  hasMore: hasMore,
  onLoadMore: fetchNextPage,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
  ),
  itemBuilder: (context, index) {
    return Card(
      child: Center(child: Text(items[index])),
    );
  },
)
```

> `PaginatedGridView` works similarly to `PaginatedScrollView` but with a grid layout.

---

## PaginationController

You can optionally control loading state manually:

```dart
final controller = PaginationController();
```

```dart
PaginatedScrollView(
  controller: controller,
  hasMore: hasMore,
  onLoadMore: fetchNextPage,
  builder: (context, controller) {
    return ListView.builder(
      controller: controller,
      itemCount: items.length,
      itemBuilder: ...
    );
  },
)
```

---

## Custom Loading Indicator

```dart
PaginatedScrollView(
  hasMore: hasMore,
  onLoadMore: fetchNextPage,
  loadingWidget: Padding(
    padding: EdgeInsets.all(16),
    child: Center(child: Text('Loading more...')),
  ),
  builder: (context, controller) {
    return ListView.builder(
      controller: controller,
      itemCount: items.length,
      itemBuilder: ...
    );
  },
)
```

---

## Works With Any State Management

- `setState()`
- Bloc / Cubit
- Riverpod
- Provider
- GetX

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Support

If you find this package helpful, please give it a ⭐ on [GitHub](https://github.com/taiwoajasa245/smart_scroll_refresh)!

For issues and feature requests, please file them on the [issue tracker](https://github.com/taiwoajasa245/smart_scroll_refresh/issues).
