

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_sale/core/remote/service.dart';
import '../../../core/models/get_pickings_model.dart';
import 'exchange_permission_state.dart';

class ExchangePermissionCubit extends Cubit<ExchangePermissionState> {
  ExchangePermissionCubit(this.api) : super(ExchangePermissionInitial());
  ServiceApi api;
  TextEditingController searchController = TextEditingController();
  GetPickingsModel? getPickingsModel;
  void getExchangePermission() async {
    emit(GetExchangePermissionLoadingState());
    final result = await api.getPicking();
    result.fold(
          (failure) =>
          emit(GetExchangePermissionErrorState()),
          (r) {
            getPickingsModel = r;
        emit(GetExchangePermissionLoadedState());
      },
    );
  }
}
