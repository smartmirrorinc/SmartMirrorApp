part of components;

// Container module for Modules that are not yet supported.

class ModuleAnonymous extends Module {
  final Map<String, dynamic> json;
  ModuleAnonymous(Map<String, dynamic> _json)
      : json = _json,
        super(
            _json["_meta"]["id"],
            _json["_meta"]["order"],
            _json["module"]);

  @override
  Map<String, dynamic> toJson() {
    return json;
  }

  @override
  String toString() {
    return "{id:$id, order:$order, module:$module, json:$json}";
  }
}
