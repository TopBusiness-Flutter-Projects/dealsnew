import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_sale/core/preferences/preferences.dart';
import 'package:top_sale/core/remote/service.dart';
import '../../../core/models/get_orders_model.dart';
import '../../../core/models/partner_model.dart';
import 'delevery_orders_state.dart';

class DeleveryOrdersCubit extends Cubit<DeleveryOrdersState> {
  DeleveryOrdersCubit(this.api) : super(DeleveryOrdersInitial());
  ServiceApi api;
  int currentIndex = 0;
  final List<String> items = [
    'all',
    "show_price",
    'new',
    'delivered',
  ];
  String selectedValue = "all";
  void changeIndex(int index) {
    currentIndex = index;
    emit(DeleveryOrdersIndexChanged());
  }

  void changeSelectedValue(String newValue) {
    selectedValue = newValue;
    emit(DeleveryOrdersIndexChanged());
  }

  List<OrderModel> completeOrders = []; 
  List<OrderModel> currentOrders = []; 
  List<OrderModel> draftOrders = [];
  List<OrderModel> newOrders = []; // pending 
  List<OrderModel> deliveredOrders = []; 
  List<OrderModel> canceledOrders = []; 
  GetOrdersModel getOrdersModel = GetOrdersModel();
  Future<void> getOrders() async {
    emit(OrdersLoadingState());
    completeOrders = []; 
    currentOrders = []; 
    draftOrders = []; 
    newOrders = []; 
    deliveredOrders = []; 
    canceledOrders = [];
    final result = await api.getOrders();
    result.fold(
      (failure) => emit(OrdersErrorState('Error loading  data: $failure')),
      (r) async {
        for (var element in r.result!) {
          // Completed orders contain only fully invoiced and fully delivered orders
          if (element.state.toString() == 'sale' &&
              element.invoiceStatus.toString() == 'invoiced' &&
              (element.deliveryStatus.toString() == 'full' ||
                  element.deliveryStatus.toString() == 'done')) {
            completeOrders.add(element);
          }
          // Canceled orders contain only canceled orders
          else if (element.state.toString() == 'cancel') {
            canceledOrders.add(element);
          }
          // Current orders include orders that are not completed or canceled
          else {
            currentOrders.add(element);

            // Draft orders
            if (element.state.toString() == 'draft') {
              draftOrders.add(element);
            }
            // New orders (to be invoiced, pending delivery)
            else if (element.state.toString() == 'sale' &&
                element.invoiceStatus.toString() == 'to invoice' &&
                (element.deliveryStatus.toString() == 'pending' ||
                    element.deliveryStatus.toString() == 'assigned')) {
              newOrders.add(element);
            }
            // Delivered orders (to be invoiced, fully delivered)
            else if (element.state.toString() == 'sale' &&
                element.invoiceStatus.toString() == 'to invoice' &&
                (element.deliveryStatus.toString() == 'full' ||
                    element.deliveryStatus.toString() == 'done')) {
              deliveredOrders.add(element);
            }
          }
        }

        getOrdersModel = r;

        print("model $getOrdersModel");
        emit(OrdersLoadedState());
      },
    );
  }

  GetOrdersModel getDraftOrdersModel = GetOrdersModel();
  Future<void> getDraftOrders() async {
    emit(OrdersLoadingState());
    print("rrrrrrrrrr");

    final result = await api.getDraftOrders();
    result.fold(
      (failure) => emit(OrdersErrorState('Error loading  data: $failure')),
      (r) async {
        if (r.result != null) {

          Preferences.instance.setAllOrders(r);
        }

        emit(OrdersLoadedState());
      },
    );
  }

  // Future<PartnerModel> getPartnerDetails({required int partnerId}) async {
  //   emit(OrdersLoadingState());
  //   PartnerModel? partnerModel;
  //   final result = await api.getPartnerDetails(partnerId: partnerId);
  //   result.fold(
  //     (failure) => emit(OrdersErrorState('Error loading  data: $failure')),
  //     (r) {
  //       partnerModel = r;
  //       print("model $getOrdersModel");
  //       emit(OrdersLoadedState());
  //     },
  //   );
  //   return partnerModel!;
  // }
}
