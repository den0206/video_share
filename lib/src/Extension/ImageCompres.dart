import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File> compressImage(File file) async {
  final filePath = file.absolute.path;
  final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
  final splitted = filePath.substring(0, (lastIndex));
  final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

  final compressedImage = await FlutterImageCompress.compressAndGetFile(
    filePath,
    outPath,
    minWidth: 240,
    minHeight: 240,
    quality: 50,
  );

  return compressedImage;
}
