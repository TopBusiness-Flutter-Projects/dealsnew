import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/app_fonts.dart';
import 'package:top_sale/core/utils/circle_progress.dart';

import 'package:top_sale/core/widgets/decode_image.dart';
import 'package:top_sale/features/Itinerary/cubit/cubit.dart';
import 'package:top_sale/features/Itinerary/cubit/state.dart';
import 'package:top_sale/features/clients/cubit/clients_cubit.dart';
import 'package:top_sale/features/clients/cubit/clients_state.dart';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  @override
  void initState() {
    context.read<ItineraryCubit>().getEmployeeDataModel = null;
    context.read<ItineraryCubit>().getEmployeeData();
    super.initState();
  }

  @override
  void dispose() {
    // Dispose the controller if you have one
    // context.read<ClientsCubit>().mapController?.dispose();
    // context.read<ClientsCubit>().mapController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ItineraryCubit, ItineraryState>(
          builder: (context, state) {
        var cubit = context.read<ItineraryCubit>();
        var cubit2 = context.read<ClientsCubit>();
        return cubit.getEmployeeDataModel == null
            ? const Center(child: CustomLoadingIndicator())
            : cubit.getEmployeeDataModel!.carIds!.isEmpty
                // : cubit.getEmployeeDataModel!.carIds!.isEmpty
                ? Center(
                    child: Text(
                    "empty_car".tr(),
                    style: getMediumStyle(),
                  ))
                : Column(
                    children: [
                      Flexible(
                        child: BlocBuilder<ClientsCubit, ClientsState>(
                            builder: (context, state) {
                          return cubit2.currentLocation == null
                              ? SizedBox()
                              : GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      cubit2.currentLocation != null
                                          ? cubit2.currentLocation!.latitude!
                                          : 0,
                                      cubit2.currentLocation != null
                                          ? cubit2.currentLocation!.longitude!
                                          : 0,
                                    ),
                                    zoom: 17,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId:
                                          const MarkerId("currentLocation"),
                                      position: LatLng(
                                        cubit2.currentLocation != null
                                            ? cubit2.currentLocation!.latitude!
                                            : 0,
                                        cubit2.currentLocation != null
                                            ? cubit2.currentLocation!.longitude!
                                            : 0,
                                      ),
                                    ),
                                    // Rest of the markers...
                                  },
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    cubit2.mapController =
                                        controller; // Store the GoogleMapController
                                  },
                                  onTap: (argument) {
                                    // _customInfoWindowController.hideInfoWindow!();
                                  },
                                  onCameraMove: (position) {
                                    // if (cubit!.strartlocation != position.target) {
                                    //   print(cubit!.strartlocation);
                                    //   cubit!.strartlocation = position.target;
                                    //   // cubit!.getCurrentLocation();
                                    // }
                                    // _customInfoWindowController.hideInfoWindow!();
                                  },
                                );
                        }),
                      ),
                      if (cubit.carDetailsModel != null)
                        ToggleSwitchWithLabel(),
                    ],
                  );
      }),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("itinerary".tr()),
        centerTitle: false,
        // leading:
        // GestureDetector(
        //   onTap: (){
        //     Navigator.pop(context);
        //     context.read<ClientsCubit>().mapController = null;
        //   },
        //
        //     child: Icon(Icons.arrow_back)),
        titleTextStyle: getBoldStyle(fontSize: 20.sp),
      ),
    );
  }
}

class ToggleSwitchWithLabel extends StatefulWidget {
  @override
  _ToggleSwitchWithLabelState createState() => _ToggleSwitchWithLabelState();
}

class _ToggleSwitchWithLabelState extends State<ToggleSwitchWithLabel> {
  // bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItineraryCubit, ItineraryState>(
        builder: (context, state) {
      var cubit = context.read<ItineraryCubit>();
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomDecodedImage(
                      base64String: cubit.carDetailsModel!.image128,
                      // context: context,
                      height: 50,
                      width: 50,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Flexible(
                      child: Text(
                        cubit.carDetailsModel!.name.toString(),
                        style: TextStyle(
                            color: AppColors.secondry,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.h), // Space between text and switch
              Column(
                children: [
                  Text(
                    cubit.isTracking
                        ?  "end_itinerary".tr()
                        : "start_itinerary".tr(), 
                    style: TextStyle(
                      fontSize: 18.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CupertinoSwitch(
                    value: cubit.isTracking,
                    onChanged: (value) {
                      if (value) {
                        context
                            .read<ClientsCubit>()
                            .startLocationUpdates(context);
                      } else {
                        context
                            .read<ClientsCubit>()
                            .stopLocationUpdates(context);
                      }

                      cubit.changeTrackingState();
                    },
                    activeColor: AppColors.secondry,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
