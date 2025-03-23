import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/widgets/custom_text_form_field.dart';

import '../../../../core/utils/app_colors.dart';
import '../../cubit/direct_sell_cubit.dart';

class CustomSearchWidget extends StatefulWidget {
  const CustomSearchWidget({super.key, this.isHome = false});
  final bool isHome;
  @override
  State<CustomSearchWidget> createState() => _CustomSearchWidgetState();
}

class _CustomSearchWidgetState extends State<CustomSearchWidget> {
  String barcode = '';
  @override
  Widget build(BuildContext context) {
    var cubit = context.read<DirectSellCubit>();
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: CustomTextField(
                controller: cubit.searchController,
                onChanged: (keyValue) {
                  if (keyValue.isEmpty) {
                    cubit.getAllProducts();
                  } else {
                    EasyDebounce.debounce(
                        'search', // <-- An ID for this particular debouncer
                        const Duration(seconds: 1), // <-- The debounce duration
                        () => cubit.searchProducts() // <-- The target method
                        );
                  }
                },
                labelText: "search_product".tr(),
                suffixIcon: GestureDetector(
                  onTap: () {
                    cubit.clearSearchText();
                  },
                  child: Icon(
                    Icons.close,
                    size: 35,
                    color: AppColors.secondry,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 35,
                  color: AppColors.secondry,
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            GestureDetector(
                onTap: () async {
                  String? scannedValue = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AiBarcodeScanner(
                        onScan: (p0) {},
                        onDispose: () {
                          debugPrint("Barcode scanner disposed!");
                        },
                        controller: MobileScannerController(
                          detectionSpeed: DetectionSpeed.noDuplicates,
                        ),
                        onDetect: (BarcodeCapture capture) {
                          String? scannedValue =
                              capture.barcodes.first.rawValue;
                          cubit.searchController.text = scannedValue!;

                          debugPrint("Barcode scanned: $scannedValue");
                          cubit.searchProducts(isBarcode: true);
                          setState(() {
                            barcode = scannedValue!;
                            print("llll ${barcode}");
                          });
                          // successGetBar(scannedValue);
                          // Update the barcode value and pop back to the previous screen
                        },
                      ),
                    ),
                  );

                  // If a barcode was scanned, update the UI
                  if (scannedValue != null) {
                    setState(() {
                      barcode = scannedValue;
                      print("llll ${barcode}");
                    });
                  }
                },
                child: Scanner()),
            SizedBox(
              width: 8,
            )
          ],
        ),
        if (barcode.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                barcode,
                style: TextStyle(color: Colors.white),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    //  cubit.getAllProducts();
                    barcode = "";
                  });
                },
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.white,
                  size: 30,
                ),
              )
            ],
          ),
      ],
    );
  }
}

class Scanner extends StatelessWidget {
  const Scanner({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.secondry,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Padding(
        padding: EdgeInsets.all(15.0.w),
        child: Icon(
          CupertinoIcons.barcode_viewfinder,
          color: AppColors.white,
          size: 30.w,
        ),
      ),
    );
  }
}
