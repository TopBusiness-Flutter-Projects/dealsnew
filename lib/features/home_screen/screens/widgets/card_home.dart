import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/get_size.dart';

class CardHome extends StatelessWidget {
  const CardHome(
      {super.key, required this.text, required this.image, this.onPressed});
  final String text;
  final String image;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(0.1),
                spreadRadius: 1, 
                blurRadius: 1,
                offset: const Offset(0, 1), 
              ),
            ],
            borderRadius:
                BorderRadiusDirectional.circular(getSize(context) / 20),
            color: AppColors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Image.asset(
                image,
                color: AppColors.primary,
                fit: BoxFit.contain,
                width: getSize(context) / 7,
                height: getSize(context) / 7,
              ),
            ),
            SizedBox(
              height: getSize(context) / 32,
            ),
            Text(
              text,
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}
