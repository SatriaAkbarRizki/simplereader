import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';
import 'package:simplereader/service/filedoc.dart';

class WatermarkPDF {
  String namePDF;
  String nameWatermark;
  String path;
  String fontSize;
  Alignment postionWatermark;
  Color colors;
  double valueOpacity;

  WatermarkPDF(this.namePDF, this.nameWatermark, this.path, this.fontSize,
      this.postionWatermark, this.colors, this.valueOpacity);

  ServiceFile serviceFile = ServiceFile();

  Future<String?> watermark() async {
    final toStringPosition = postionWatermark.toString().split('.').last;
    PositionType position = PositionType.center;
    const listPositionType = PositionType.values;

    for (var element in listPositionType) {
      if (element.name.contains(toStringPosition)) {
        log(element.toString());
        position = element;
      }
    }

    String? watermarkedPdfPath = await PdfManipulator().pdfWatermark(
      params: PDFWatermarkParams(
          pdfPath: path,
          text: nameWatermark,
          watermarkColor: colors,
          fontSize: double.parse(fontSize),
          watermarkLayer: WatermarkLayer.overContent,
          opacity: valueOpacity,
          positionType: position),
    );
    if (watermarkedPdfPath != null) {
      await serviceFile
          .renameFile(namePDF, File(watermarkedPdfPath))
          .then((value) => watermarkedPdfPath = value);
      return watermarkedPdfPath;
    }
    return null;
  }
}