import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';

class EventLogListFilterMenu extends StatelessWidget {
  const EventLogListFilterMenu(
      {super.key,
      required this.sortDirection,
      required this.sortField,
      required this.onSetSortDirection,
      required this.onSetSortField});

  final SortDirection sortDirection;
  final SortField sortField;
  final void Function(SortDirection sortDirection) onSetSortDirection;
  final void Function(SortField sortField) onSetSortField;

  static const _fieldLabels = {
    SortField.timestamp: 'Timestamp',
  };

  Widget _selectionIcon(bool selected) => SizedBox(
        width: 18,
        height: 18,
        child: selected ? const Icon(Icons.check, size: 18) : null,
      );

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, _) => IconButton(
        icon: const Icon(Icons.sort),
        tooltip: 'Sort',
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
      menuChildren: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            'Sort by',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        for (final entry in _fieldLabels.entries)
          MenuItemButton(
            leadingIcon: _selectionIcon(sortField == entry.key),
            onPressed: () => onSetSortField(entry.key),
            child: Text(entry.value),
          ),
        const Divider(height: 1),
        MenuItemButton(
          leadingIcon: _selectionIcon(sortDirection == SortDirection.ascending),
          onPressed: () => onSetSortDirection(SortDirection.ascending),
          child: const Text('Ascending'),
        ),
        MenuItemButton(
          leadingIcon:
              _selectionIcon(sortDirection == SortDirection.descending),
          onPressed: () => onSetSortDirection(SortDirection.descending),
          child: const Text('Descending'),
        ),
      ],
    );
  }
}
