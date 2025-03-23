import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/get_size.dart';

class CustomClient extends StatelessWidget {
  CustomClient({super.key,required this.image,required this.text});
  String image;
  String text;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(image),
              SizedBox(width: 20.w,),
              Text(text),
            ],),
          SizedBox(height: getSize(context) / 40),
        ],
      ),
    );
  }
}
