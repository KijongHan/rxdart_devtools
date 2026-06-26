import 'package:flutter/material.dart';

class StreamSearch extends StatefulWidget {
  const StreamSearch({super.key, required this.onSearch});

  final void Function(String query) onSearch;

  @override
  State<StreamSearch> createState() => _StreamSearchState();
}

class _StreamSearchState extends State<StreamSearch> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final query = _searchController.text;
    widget.onSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        isDense: true,
        prefixIcon: const Icon(Icons.search, size: 18),
        hintText: 'Search streams',
        border: const OutlineInputBorder(),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () {
                  _searchController.clear();
                  _onSearch();
                },
              ),
      ),
    );
  }
}
