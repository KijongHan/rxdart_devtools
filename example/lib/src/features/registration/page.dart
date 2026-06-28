import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/sdk.dart';

class RegistrationExamplePage extends StatefulWidget {
  const RegistrationExamplePage({super.key});

  @override
  State<RegistrationExamplePage> createState() =>
      _RegistrationExamplePageState();
}

class _RegistrationExamplePageState extends State<RegistrationExamplePage> {
  final List<_TrackedEntry> _entries = <_TrackedEntry>[];
  int _nextId = 1;

  void _register() {
    final id = _nextId++;
    final name = 'registration.subject-$id';
    final subject = BehaviorSubject<int>.seeded(0).track(name).asSubject();
    setState(() {
      _entries.add(_TrackedEntry(name: name, subject: subject));
    });
  }

  void _close(_TrackedEntry entry) {
    entry.subject.close();
    setState(() {
      _entries.remove(entry);
    });
  }

  void _emit(_TrackedEntry entry) {
    entry.subject.add(entry.subject.value + 1);
  }

  @override
  void dispose() {
    for (final entry in _entries) {
      entry.subject.close();
    }
    _entries.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tap "Register" to create a tracked subject — it should '
                  'appear in the rxdart DevTools panel. Tap "Close" to '
                  'dispose it and watch it disappear.',
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _register,
                  icon: const Icon(Icons.add),
                  label: const Text('Register subject'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_entries.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No active subjects yet.'),
            ),
          )
        else
          ..._entries.map(
            (entry) => Card(
              child: ListTile(
                title: Text(entry.name),
                subtitle: StreamBuilder<int>(
                  stream: entry.subject,
                  initialData: entry.subject.value,
                  builder: (context, snapshot) =>
                      Text('value: ${snapshot.data}'),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Emit next value',
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => _emit(entry),
                    ),
                    IconButton(
                      tooltip: 'Close & deregister',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _close(entry),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _TrackedEntry {
  _TrackedEntry({required this.name, required this.subject});

  final String name;
  final BehaviorSubject<int> subject;
}
