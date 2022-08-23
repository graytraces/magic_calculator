class KeyValueMap {
  final String? key;
  final String? value;

  KeyValueMap({this.key, this.value});

  factory KeyValueMap.fromMap(Map<String, dynamic> json) =>
      new KeyValueMap(key: json['key'], value: json['value']);

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
    };
  }
}
