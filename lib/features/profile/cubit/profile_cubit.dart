import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_sale/core/remote/service.dart';
import 'package:top_sale/features/profile/cubit/profile_state.dart';
import 'package:top_sale/features/update_profile/cubit/update_profile_state.dart';

import '../../../core/models/get_employee_data_model.dart';
import '../../../core/models/get_user_data_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.api) : super(ProfileInitial());
  ServiceApi api;
  TextEditingController  nameController=TextEditingController();
  TextEditingController  phoneController=TextEditingController();
  GetUserDataModel ?getUserDataModel;
  //get  userdata
void getUserData() async {
  emit(ProfileUserLoading());
  final result = await api.getUserData();
  result.fold(
    (failure) =>
        emit(ProfileUserLoaded(error: 'Error loading data: $failure')),
    (r) {
      getUserDataModel = r;
      debugPrint("the model : ${getUserDataModel?.email.toString()}");
      emit(ProfileUserError());
    },
  );
}
//get empolyee data
  GetEmployeeDataModel?getEmployeeDataModel;
  void getEmployeeData() async {
    emit(ProfileEmployeeLoading());
    final result = await api.getEmployeeData();
    result.fold(
          (failure) =>
          emit(ProfileEmployeeLoaded(error: 'Error loading data: $failure')),
          (r) {
        getEmployeeDataModel = r;
        debugPrint("the model : ${getUserDataModel?.name.toString()}");
        emit(ProfileEmployeeError());
      },
    );
  }
}
