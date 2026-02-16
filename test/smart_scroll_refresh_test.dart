import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' hide RefreshIndicator;
import 'package:smart_scroll_refresh/smart_scroll_refresh.dart';
import 'package:smart_scroll_refresh/src/pagination_state.dart';

void main() {
  group('PaginatedListView Tests', () {
    testWidgets('shows RefreshIndicator when enablePullToRefresh is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatedListView(
              enablePullToRefresh: true,
              itemCount: 10,
              hasMore: false,
              onLoadMore: () async {},
              itemBuilder: (context, index) =>
                  ListTile(title: Text('Item $index')),
            ),
          ),
        ),
      );

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets(
      'does NOT show RefreshIndicator when enablePullToRefresh is false',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PaginatedListView(
                enablePullToRefresh: false,
                itemCount: 10,
                hasMore: false,
                onLoadMore: () async {},
                itemBuilder: (context, index) =>
                    ListTile(title: Text('Item $index')),
              ),
            ),
          ),
        );

        expect(find.byType(RefreshIndicator), findsNothing);
      },
    );

    testWidgets('triggers onLoadMore when scrolling to bottom', (tester) async {
      bool loadMoreCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: PaginatedListView(
                itemCount: 20,
                hasMore: true,
                onLoadMore: () async {
                  loadMoreCalled = true;
                },
                itemBuilder: (context, index) =>
                    SizedBox(height: 50, child: Text('Item $index')),
              ),
            ),
          ),
        ),
      );

      // Verify list is rendered
      expect(find.text('Item 0'), findsOneWidget);

      // Scroll to bottom
      final scrollFinder = find.byType(Scrollable);
      await tester.drag(scrollFinder, const Offset(0, -1000));
      await tester.pump();

      expect(loadMoreCalled, isTrue);
    });

    testWidgets('does NOT trigger onLoadMore when hasMore is false', (
      tester,
    ) async {
      bool loadMoreCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: PaginatedListView(
                itemCount: 20,
                hasMore: false,
                onLoadMore: () async {
                  loadMoreCalled = true;
                },
                itemBuilder: (context, index) =>
                    SizedBox(height: 50, child: Text('Item $index')),
              ),
            ),
          ),
        ),
      );

      final scrollFinder = find.byType(Scrollable);
      await tester.drag(scrollFinder, const Offset(0, -1000));
      await tester.pump();

      expect(loadMoreCalled, isFalse);
    });
  });

  group('PaginatedGridView Tests', () {
    testWidgets(
      'shows RefreshIndicator when enablePullToRefresh is true and useRefreshIndicator is true',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 400,
                child: PaginatedGridView(
                  enablePullToRefresh: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: 20,
                  hasMore: false,
                  onLoadMore: () async {},
                  itemBuilder: (context, index) => Text('Item $index'),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(RefreshIndicator), findsOneWidget);
      },
    );

    testWidgets('shows SmartRefresher when useRefreshIndicator is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: PaginatedGridView(
                enablePullToRefresh: true,
                useRefreshIndicator: false,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: 20,
                hasMore: false,
                onLoadMore: () async {},
                itemBuilder: (context, index) => Text('Item $index'),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(SmartRefresher), findsOneWidget);
    });
  });

  group('PaginationController Tests', () {
    test('updates status correctly', () {
      final controller = PaginationController();
      expect(controller.status, PaginationStatus.idle);

      controller.setLoading();
      expect(controller.isLoading, isTrue);

      controller.setCompleted();
      expect(controller.hasCompleted, isTrue);

      controller.setError();
      expect(controller.status, PaginationStatus.error);

      controller.setIdle();
      expect(controller.status, PaginationStatus.idle);
    });
  });
}
