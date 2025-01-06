import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NetworkImageViewer extends StatelessWidget {
  final String imageKey;
  final double? height;
  final BoxFit? fit;
  final double? width;

  const NetworkImageViewer({
    super.key,
    required this.imageKey,
    this.height,
    this.fit,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return SvgPicture.network(
        fit: fit ?? BoxFit.cover,
        imageKey,
        height: height,
        width: width,
        placeholderBuilder: (BuildContext context) => Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
      );
    } catch (e) {
      return const Icon(Icons.error, size: 50);
    }
  }
}
