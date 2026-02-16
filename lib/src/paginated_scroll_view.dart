import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' hide RefreshIndicator;
import 'pagination_controller.dart';

typedef PaginatedWidgetBuilder =
    Widget Function(BuildContext context, ScrollController controller);

class PaginatedScrollView extends StatefulWidget {
  final PaginatedWidgetBuilder builder;
  final Future<void> Function() onLoadMore;
  final bool hasMore;
  final double loadMoreOffset;
  final PaginationController? controller;
  final Widget? loadingWidget;
  final bool enablePullToRefresh;
  final Future<void> Function()? onRefresh;
  final Widget? refreshIndicatorWidget;
  final bool useRefreshIndicator;

  const PaginatedScrollView({
    super.key,
    required this.builder,
    required this.onLoadMore,
    required this.hasMore,
    this.loadMoreOffset = 200,
    this.controller,
    this.loadingWidget,
    this.enablePullToRefresh = false,
    this.onRefresh,
    this.refreshIndicatorWidget,
    this.useRefreshIndicator = true,
  });

  @override
  State<PaginatedScrollView> createState() => _PaginatedScrollViewState();
}

class _PaginatedScrollViewState extends State<PaginatedScrollView> {
  late final PaginationController _controller;
  late final ScrollController _scrollController;
  late final RefreshController _refreshController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? PaginationController();
    _scrollController = ScrollController()..addListener(_onScroll);
    _refreshController = RefreshController();
  }

  void _onScroll() {


    if (!_scrollController.hasClients) return;
    if (_isLoadingMore) return;
    if (!widget.hasMore) return;

    final position = _scrollController.position;
    final maxScroll = position.maxScrollExtent;
    final currentScroll = position.pixels;

    if (currentScroll >= maxScroll - widget.loadMoreOffset) {
      _tryLoadMore();
    }
  }

  Future<void> _tryLoadMore() async {
    if (_isLoadingMore || !widget.hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    _controller.setLoading();

    try {
      await widget.onLoadMore();
      _controller.setIdle();
    } catch (e) {
      _controller.setError();
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _onRefreshPull() async {
    if (widget.onRefresh != null) {
      await widget.onRefresh!();
    }
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.enablePullToRefresh)
          if (widget.useRefreshIndicator &&
              widget.refreshIndicatorWidget == null)
            RefreshIndicator(
              onRefresh: widget.onRefresh ?? () async {},
              child: widget.builder(context, _scrollController),
            )
          else
            SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefreshPull,
              header: widget.refreshIndicatorWidget != null
                  ? CustomHeader(
                      builder: (context, mode) {
                        return widget.refreshIndicatorWidget!;
                      },
                    )
                  : CustomHeader(
                      builder: (context, mode) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
              child: widget.builder(context, _scrollController),
            )
        else
          widget.builder(context, _scrollController),
        if (_controller.isLoading)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child:
                widget.loadingWidget ??
                const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
