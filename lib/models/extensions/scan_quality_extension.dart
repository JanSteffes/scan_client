import 'package:scan_client/scan_server_api_code/scan_server_api.enums.swagger.dart';
import 'package:scan_client/scan_server_api_code/scan_server_api.swagger.dart';

extension ScanQualityExtension on ScanQuality {
  static const captionData = {
    ScanQuality.fast: "Schnell",
    ScanQuality.normal: "Normal",
    ScanQuality.good: "Besser",
    ScanQuality.best: "Beste"
  };

  /// return caption to use
  String get caption => captionData[this]!;
}
