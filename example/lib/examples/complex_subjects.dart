import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/sdk.dart';

class ComplexSubjectsExample extends StatefulWidget {
  const ComplexSubjectsExample({super.key});

  @override
  State<ComplexSubjectsExample> createState() => _ComplexSubjectsExampleState();
}

class _ComplexSubjectsExampleState extends State<ComplexSubjectsExample> {
  late final BehaviorSubject<Map<String, dynamic>> _map;
  late final BehaviorSubject<List<int>> _list;
  late final BehaviorSubject<UserWithJson> _userWithJson;
  late final BehaviorSubject<UserWithoutJson> _userWithoutJson;
  late final BehaviorSubject<Order> _order;

  int _listNext = 4;
  int _mapTick = 1;
  int _orderTick = 1;

  @override
  void initState() {
    super.initState();
    _map = BehaviorSubject<Map<String, dynamic>>.seeded(<String, dynamic>{
      'count': 1,
      'items': <String>['a', 'b'],
    }).track('complex.map').asSubject();

    _list = BehaviorSubject<List<int>>.seeded(<int>[1, 2, 3])
        .track('complex.list')
        .asSubject();

    _userWithJson = BehaviorSubject<UserWithJson>.seeded(
      const UserWithJson(name: 'alice', age: 30),
    ).track('complex.user_with_json').asSubject();

    _userWithoutJson = BehaviorSubject<UserWithoutJson>.seeded(
      const UserWithoutJson(name: 'bob', age: 25),
    ).track('complex.user_without_json').asSubject();

    _order = BehaviorSubject<Order>.seeded(
      const Order(
        id: 'order-1',
        customer: UserWithJson(name: 'alice', age: 30),
        items: <String>['apple', 'pear'],
      ),
    ).track('complex.order').asSubject();
  }

  @override
  void dispose() {
    _map.close();
    _list.close();
    _userWithJson.close();
    _userWithoutJson.close();
    _order.close();
    super.dispose();
  }

  void _emitMap() {
    _mapTick++;
    _map.add(<String, dynamic>{
      'count': _mapTick,
      'items': <String>['a', 'b', 'item-$_mapTick'],
    });
  }

  void _emitList() {
    final next = List<int>.from(_list.value)..add(_listNext++);
    _list.add(next);
  }

  void _emitUserWithJson() {
    final current = _userWithJson.value;
    _userWithJson.add(UserWithJson(name: current.name, age: current.age + 1));
  }

  void _emitUserWithoutJson() {
    final current = _userWithoutJson.value;
    _userWithoutJson.add(
      UserWithoutJson(name: current.name, age: current.age + 1),
    );
  }

  void _emitOrder() {
    _orderTick++;
    final current = _order.value;
    final nextItems = List<String>.from(current.items)..add('item-$_orderTick');
    _order.add(
      Order(
        id: current.id,
        customer: UserWithJson(
          name: current.customer.name,
          age: current.customer.age + 1,
        ),
        items: nextItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Card<Map<String, dynamic>>(
          title: 'BehaviorSubject<Map<String, dynamic>>',
          panelExpectation: 'Structured JSON tree (Map and nested List).',
          stream: _map,
          initialData: _map.value,
          format: (v) => v.toString(),
          actionLabel: 'emit next map',
          onAction: _emitMap,
        ),
        const SizedBox(height: 16),
        _Card<List<int>>(
          title: 'BehaviorSubject<List<int>>',
          panelExpectation: 'Structured JSON array.',
          stream: _list,
          initialData: _list.value,
          format: (v) => v.toString(),
          actionLabel: 'append item',
          onAction: _emitList,
        ),
        const SizedBox(height: 16),
        _Card<UserWithJson>(
          title: 'BehaviorSubject<UserWithJson>',
          panelExpectation:
              'Has toJson() → structured JSON tree '
              "(e.g. { name: 'alice', age: 30 }).",
          stream: _userWithJson,
          initialData: _userWithJson.value,
          format: (v) => v.toString(),
          actionLabel: 'increment age',
          onAction: _emitUserWithJson,
        ),
        const SizedBox(height: 16),
        _Card<UserWithoutJson>(
          title: 'BehaviorSubject<UserWithoutJson>',
          panelExpectation:
              'No toJson() → falls back to toString(); panel shows the '
              'raw string, not a JSON tree.',
          stream: _userWithoutJson,
          initialData: _userWithoutJson.value,
          format: (v) => v.toString(),
          actionLabel: 'increment age',
          onAction: _emitUserWithoutJson,
        ),
        const SizedBox(height: 16),
        _Card<Order>(
          title: 'BehaviorSubject<Order> (nested object)',
          panelExpectation:
              'Order.toJson() returns the nested UserWithJson directly; '
              'jsonEncode recurses through it, producing a structured tree '
              'with the customer expanded inline.',
          stream: _order,
          initialData: _order.value,
          format: (v) => v.toString(),
          actionLabel: 'append item & age customer',
          onAction: _emitOrder,
        ),
      ],
    );
  }
}

class UserWithJson {
  const UserWithJson({required this.name, required this.age});

  final String name;
  final int age;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'age': age,
      };

  @override
  String toString() => 'UserWithJson(name: $name, age: $age)';
}

class UserWithoutJson {
  const UserWithoutJson({required this.name, required this.age});

  final String name;
  final int age;

  @override
  String toString() => 'UserWithoutJson(name: $name, age: $age)';
}

/// Outer object that nests [UserWithJson] inside its own toJson tree.
class Order {
  const Order({
    required this.id,
    required this.customer,
    required this.items,
  });

  final String id;
  final UserWithJson customer;
  final List<String> items;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'customer': customer,
        'items': items,
      };

  @override
  String toString() =>
      'Order(id: $id, customer: ${customer.name}, ${items.length} items)';
}

class _Card<T> extends StatelessWidget {
  const _Card({
    required this.title,
    required this.panelExpectation,
    required this.stream,
    required this.initialData,
    required this.format,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String panelExpectation;
  final Stream<T> stream;
  final T initialData;
  final String Function(T value) format;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'In the DevTools panel: $panelExpectation',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            StreamBuilder<T>(
              stream: stream,
              initialData: initialData,
              builder: (context, snapshot) {
                final value = snapshot.data;
                return Text(
                  value == null ? 'no value' : format(value),
                  style: theme.textTheme.bodyLarge,
                );
              },
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onAction,
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
