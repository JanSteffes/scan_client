part of swagger.api;

class ScanQuality {
  /// The underlying value of this enum member.
  String? value;

  ScanQuality._internal(this.value);

  ///
  static ScanQuality fast = ScanQuality._internal("Fast");

  ///
  static ScanQuality normal = ScanQuality._internal("Normal");

  ///
  static ScanQuality good = ScanQuality._internal("Good");

  ///
  static ScanQuality best = ScanQuality._internal("Best");

  ScanQuality.fromJson(dynamic data) {
    switch (data) {
      case "Fast":
        value = data;
        break;
      case "Normal":
        value = data;
        break;
      case "Good":
        value = data;
        break;
      case "Best":
        value = data;
        break;
      default:
        throw ('Unknown enum value to decode: $data');
    }
  }

  static dynamic encode(ScanQuality data) {
    return data.value;
  }
}
