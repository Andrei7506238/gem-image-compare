import 'dart:convert';
import 'dart:typed_data';
import 'package:clipboard/clipboard.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gem_image_compare/src/ui/image_comparison_cubit.dart';

import 'package:image/image.dart' as img;

class ImageInfoWidget extends StatelessWidget {
  const ImageInfoWidget(
      {super.key, required this.image, required this.currentSize, required this.name, required this.position});

  final String name;
  final Uint8List image;
  final Size currentSize;
  final Offset position;

  @override
  Widget build(BuildContext context) {
    const int numImagesPerRow = 4;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(name),
            const SizedBox(height: 15),
            Builder(builder: (context) {
              if (image.isEmpty) return const Text("No image");

              final w = MediaQuery.of(context).size.width / numImagesPerRow;
              return AspectRatio(
                aspectRatio: currentSize.width / currentSize.height,
                child: SizedBox(
                  width: w,
                  height: w * (currentSize.width / currentSize.height),
                  child: LayoutBuilder(
                    builder: (context, constraints) => GestureDetector(
                      onTapDown: (details) {
                        final dx = details.localPosition.dx;
                        final dy = details.localPosition.dy;

                        final pixelX = dx / constraints.maxWidth;
                        final pixelY = dy / constraints.maxHeight;

                        BlocProvider.of<ImageComparisonCubit>(context).setCoordinates(pixelX, pixelY);
                      },
                      child: Image.memory(
                        image,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                        filterQuality: FilterQuality.none,
                      ),
                    ),
                  ),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      FlutterClipboard.copy(base64Encode(image));
                    },
                    icon: const Icon(Icons.copy),
                  ),
                  IconButton(
                    onPressed: () {
                      FileSaver.instance.saveFile(
                        name: name,
                        bytes: image,
                        ext: "png",
                      );
                    },
                    icon: const Icon(Icons.save),
                  ),
                ],
              ),
            ),
            Builder(
              builder: (context) {
                if (image.isEmpty) return Container();
                final xp = position.dx;
                final yp = position.dy;

                final tmpImg = img.decodeImage(image);

                int x = (xp * tmpImg!.width).round().toInt();
                int y = (yp * tmpImg.height).round().toInt();

                if (x < 0) x = 0;
                if (y < 0) y = 0;

                if (x >= tmpImg.width) x = tmpImg.width - 1;
                if (y >= tmpImg.height) y = tmpImg.height - 1;

                final r = tmpImg.getPixel(x, y).r;
                final g = tmpImg.getPixel(x, y).g;
                final b = tmpImg.getPixel(x, y).b;
                final a = tmpImg.getPixel(x, y).a;

                return Text("x:$x, y:$y : ($r $g $b $a)");
              },
            ),
          ],
        ),
      ),
    );
  }
}
