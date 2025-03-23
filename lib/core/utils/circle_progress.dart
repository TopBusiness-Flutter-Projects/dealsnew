import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:top_sale/core/utils/app_colors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final Color? color;
  final Color? backgroundColor;
  const CustomLoadingIndicator({super.key, this.color, this.backgroundColor});
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? const CupertinoActivityIndicator(animating: true, radius: 15)
        : CircularProgressIndicator(
            color: color ?? AppColors.primary,
            backgroundColor: backgroundColor);
  }
}
