import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/assets_manager.dart';

class CustomDecodedImageWithText extends StatelessWidget {
  const CustomDecodedImageWithText({
    super.key,
    required this.base64String,
    this.height,
    this.character,
    this.width,
  });

  final String? character;
  final dynamic base64String;
  final double? height;
  final double? width;

  // Static cache to store decoded images
  static final Map<String, Uint8List> _imageCache = {};

  /// Decode the image only once and cache it
  Uint8List? _getDecodedImage() {
    if (base64String is! String) return null;

    // Return cached image if available
    if (_imageCache.containsKey(base64String)) {
      return _imageCache[base64String];
    }

    // Decode and cache new image
    try {
      final decoded = base64.decode(base64String);
      _imageCache[base64String] = decoded;
      return decoded;
    } catch (e) {
      debugPrint('Error decoding image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use const for the style to prevent rebuilds
    const textStyle = TextStyle(
      // fontFamily: FontFamily.bold,
      // color: AppColors.black,
      fontSize: 18,
    );

    // Memoize the decoded bytes
    final decodedBytes = _getDecodedImage();

    // Use const where possible to prevent rebuilds
    return RepaintBoundary(
      child: decodedBytes != null
          ? Image.memory(
              decodedBytes,
              height: height,
              width: width,
              fit: BoxFit.cover,
              // Add caching for the image widget
              cacheWidth: width?.toInt(),
              cacheHeight: height?.toInt(),
              gaplessPlayback: true,
            )
          : Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    ImageAssets.backgroundProduct,
                 color:    AppColors.primary,
                    height: height,
                    width: width,
                  ),
                  Text(
                    character ?? '',
                    style: textStyle,
                  ),
                ],
              ),
            ),
    );
  }
}
