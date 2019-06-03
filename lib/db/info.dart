
class Info {

  final String key;
  final String value;

  Info({ this.key, this.value });

  factory Info.fromMap(Map<String, dynamic> data) => new Info(
    key: data["key"],
    value: data["value"],
  );

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
    };
  }
}