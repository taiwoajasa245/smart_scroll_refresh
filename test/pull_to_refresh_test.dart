import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_scroll_refresh/smart_scroll_refresh.dart';

void main() {
  testWidgets(
    'PaginatedListView shows RefreshIndicator when enablePullToRefresh is true',
    (tester) async {
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
    },
  );

  testWidgets(
    'PaginatedListView does NOT show RefreshIndicator when enablePullToRefresh is false',
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
}
