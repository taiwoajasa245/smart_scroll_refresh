## 1.1.0

###  Added
- Pull-to-refresh support
- `enablePullToRefresh` parameter
- `useRefreshIndicator` parameter for default indicator
- `onRefresh` callback for manual data refresh
- Customizable `refreshIndicatorWidget`
- Unit and widget tests for pagination and refresh logic


### Improved
- Better state synchronization between refresh and pagination
- Improved protection against duplicate fetch calls

### Internal
- Minor performance optimizations
- Code cleanup and refactoring



## 1.0.0

Initial release

### Features
- Automatic infinite scroll pagination
- `PaginatedListView` for ListView.builder
- `PaginatedGridView` for grid layouts
- `PaginatedScrollView` for custom layouts
- Supports `.map()`, `for` loops, and `List.generate`
- Built-in loading indicator
- Safe against multiple concurrent fetches
- Optional `PaginationController`
- State-management agnostic

### Notes
- ScrollController is managed internally
- Compatible with any backend pagination strategy
