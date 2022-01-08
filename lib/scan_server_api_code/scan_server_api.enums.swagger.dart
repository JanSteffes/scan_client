import 'package:json_annotation/json_annotation.dart';

enum ScanQuality {
  @JsonValue('Fast')
  fast,
  @JsonValue('Normal')
  normal,
  @JsonValue('Good')
  good,
  @JsonValue('Best')
  best
}

const $ScanQualityMap = {
  ScanQuality.fast: 'Fast',
  ScanQuality.normal: 'Normal',
  ScanQuality.good: 'Good',
  ScanQuality.best: 'Best',
};
