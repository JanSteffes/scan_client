import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as Math;
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:scan_client/widgets/opacity_wrapper.dart';

class FileContentShowFile extends StatefulWidget {
  final String fileName;
  final Uint8List documentData;

  FileContentShowFile({required this.fileName, required this.documentData});

  @override
  State<StatefulWidget> createState() {
    return FileContentShowFileState();
  }
}

class FileContentShowFileState extends State<FileContentShowFile> {
  late PdfController _pdfController;
  int _allPagesCount = 0;
  int _actualPageNumber = 1;

  @override
  void initState() {
    _pdfController =
        PdfController(document: PdfDocument.openData(widget.documentData));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sizes = MediaQuery.of(context).size;
    var sizeToUse = Math.min(sizes.height, sizes.width);
    var children = <Widget>[];
    var pdfView = GestureDetector(
      child: PdfView(
        documentLoader: Center(child: CircularProgressIndicator()),
        pageLoader: Center(child: CircularProgressIndicator()),
        controller: _pdfController,
        onDocumentLoaded: (document) {
          setState(() {
            _allPagesCount = document.pagesCount;
          });
        },
        onPageChanged: (page) {
          setState(() {
            _actualPageNumber = page;
          });
        },
      ),
      onHorizontalDragEnd: (drag) {
        if (drag.primaryVelocity == null) {
          return;
        }
        var left = drag.primaryVelocity! < 0;
        var duration = Duration(seconds: 1);
        var curve = Curves.ease;
        if (left) {
          _pdfController.nextPage(duration: duration, curve: curve);
        } else {
          _pdfController.previousPage(duration: duration, curve: curve);
        }
      },
    );
    children.add(pdfView);
    if (Platform.isLinux || Platform.isWindows || kIsWeb) {
      var arrowsRowChildren = <Widget>[];
      if (_actualPageNumber != 1) {
        var leftArrowButton = getArrowButtonContainer(true);
        arrowsRowChildren.add(leftArrowButton);
      } else {
        arrowsRowChildren.add(Spacer());
      }
      if (_actualPageNumber != _allPagesCount) {
        var rightArrowButton = getArrowButtonContainer(false);
        arrowsRowChildren.add(rightArrowButton);
      }
      if (arrowsRowChildren.length > 0) {
        children.add(
          Row(
            children: arrowsRowChildren,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        );
      }
    }
    children.add(Container(
        alignment: Alignment.topCenter,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            margin: EdgeInsets.only(top: 15),
            child: Text("${_actualPageNumber} von ${_allPagesCount}"))));
    return Container(
        height: sizeToUse,
        width: sizeToUse,
        child: Stack(
          alignment: Alignment.center,
          children: children,
        ));
  }

  getArrowButtonContainer(bool left) {
    var duration = Duration(seconds: 1);
    var curve = Curves.ease;
    var function = () => left
        ? _pdfController.previousPage(duration: duration, curve: curve)
        : _pdfController.nextPage(duration: duration, curve: curve);
    var iconToUse = Icon(
      Icons.arrow_forward_outlined,
      color: Colors.blue,
    );
    var icon = left
        ? Transform.rotate(angle: 90 * Math.pi / 90, child: iconToUse)
        : iconToUse;
    return OpacityWrapper(
      Material(
        color: Colors.blue.withOpacity(0.5),
        shape: CircleBorder(),
        child: IconButton(
          icon: icon,
          onPressed: function,
        ),
      ),
    );
  }
}
