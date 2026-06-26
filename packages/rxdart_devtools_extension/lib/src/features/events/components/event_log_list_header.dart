import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';

class EventLogListHeader extends StatefulWidget {
  const EventLogListHeader({
    super.key,
    required this.onSort,
    required this.onSearch,
  });

  final void Function(SortField sortField, SortDirection sortDirection) onSort;
  final void Function(String query) onSearch;

  @override
  State<EventLogListHeader> createState() => _EventLogListHeaderState();
}

class _EventLogListHeaderState extends State<EventLogListHeader> {
  final _searchController = TextEditingController();
  SortDirection _sortDirection = SortDirection.descending;
  SortField _sortField = SortField.timestamp;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.text = _query;
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearch);
    _searchController.dispose();
    super.dispose();
  }

  static const _fieldLabels = {
    SortField.timestamp: 'Timestamp',
    SortField.streamId: 'Stream',
    SortField.lastUpdated: 'Last updated',
  };

  void _onFieldChanged(SortField? field) {
    if (field == null || field == _sortField) return;
    setState(() => _sortField = field);
    widget.onSort(_sortField, _sortDirection);
  }

  void _toggleDirection() {
    setState(() {
      _sortDirection = _sortDirection == SortDirection.ascending
          ? SortDirection.descending
          : SortDirection.ascending;
    });
    widget.onSort(_sortField, _sortDirection);
  }

  void _onSearch() {
    final query = _searchController.text;
    widget.onSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: const Icon(Icons.search, size: 18),
                  hintText: 'Search events',
                  border: const OutlineInputBorder(),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<SortField>(
          value: _sortField,
          isDense: true,
          underline: const SizedBox.shrink(),
          items: [
            for (final entry in _fieldLabels.entries)
              DropdownMenuItem(value: entry.key, child: Text(entry.value)),
          ],
          onChanged: _onFieldChanged,
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: _sortDirection == SortDirection.ascending
              ? 'Sort newest first'
              : 'Sort oldest first',
          icon: Icon(
            _sortDirection == SortDirection.ascending
                ? Icons.arrow_upward
                : Icons.arrow_downward,
          ),
          onPressed: _toggleDirection,
        ),
      ],
    );
  }
}
