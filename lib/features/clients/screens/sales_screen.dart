import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_sale/features/clients/cubit/clients_state.dart';
import 'package:top_sale/features/clients/screens/widgets/widgets_sales/custom_sales_card.dart';
import '../../../core/utils/assets_manager.dart';
import '../../../core/utils/get_size.dart';
import '../cubit/clients_cubit.dart';import 'package:top_sale/core/utils/circle_progress.dart';


class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();

}

class _SalesScreenState extends State<SalesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    // context.read<ClientsCubit>().getParent();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientsCubit, ClientsState>(
        builder: (context, state)
    {
      var cubit = context.read<ClientsCubit>();
    return  SafeArea(
      child:   state is ProfileClientLoading?
        const Center(
        child:
        CustomLoadingIndicator(),
      ):Scaffold(
        body: SingleChildScrollView(
          child: Column(
                children:[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(ImageAssets.arrowAr)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("sales".tr(), style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),),
                      )
          
                    ],),
                  ),
                  (  cubit.partnerModel!.salesOrders!.isEmpty)
                      ? Center(
                    child: Text(
                      "no_data".tr(),
                      style: const TextStyle(color: Colors.orange),
                    ),
                  )
                      :
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: cubit.partnerModel?.salesOrders?.length, // Number of last orders
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(getSize(context) / 50),
                        child: CustomSlalesCard(salesOrder: cubit.partnerModel?.salesOrders?[index],)
                      );
                    },
                  ),
                ]
            ),
        ),
      ),
    );
    });
  }
}
