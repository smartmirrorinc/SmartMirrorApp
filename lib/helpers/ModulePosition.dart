class ModulePosition {
  Position position;

  ModulePosition(pos) : position = pos;

  factory ModulePosition.fromString(String str) {
    if (str == null) return null;

    Iterable<Position> p =
        Position.values.where((x) => x.toString() == ("Position." + str));

    if (p.length < 1) {
      return null;
    } else {
      assert(p.length == 1);
      return ModulePosition(p.first);
    }
  }

  // Nicely formatted string for position picker etc
  String toString() {
    if (position == null) {
      return "No position";
    } else {
      String tmp = position.toString().substring(9).replaceAll("_", " ");
      return "${tmp[0].toUpperCase()}${tmp.substring(1)}";
    }
  }

  // MagicMirror² config compatible string to use in Module.toJson
  String toJsonString() {
    return position.toString().substring(9);
  }

  static Iterable<ModulePosition> getPositions() {
    return Position.values.map((Position pos) {
      return ModulePosition(pos);
    });
  }
}

enum Position {
  top_bar,
  top_left,
  top_center,
  top_right,
  upper_third,
  middle_center,
  lower_third,
  bottom_left,
  bottom_center,
  bottom_right,
  bottom_bar,
  fullscreen_above,
  fullscreen_below
}
