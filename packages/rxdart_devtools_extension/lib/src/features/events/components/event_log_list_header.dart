import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/events/components/event_log_list_filter_menu.dart';

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

  void _setField(SortField field) {
    if (field == _sortField) return;
    setState(() => _sortField = field);
    widget.onSort(_sortField, _sortDirection);
  }

  void _setDirection(SortDirection direction) {
    if (direction == _sortDirection) return;
    setState(() => _sortDirection = direction);
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
        EventLogListFilterMenu(
          sortDirection: _sortDirection,
          sortField: _sortField,
          onSetSortDirection: _setDirection,
          onSetSortField: _setField,
        ),
      ],
    );
  }
}
