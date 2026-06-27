import 'package:flutter/material.dart';
import 'package:rxdart_devtools_extension/src/features/registry/repository.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/repository.dart';
import 'package:rxdart_devtools_extension/src/features/streams/components/list.dart';
import 'package:rxdart_devtools_extension/src/features/streams/components/stream_search.dart';
import 'package:rxdart_devtools_extension/src/features/streams/view_model.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';
import 'package:rxdart_devtools_extension/src/shared/spacing.dart';

class StreamsPanel extends StatefulWidget {
  const StreamsPanel({super.key});

  @override
  State<StreamsPanel> createState() => _StreamsPanelState();
}

class _StreamsPanelState extends State<StreamsPanel> {
  late final StreamsViewModel _streamsViewModel;
  late final StreamDetailsRepository _streamDetailsRepository;
  late final RegistryRepository _registryRepository;

  @override
  void initState() {
    super.initState();
    _streamsViewModel = getIt.get<StreamsViewModel>();
    _streamDetailsRepository = getIt.get<StreamDetailsRepository>();
    _registryRepository = getIt.get<RegistryRepository>();
  }

  Future<void> _onClearAll() async {
    final result = await _registryRepository.clearAll();
    if (!mounted) return;
    result.fold(
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Streams cleared'),
          ),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to clear streams'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StreamsViewState>(
      stream: _streamsViewModel.viewState,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state == null) return const SizedBox.shrink();
        return Container(
            padding: const EdgeInsets.all(Spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      'Streams',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Clear all tracked streams',
                      icon: const Icon(Icons.delete),
                      onPressed: _onClearAll,
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.md),
                StreamSearch(
                  onSearch: (query) => _streamsViewModel.setSearchQuery(query),
                ),
                const SizedBox(height: Spacing.md),
                Expanded(
                  child: StreamsList(
                    viewState: state,
                    onSelectedStreamChanged: (streamId) =>
                        _streamDetailsRepository.selectStream(streamId),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
