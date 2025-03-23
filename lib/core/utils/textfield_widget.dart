import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/utils/style_text.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget(
      {super.key,
      this.controller,
      this.maxLines,this.keyboardType,
      required this.titleFromTextField,
      required this.hintFromTextField});

  final String titleFromTextField;
  final String hintFromTextField;
  TextEditingController? controller;
  TextInputType? keyboardType;

  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titleFromTextField,
              style: TextStyles.size18FontWidget400BlackWithOpacity8),
          SizedBox(height: 8.h),
          TextField(
            controller: controller,
            keyboardType:keyboardType,
            maxLines:
                maxLines ?? 1, // Uses `maxLines` if not null; defaults to `1`.
            decoration: InputDecoration(
              hintText: hintFromTextField,
              hintStyle: TextStyles.size18FontWidget400BlackWithOpacity4
                  .copyWith(fontSize: 14.sp),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
