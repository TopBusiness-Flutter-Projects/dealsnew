

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_sale/core/models/returned_order_model.dart';
import 'package:top_sale/core/remote/service.dart';
import 'package:top_sale/features/returns/cubit/returns_state.dart';

class ReturnsCubit extends Cubit<ReturnsState> {
  ReturnsCubit(this.api) : super(ReturnsInitial());
  ServiceApi api;
  TextEditingController searchController = TextEditingController();
  ReturnedOrderModel? returnOrderModel;
  void getReturned() async {
    emit(GetReturnedLoadingState());
    final result = await api.returnedOrder();
    result.fold(
          (failure) =>
          emit(GetReturnedErrorState()),
          (r) {
            returnOrderModel = r;
        emit(GetReturnedLoadedState());
      },
    );
  }
}
