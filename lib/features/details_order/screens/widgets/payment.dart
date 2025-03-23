import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:top_sale/features/details_order/screens/widgets/payment_option.dart';
import 'package:top_sale/features/details_order/screens/widgets/shard_appbar_app.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.isReturn});
  final bool isReturn;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SharedAppBarApp(title: "payment".tr()),
             Padding(
              padding: EdgeInsets.all(8.0),
              child: PaymentOptions(isReturn: isReturn),

              ),
           
          ],
        ),

      ),
    );
  }
}


