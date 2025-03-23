import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/config/routes/app_routes.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/app_fonts.dart';
import 'package:top_sale/core/utils/get_size.dart';
import 'package:top_sale/features/direct_sell/screens/widgets/custom_category_widget.dart';

import '../../../../core/models/category_model.dart';
import '../../../../core/widgets/decode_image.dart';

class CustomCategorySection extends StatelessWidget {
   CustomCategorySection({super.key,required this.result});
  List<CategoryModelData> result;

  @override
  Widget build(BuildContext context) {
    String testImage =
        'https://img.freepik.com/free-photo/organic-cosmetic-product-with-dreamy-aesthetic-fresh-background_23-2151382816.jpg';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "categories".tr(),
              style:
                  getBoldStyle(color: AppColors.secondry, fontSize: 20.sp),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.categoriesRoute,
                  );
                },
                child: Text(
                  "all".tr(),
                  style: getRegularStyle(
                      color: AppColors.orangeThirdPrimary, fontSize: 18.sp),
                )),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        SizedBox(
          height: getheightSize(context) / 8,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => CustomCategoryWidget(
                catId: result[index].id.toString()??'-1',
                    image:result[index].image.toString(),
                     //image: "false",
                    title: result[index].name.toString(),
                  ),
              separatorBuilder: (context, index) => SizedBox(
                    width: 14.w,
                  ),
              itemCount: result.length),
        )
      ],
    );
  }
}
