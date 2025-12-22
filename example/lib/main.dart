import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_scroll_refresh/smart_scroll_refresh.dart';

void main() {
  runApp(const SmartScrollRefreshExampleApp());
}

class SmartScrollRefreshExampleApp extends StatelessWidget {
  const SmartScrollRefreshExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PicsumPaginationPage());
  }
}

class PicsumPaginationPage extends StatefulWidget {
  const PicsumPaginationPage({super.key});

  @override
  State<PicsumPaginationPage> createState() => _PicsumPaginationPageState();
}

class _PicsumPaginationPageState extends State<PicsumPaginationPage> {
  final List<String> _photos = [];
  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _fetchNextPage();
  }

  Future<void> _fetchNextPage() async {
    if (_isFetching || !_hasMore) return;

    _isFetching = true;

    final url = Uri.parse(
      'https://picsum.photos/v2/list?page=$_page&limit=$_limit',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      if (data.isEmpty) {
        _hasMore = false;
      } else {
        setState(() {
          _photos.addAll(data.map<String>((e) => e['download_url'] as String));
          _page++;
        });
      }
    } else {
      debugPrint('Failed to fetch photos: ${response.statusCode}');
    }

    _isFetching = false;
  }

  Future<void> _refreshData() async {
    _page = 1;
    _hasMore = true;
    _photos.clear();
    await _fetchNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart  Pagination')),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: PaginatedListView(
          itemCount: _photos.length,
          hasMore: _hasMore,
          onLoadMore: _fetchNextPage,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _photos[index],
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
