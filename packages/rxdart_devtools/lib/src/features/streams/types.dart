class StreamIdentifier {
  StreamIdentifier({
    required this.id,
    required this.name,
    required this.typeLabel,
  });

  final String id;
  final String name;
  final String typeLabel;

  StreamIdentifier copyWith({
    String? id,
    String? name,
    String? typeLabel,
  }) {
    return StreamIdentifier(
      id: id ?? this.id,
      name: name ?? this.name,
      typeLabel: typeLabel ?? this.typeLabel,
    );
  }

  @override
  bool operator ==(Object other) => other is StreamIdentifier && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class StreamMetadata {
  StreamMetadata({
    required this.listenerCount,
    required this.lastEmittedAt,
    required this.isClosed,
    required this.closedAt,
    this.isInjectable = false,
    this.isSubject = false,
  });

  final int listenerCount;
  final DateTime? lastEmittedAt;
  final bool isClosed;
  final DateTime? closedAt;
  final bool isInjectable;
  final bool isSubject;

  StreamMetadata copyWith({
    int? listenerCount,
    DateTime? lastEmittedAt,
    bool? isClosed,
    DateTime? closedAt,
    bool? isInjectable,
    bool? isSubject,
  }) {
    return StreamMetadata(
      listenerCount: listenerCount ?? this.listenerCount,
      lastEmittedAt: lastEmittedAt ?? this.lastEmittedAt,
      isClosed: isClosed ?? this.isClosed,
      closedAt: closedAt ?? this.closedAt,
      isInjectable: isInjectable ?? this.isInjectable,
      isSubject: isSubject ?? this.isSubject,
    );
  }
}

class StreamData<T> {
  StreamData({
    required this.lastValue,
    required this.lastError,
  });

  final T? lastValue;
  final Object? lastError;

  StreamData<T> copyWith({T? lastValue, Object? lastError}) {
    return StreamData<T>(
      lastValue: lastValue ?? this.lastValue,
      lastError: lastError ?? this.lastError,
    );
  }
}

class StreamEntry<T> {
  StreamEntry({
    required this.entryIdentifier,
    required this.metadata,
    this.data,
  });

  final StreamIdentifier entryIdentifier;
  final StreamData<T>? data;
  final StreamMetadata metadata;

  StreamEntry<T> copyWith({
    StreamIdentifier? entryIdentifier,
    StreamData<T>? data,
    StreamMetadata? metadata,
  }) {
    return StreamEntry<T>(
      entryIdentifier: entryIdentifier ?? this.entryIdentifier,
      data: data ?? this.data,
      metadata: metadata ?? this.metadata,
    );
  }
}
