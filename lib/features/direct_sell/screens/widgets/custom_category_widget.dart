import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:top_sale/config/routes/app_routes.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/app_fonts.dart';
import 'package:top_sale/core/utils/get_size.dart';

import '../../../../core/widgets/decode_image.dart';
import '../../../../core/widgets/decode_image_with_text.dart';

class CustomCategoryWidget extends StatelessWidget {
  const CustomCategoryWidget({
    super.key,
    required this.title,
    required this.image,
    required this.catId,
  });
  final String title;
  final String image;
  final String catId;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.productsRoute,
          arguments: [title, catId],
        );
      },
      child: Container(
        height: getSize(context) / 4,
        child: Column(
          children: [
            Container(
                height: getheightSize(context) / 12,
                width: getheightSize(context) / 12,
                decoration: BoxDecoration(
                    color: AppColors.secondry,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.secondry, width: 1.8)),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: image == "false"
                        ? Center(
                            child: Text(
                                title.length > 5
                                    ? title.substring(0, 3)
                                    : title,
                                style: getBoldStyle(
                                    color: AppColors.white, fontSize: 18.sp)),
                          )
                        : CustomDecodedImageWithText(
                           // context: context,
                            character: title.length >= 4
                                ? title.removeAllWhitespace
                                    .substring(0, 4)
                                    .toString()
                                : title.removeAllWhitespace,
                            base64String: image,
                            height: 50.w,
                            width: 50.w,
                          )
                    // Image.network(
                    //         image,
                    //         fit: BoxFit.cover,
                    //       ),
                    )),
            Flexible(
              child: SizedBox(
                  width: getheightSize(context) / 12,
                  child: AutoSizeText(title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: getBoldStyle(fontSize: 18.sp))),
            ),
          ],
        ),
      ),
    );
  }
}
