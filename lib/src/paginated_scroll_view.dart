import 'package:flutter/material.dart';
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

  const PaginatedScrollView({
    super.key,
    required this.builder,
    required this.onLoadMore,
    required this.hasMore,
    this.loadMoreOffset = 200,
    this.controller,
    this.loadingWidget,
  });

  @override
  State<PaginatedScrollView> createState() => _PaginatedScrollViewState();
}

class _PaginatedScrollViewState extends State<PaginatedScrollView> {
  late final PaginationController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? PaginationController();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - widget.loadMoreOffset) {
      _tryLoadMore();
    }
  }

  Future<void> _tryLoadMore() async {
    if (_controller.isLoading || !widget.hasMore) return;

    _controller.setLoading();
    try {
      await widget.onLoadMore();
      _controller.setIdle();
    } catch (_) {
      _controller.setError();
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
