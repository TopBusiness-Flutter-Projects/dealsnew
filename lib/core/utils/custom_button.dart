import 'package:flutter/material.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/get_size.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    this.onTap,
    required this.title,
  });
  void Function()? onTap;
  String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: getSize(context) / 12, vertical: getSize(context) / 32),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(getSize(context) / 12),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.all(getSize(context) / 32),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(getSize(context) / 12),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.white,
              fontFamily: AppStrings.fontFamily,
            ),
          ),
        ),
      ),
    );
  }
}
