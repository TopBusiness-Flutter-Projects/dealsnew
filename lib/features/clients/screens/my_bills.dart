import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_sale/core/utils/assets_manager.dart';
import 'package:top_sale/features/clients/screens/widgets/widgets_bills/custom_bill_container.dart';
import '../cubit/clients_cubit.dart';import 'package:top_sale/core/utils/circle_progress.dart';

import '../cubit/clients_state.dart';

class MyBillsScreen extends StatefulWidget {
  const MyBillsScreen({super.key});

  @override
  State<MyBillsScreen> createState() => _MyBillsScreenState();
}

class _MyBillsScreenState extends State<MyBillsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    // context.read<ClientsCubit>().getParent();
    print("nehal");
    print(
        context.read<ClientsCubit>().partnerModel?.invoices?.length.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientsCubit, ClientsState>(builder: (context, state) {
      var cubit = context.read<ClientsCubit>();

      return SafeArea(
        child: Scaffold(
            //appBar: AppBar(leading: Text("Invoices",style:TextStyle(color:AppColors.primary)),),
            body: state is ProfileClientLoading
                ? Center(
                    child: CustomLoadingIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Image.asset(ImageAssets.arrowAr)),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "invoices".tr(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        ),
                        (cubit.partnerModel!.invoices!.isEmpty)
                            ? Center(
                                child: Text(
                                  "no_data".tr(),
                                  style: TextStyle(color: Colors.orange),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: cubit.partnerModel?.invoices?.length,
                                itemBuilder: (context, index) {
                                  return CustomBillContainer(
                                    isCurrent: false,
                                    invoice:
                                        cubit.partnerModel?.invoices![index],
                                  );
                                })
                      ],
                    ),
                  )),
      );
    });
  }
}
