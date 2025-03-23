import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/assets_manager.dart';

class CustomDecodedImage extends StatelessWidget {
  const CustomDecodedImage({
    super.key,
    required this.base64String,
    this.height,
    this.width,
  });

  final dynamic base64String;
  final double? height;
  final double? width;

  // Static cache for decoded images and SVGs
  static final Map<String, dynamic> _imageCache = {};
  static final Map<String, bool> _svgCache = {};

  // Check if the data is SVG and cache the result
  bool _isSvgData(String data) {
    // Return cached result if available
    if (_svgCache.containsKey(data)) {
      return _svgCache[data]!;
    }

    try {
      final decodedString = utf8.decode(base64.decode(data));
      final isSvg = decodedString.contains("<svg");
      _svgCache[data] = isSvg;
      return isSvg;
    } catch (e) {
      debugPrint('Failed to detect SVG data: $e');
      _svgCache[data] = false;
      return false;
    }
  }

  // Get decoded image data from cache or decode new
  dynamic _getDecodedData(String data, bool isSvg) {
    // Return cached data if available
    if (_imageCache.containsKey(data)) {
      return _imageCache[data];
    }

    try {
      if (isSvg) {
        final svgString = utf8.decode(base64.decode(data));
        _imageCache[data] = svgString;
        return svgString;
      } else {
        final bytes = base64.decode(data);
        _imageCache[data] = bytes;
        return bytes;
      }
    } catch (e) {
      debugPrint('Error decoding image data: $e');
      return null;
    }
  }

  // Clean up cache when it gets too large
  static void _cleanCache() {
    if (_imageCache.length > 100) { // Adjust this number based on your needs
      _imageCache.clear();
    }
    if (_svgCache.length > 100) {
      _svgCache.clear();
    }
  }

  Widget _buildImageWidget() {
    if (base64String is! String) {
      return _buildFallbackImage();
    }

    try {
      final isSvg = _isSvgData(base64String);
      final decodedData = _getDecodedData(base64String, isSvg);

      if (decodedData == null) {
        return _buildFallbackImage();
      }

      _cleanCache(); // Clean cache periodically

      if (isSvg) {
        return RepaintBoundary(
          child: SvgPicture.string(
            decodedData,
            height: height,
            width: width,
            fit: BoxFit.cover,
          ),
        );
      } else {
        return RepaintBoundary(
          child: Image.memory(
            decodedData,
            height: height,
            width: width,
            fit: BoxFit.cover,
            cacheWidth: width?.toInt(),
            cacheHeight: height?.toInt(),
            gaplessPlayback: true,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error building image widget: $e');
      return _buildFallbackImage();
    }
  }

  Widget _buildFallbackImage() {
    return Image.asset(
      ImageAssets.logo2Image,
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: height,
        width: width,
        child: _buildImageWidget(),
      ),
    );
  }

  // Static method to clear caches if needed
  static void clearCache() {
    _imageCache.clear();
    _svgCache.clear();
  }
}