import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Actions that can be done with files
enum FileActions { see, rename, share, delete, merge }

extension FileActionsExtension on FileActions {
  static const captionData = {
    FileActions.see: "Anzeigen",
    FileActions.delete: "Löschen",
    FileActions.rename: "Umbennen",
    FileActions.share: "Teilen",
    FileActions.merge: "Zusammenführen"
  };

  /// return caption to use
  String get caption => captionData[this]!;

  static const iconData = {
    FileActions.see: Icons.image_outlined,
    FileActions.delete: Icons.delete_outlined,
    FileActions.rename: Icons.text_fields_outlined,
    FileActions.share: Icons.share_outlined,
    FileActions.merge: Icons.add_to_photos_outlined
  };

  /// return icon to use
  IconData get icon => iconData[this]!;

  /// define actions suited for multiple files
  static const multipleData = {FileActions.delete, FileActions.merge};

  /// define actions suited for single files
  static const singleData = {
    FileActions.see,
    FileActions.rename,
    FileActions.share,
    FileActions.delete
  };

  /// return if action can be used in single case
  bool get singleUseCase => singleData.contains(this);

  /// return if action can be used in multiple case
  bool get multipleUseCase => multipleData.contains(this);

  static const sideData = {
    FileActions.see: FileActionSide.left,
    FileActions.rename: FileActionSide.left,
    FileActions.share: FileActionSide.left,
    FileActions.merge: FileActionSide.left,
    FileActions.delete: FileActionSide.right
  };

  FileActionSide get sideToUse => sideData[this]!;
}

/// If split into two sides, see where to place them
enum FileActionSide { left, right }
