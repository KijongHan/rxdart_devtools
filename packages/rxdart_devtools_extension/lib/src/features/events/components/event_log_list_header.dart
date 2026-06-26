import 'package:flutter/material.dart';

class EventLogListHeader extends StatefulWidget {
  const EventLogListHeader({super.key});

  @override
  State<EventLogListHeader> createState() => _EventLogListHeaderState();
}

class _EventLogListHeaderState extends State<EventLogListHeader> {
  final _searchController = TextEditingController();
  bool _ascending = false;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                onChanged: (value) => setState(() => _query = value),
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
        IconButton(
          tooltip: _ascending ? 'Sort newest first' : 'Sort oldest first',
          icon: Icon(
            _ascending ? Icons.arrow_upward : Icons.arrow_downward,
          ),
          onPressed: () => setState(() => _ascending = !_ascending),
        ),
      ],
    );
  }
}
