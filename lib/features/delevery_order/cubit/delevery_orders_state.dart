abstract class DeleveryOrdersState {}

class DeleveryOrdersInitial extends DeleveryOrdersState {}

class DeleveryOrdersIndexChanged extends DeleveryOrdersState {

  DeleveryOrdersIndexChanged();
}
class OrdersLoadingState extends DeleveryOrdersState {}
class OrdersLoadedState extends DeleveryOrdersState {}
class OrdersErrorState extends DeleveryOrdersState {
  String error;
  OrdersErrorState(this.error);
}
