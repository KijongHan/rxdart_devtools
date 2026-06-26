import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/registry/client.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';

class InjectDialog extends StatefulWidget {
  const InjectDialog({required this.stream});

  final StreamEntryDto stream;

  @override
  State<InjectDialog> createState() => _InjectDialogState();
}

class _InjectDialogState extends State<InjectDialog> {
  final _controller = TextEditingController();
  bool _asError = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_asError) {
      getIt
          .get<RegistryClient>()
          .injectError(widget.stream.id, _controller.text);
    } else {
      getIt.get<RegistryClient>().inject(widget.stream.id, _controller.text);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text('Inject into ${widget.stream.name}'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 320),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.stream.typeLabel,
              style:
                  theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 12),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Value')),
                ButtonSegment(value: true, label: Text('Error')),
              ],
              selected: {_asError},
              onSelectionChanged: (selection) {
                setState(() => _asError = selection.first);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: _asError ? 'Error message' : 'Raw value',
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Send')),
      ],
    );
  }
}
