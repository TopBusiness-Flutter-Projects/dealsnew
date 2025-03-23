import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/dialogs.dart';
import 'package:top_sale/features/clients/cubit/clients_cubit.dart';

import '../../../../core/utils/app_strings.dart';

class CustomROW extends StatelessWidget {
  const CustomROW(
      {super.key,
      required this.image,
      required this.text,
      required this.text2,
      this.isLocation = false,  this.id});
  final String? image;
  final String? text;
  final String? text2;
  final bool isLocation;
  final int? id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      image!,
                      color: AppColors.secondry,
                      width: 35.w,
                      height: 35.h,
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text!,
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppStrings.fontFamily),
                        ),
                        Text(
                          text2!,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppStrings.fontFamily),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            isLocation
                ? GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("change_location".tr()),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      
                                        context
                                            .read<ClientsCubit>()
                                            .updatePartenerLocation(context,
                                              id: id!,
                                              partnerLattitude: context.read<ClientsCubit>().currentLocation?.latitude ?? 0.0,
                                              partnerLangitude:                           context.read<ClientsCubit>().currentLocation?.longitude ?? 0.0,
                                              street:  context.read<ClientsCubit>().city,
                                            );
                                     
                                    },
                                    child: Text("yes".tr()),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); 
                                    },
                                    child: Text("no".tr()),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.edit_location_alt_rounded),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_forward_ios),
                  )
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Divider(),
        )
      ]),
    );
  }
}
