enum StoreKey<T> {
  serverUrl<String>._(0),
  serverEndpoint<String>._(1),
  accessToken<String>._(2),
  customHeaders<String>._(3),
  mockFlag<String>._(4);

  const StoreKey._(this.id);
  final int id;
  Type get type => T;
}

class StoreModel<T> {
  final StoreKey<T> key;
  final T? value;

  StoreModel({required this.key, required this.value});

  @override
  String toString() {
    return 'StoreModel(key: $key, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StoreModel<T> &&
            runtimeType == other.runtimeType &&
            key == other.key &&
            value == other.value;
  }

  @override
  int get hashCode => key.hashCode ^ value.hashCode;
}
