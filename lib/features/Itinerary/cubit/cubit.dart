// ignore_for_file: use_build_context_synchronously
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_sale/core/models/get_car_ids_model.dart';
import 'package:top_sale/core/preferences/preferences.dart';
import 'package:top_sale/core/remote/service.dart';
import '../../../core/models/car_details_model.dart';
import 'state.dart';

class ItineraryCubit extends Cubit<ItineraryState> {
  ItineraryCubit(this.api) : super(ItineraryInitial());
  ServiceApi api;
  GetCarIdsModel? getEmployeeDataModel;
  void getEmployeeData() async {
    emit(LoadingCheckEmployeeState());
    final result = await api.getEmployeeCarId();
    result.fold(
      (failure) => emit(FailureCheckEmployeeState()),
      (r) {
        getEmployeeDataModel = r;
        if (r.carIds!.isNotEmpty) {
          getCarDetails(r.carIds!.first.id);
        }

        emit(SuccessCheckEmployeeState());
      },
    );
  }

  bool isTracking = false;
  void changeTrackingState() {
    isTracking = !isTracking;
    emit(ChangeTrackingState());
  }

  Future<void> getInitialTrackingState() async {
    isTracking = await Preferences.instance.getIsInTrip();
    print("isTracking = $isTracking");
    emit(ChangeTrackingState());
  }

  CarDetails? carDetailsModel;
  void getCarDetails(int carId) async {
    emit(LoadingCheckEmployeeState());
    final result = await api.getCarDetails(carId: carId);
    result.fold(
      (failure) => emit(FailureCheckEmployeeState()),
      (r) {
        carDetailsModel = r;

        emit(SuccessCheckEmployeeState());
      },
    );
  }
}
