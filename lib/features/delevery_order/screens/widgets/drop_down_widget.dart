import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/app_strings.dart';
import 'package:top_sale/features/delevery_order/cubit/delevery_orders_cubit.dart';
import 'package:top_sale/features/delevery_order/cubit/delevery_orders_state.dart';
import '../../../../core/utils/get_size.dart';

class DropDownMenuWidget extends StatefulWidget {
  const DropDownMenuWidget({super.key});

  @override
  State<DropDownMenuWidget> createState() => _DropDownMenuWidgetState();
}

class _DropDownMenuWidgetState extends State<DropDownMenuWidget> {



  @override
  Widget build(BuildContext context) {
    return       BlocBuilder<DeleveryOrdersCubit, DeleveryOrdersState>(
      builder: (context, state) {
        var cubit = context.read<DeleveryOrdersCubit>();

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Row(
                children: [
                  Expanded(
                    child: AutoSizeText(
                      'choose_filter'.tr(),
                      style: TextStyle(
                        fontSize: getSize(context) / 25,
                        color: AppColors.grayLite,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: cubit.items
                  .map((String item) =>
                  DropdownMenuItem<String>(
                    value: item,
                    child: AutoSizeText(
                      item.tr(),
                      style: TextStyle(
                        fontSize: getSize(context) / 25,
                        fontWeight: FontWeight.bold,
                        fontFamily:AppStrings.fontFamily,
                        color: AppColors.grayLite,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
                  .toList(),
              value: cubit.selectedValue,
              onChanged: (String? value) {
                setState(() {
                  cubit. changeSelectedValue(value!);
                  cubit.selectedValue = value!;
                });
              },
              buttonStyleData: ButtonStyleData(
                height: getSize(context) / 9,
                width: getSize(context) / 2.5,
                padding: const EdgeInsets.only(left: 14, right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(getSize(context) / 12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                elevation: 0,
              ),
              iconStyleData: IconStyleData(
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                ),
                iconSize: getSize(context) / 18,
                iconEnabledColor: AppColors.grayLite,
                iconDisabledColor: Colors.grey,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: getSize(context) / 2,
                width: getSize(context) / 2.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                ),
                scrollbarTheme: ScrollbarThemeData(
                  radius: Radius.circular(getSize(context) / 20),
                ),
              ),
              menuItemStyleData: MenuItemStyleData(
                height: getSize(context) / 8,
                padding: EdgeInsets.only(
                    left: getSize(context) / 12, right: getSize(context) / 12),
              ),
            ),
          ),
        );
      },
    );
  }
}
