import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
class TextStyles {
    static TextStyle size18FontWidget400BlackWithOpacity4 = TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.black.withOpacity(0.4));
    static TextStyle size18FontWidget400BlackWithOpacity8 = TextStyle(
      fontSize: 18.sp,
     
      fontWeight: FontWeight.w400,
      color: AppColors.black.withOpacity(0.8));
        static TextStyle size16FontWidget400Primary = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    
    color: AppColors.primary,
  );
    static TextStyle size14FontWidget400Black = TextStyle(
      color: AppColors.black,
   
      fontSize: 14.sp,
      fontWeight: FontWeight.w400);
  static TextStyle size16FontWidget700BlackWithOpacity8 = TextStyle(
      fontSize: 16.sp,
      
      fontWeight: FontWeight.bold,
      color: AppColors.black.withOpacity(0.8));
  static TextStyle size16FontWidget400Black = TextStyle(
      color: AppColors.black.withOpacity(0.2),
      fontSize: 16.sp,
      fontWeight: FontWeight.w400);
  static TextStyle size18FontWidget700Gray = TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      color: const Color(0xff525252));
  static TextStyle size16FontWidget400Gray = TextStyle(
      color: const Color(0xff747474),
      fontSize: 14.sp,
      fontWeight: FontWeight.w400);
  static TextStyle size16FontWidget400ORANGE = TextStyle(
      color: AppColors.orange, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle size22FontWidget400White = TextStyle(
      color: AppColors.white, fontSize: 22.sp, fontWeight: FontWeight.w400);
}
