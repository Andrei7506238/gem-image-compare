import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart' as image;

class ImageComparisonData {
  final Uint8List expectedData;
  final Uint8List actualData;

  final double maeCurrent;
  final double maeThreshold;

  final String filename;

  int get width => image.decodeImage(expectedData)?.width ?? 0;
  int get height => image.decodeImage(expectedData)?.height ?? 0;

  ImageComparisonData({
    required this.expectedData,
    required this.actualData,
    this.maeCurrent = 0,
    this.maeThreshold = 0,
    this.filename = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data1': base64Encode(expectedData),
      'data2': base64Encode(actualData),
      'maeCurrent': maeCurrent,
      'maeThreshold': maeThreshold,
      'filename': filename,
    };
  }

  factory ImageComparisonData.fromMap(Map<String, dynamic> map) {
    return ImageComparisonData(
      expectedData: base64Decode(map['data1'] as String),
      actualData: base64Decode(map['data2'] as String),
      maeCurrent: (map['maeCurrent'] as num).toDouble(),
      maeThreshold: (map['maeThreshold'] as num).toDouble(),
      filename: map['filename'] as String,
    );
  }
}

extension ImageComparisonDataDifferenceExtension on ImageComparisonData {
  Uint8List getDifference() {
    final img1 = image.decodeImage(expectedData);
    final img2 = image.decodeImage(actualData);

    final result = image.Image(width: img1!.width, height: img1.height);
    for (int y = 0; y < img1.height; y++) {
      for (int x = 0; x < img1.width; x++) {
        final actualPixel = img1.getPixel(x, y);
        final expectedPixel = img2!.getPixel(x, y);

        final diffR = actualPixel.r - expectedPixel.r;
        final diffG = actualPixel.g - expectedPixel.g;
        final diffB = actualPixel.b - expectedPixel.b;
        final diffA = actualPixel.a - expectedPixel.a;

        result.setPixelRgba(x, y, diffR.abs(), diffG.abs(), diffB.abs(), diffA.abs());
      }
    }

    return image.encodePng(result);
  }
}
