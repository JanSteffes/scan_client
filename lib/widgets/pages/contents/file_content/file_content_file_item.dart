import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scan_client/widgets/opacity_wrapper.dart';

class FileItem extends StatelessWidget {
  final String fileName;
  final bool isSelected;
  final bool fadeInPageHint;
  final Future<Uint8List?> thumbnailDataFuture;
  final Function(String) selectFunction;
  final int? selectionIndex;
  final EdgeInsetsGeometry? paddingInsets;

  FileItem(
      {required this.fileName,
      required this.isSelected,
      required this.fadeInPageHint,
      required this.selectFunction,
      required this.thumbnailDataFuture,
      this.selectionIndex,
      this.paddingInsets});

  @override
  Widget build(BuildContext context) {
    if (fileName.isEmpty) {
      return Text("Fehler beim Laden der Daten!");
    }
    var stackChildren = <Widget>[];
    // add thumbnail as background
    stackChildren.add(getFileThumbnailWidget(fileName));
    // add fileName with some background
    stackChildren.add(Container(
        alignment: AlignmentDirectional.bottomStart,
        child: Container(
            width: double.infinity,
            padding: paddingInsets,
            color: isSelected ? Colors.green : Colors.blue,
            child: Text(
              fileName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ))));
    // current fileItem is selected and has a selection index, show wich page it would be
    if (isSelected && selectionIndex != null) {
      var pageContainer = Container(
          alignment: AlignmentDirectional.topStart,
          child: Container(
              width: double.infinity,
              padding: paddingInsets,
              color: isSelected ? Colors.green : Colors.blue,
              child: Text(
                "Dokument ${selectionIndex! + 1}",
                style: TextStyle(fontWeight: FontWeight.bold),
              )));
      if (!fadeInPageHint) {
        stackChildren.add(pageContainer);
      } else {
        stackChildren.add(OpacityWrapper(pageContainer));
      }
    }
    return GestureDetector(
      child: Stack(
        children: stackChildren,
        alignment: AlignmentDirectional.bottomStart,
        fit: StackFit.expand,
      ),
      // onLongPress: () => setState(() => selectItem(current)),
      onTap: () => selectFunction(fileName),
    );
  }

  ///build widget for files
  Widget getFileThumbnailWidget(String current) {
    return FutureBuilder<Uint8List?>(
        future:
            thumbnailDataFuture, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              try {
                return Image.memory(
                  snapshot.data!,
                  fit: BoxFit.fill,
                );
              } on Exception catch (e) {
                log("Error while creating image preview of '$current': ${e.toString()}");
                return Icon(Icons.error, color: Colors.red);
              }
            }
            return Container(child: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Icon(Icons.error, color: Colors.red);
          } else {
            return Container(child: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
