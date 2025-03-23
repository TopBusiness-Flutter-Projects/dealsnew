import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:top_sale/core/api/end_points.dart';
import 'package:top_sale/core/utils/assets_manager.dart';
import '../../../../../core/models/partner_model.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_fonts.dart';
import '../../../../details_order/screens/pdf.dart';
import '../../../cubit/clients_cubit.dart';
import 'custom_info_row.dart';

class CustomBillContainer extends StatelessWidget {
  CustomBillContainer({super.key, required this.isCurrent, this.invoice
      // required this.orderModel,
      });
  Invoice? invoice;
  final bool isCurrent;
  //final TheOrder orderModel;

  @override
  Widget build(BuildContext context) {
    ClientsCubit cubit = context.read<ClientsCubit>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.orange, width: 1),
            borderRadius: BorderRadius.circular(15),
            color: AppColors.white),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              //width: getSize(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: CustomInfoRow(
                                path: ImageAssets.numberOfBills,
                                text: "bill_number".tr()),
                          ),
                          Text(
                            invoice?.name?.toString() ?? "",
                            style: getMediumStyle(
                              color: AppColors.primary,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: CustomInfoRow(
                                path: ImageAssets.calenderIcon,
                                text: invoice?.invoiceDate.substring(0, 10)
                                //  DateFormat.yMMMd("en")
                                //         .format(DateTime.parse(
                                //             invoice?.invoiceDate))
                                //         .toString() ??
                                //     ""
                                //  text:salesOrders?.dateOrder.toString()??""
                                ),
                          ),
                          SizedBox(
                            width: 18.w,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: TotalRow(
                                path: ImageAssets.totalIcon,
                                text: invoice?.amountTotal.toString() ?? ""),
                          ),
                          GestureDetector(
                              onTap: () {
                                print(
                                  '${EndPoints.printInvoice}' +
                                      '${invoice?.id.toString() ?? ""}',
                                );
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return PdfViewerPage(
                                      baseUrl: '${EndPoints.printInvoice}' +
                                          '${invoice?.id.toString() ?? ""}',
                                    );
                                    // return PaymentWebViewScreen(url: "",);
                                  },
                                ));
                              },
                              child: SvgPicture.asset(
                                ImageAssets.printIcon,
                              )),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
