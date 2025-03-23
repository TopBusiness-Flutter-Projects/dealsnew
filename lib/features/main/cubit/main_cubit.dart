import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_sale/features/attendance_and_departure/cubit/attendance_and_departure_cubit.dart';
import 'package:top_sale/features/home_screen/cubit/cubit.dart';
import '../../../core/remote/service.dart';
import '../../attendance_and_departure/screens/attendance_and_departure_screen.dart';
import '../../clients/cubit/clients_cubit.dart';
import '../../clients/screens/clients_screen.dart';
import '../../home_screen/screens/home_screen.dart';
import 'main_states.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit(this.api) : super(MainInitialState());
  ServiceApi api;

  int currentIndex = 0;

  List<Widget> navigationBarViews = [
    const HomeScreen(),
    ClientScreen(clientsRouteEnum: ClientsRouteEnum.cart),
     AttendanceAndDepartureScreen(),
    const SizedBox()
  ];
  void getHomePage() {
    currentIndex = 0;
  }

  void changeNavigationBar(int index) {
    currentIndex = index;
    emit(AppNavBarChangeState());
  }
}
