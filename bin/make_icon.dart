import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

void main() {
  final size = 1024;
  final image = img.Image(width: size, height: size);
  final cx = size / 2, cy = size / 2;
  final outerR = size / 2 - 4;
  final innerR = outerR - 50;
  final triSize = size * 0.24;
  final triOffsetX = triSize * 0.2;
  final halfH = triSize * sqrt(3) / 2;

  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      final dx = (x - cx).abs(), dy = (y - cy).abs();
      final dist = sqrt(dx * dx + dy * dy);

      if (dist > outerR) {
        image.setPixelRgba(x, y, 0, 0, 0, 0);
      } else if (dist >= innerR) {
        image.setPixelRgba(x, y, 255, 255, 255, 255);
      } else {
        final px = x - (cx - triOffsetX);
        final py = y - cy;
        bool tri = py > -halfH && py < halfH && px > 0 && px < (halfH - py.abs()) / sqrt(3) * 2;
        if (tri) {
          image.setPixelRgba(x, y, 255, 255, 255, 255);
        } else {
          image.setPixelRgba(x, y, 255, 0, 0, 255);
        }
      }
    }
  }

  final png = img.encodePng(image);
  Directory('assets/images/logo').createSync(recursive: true);
  File('assets/images/logo/logo_yt.png').writeAsBytesSync(png);
  print('Icon: assets/images/logo/logo_yt.png ${size}x${size}');
}
