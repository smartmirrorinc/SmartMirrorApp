class Module {
  final int id;
  final String name;
  int order;
  String position;

  Module({this.id, this.name, this.order, this.position});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['_meta']['id'],
      order: json['_meta']['order'],
      name: json['name'],
      position: json['position'],
    );
  }
}
