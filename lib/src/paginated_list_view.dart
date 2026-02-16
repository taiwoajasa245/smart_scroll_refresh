import 'package:flutter/material.dart';
import 'paginated_scroll_view.dart';
import 'pagination_controller.dart';

class PaginatedListView extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final Future<void> Function() onLoadMore;
  final bool hasMore;
  final PaginationController? controller;
  final EdgeInsetsGeometry? padding;
  final bool enablePullToRefresh;
  final Future<void> Function()? onRefresh;
  final Widget? refreshIndicatorWidget;
  final bool useRefreshIndicator;

  const PaginatedListView({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.onLoadMore,
    required this.hasMore,
    this.controller,
    this.padding,
    this.enablePullToRefresh = false,
    this.onRefresh,
    this.refreshIndicatorWidget,
    this.useRefreshIndicator = true,
  }) : assert(itemCount >= 0, 'itemCount cannot be negative');

  @override
  Widget build(BuildContext context) {
    return PaginatedScrollView(
      onLoadMore: onLoadMore,
      hasMore: hasMore,
      controller: controller,
      enablePullToRefresh: enablePullToRefresh,
      onRefresh: onRefresh,
      refreshIndicatorWidget: refreshIndicatorWidget,
      useRefreshIndicator: useRefreshIndicator,
      builder: (context, controller) {
        return ListView.builder(
          controller: controller,
          padding: padding,
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}
