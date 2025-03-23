import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_sale/core/models/all_partners_for_reports_model.dart';
import 'package:top_sale/core/models/all_ware_house_model.dart';
import 'package:top_sale/core/models/get_all_users_model.dart';
import 'package:top_sale/core/remote/service.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/app_fonts.dart';

import 'state.dart';

class BasketCubit extends Cubit<BasketState> {
  BasketCubit(this.api) : super(InitBasketState());
  ServiceApi api;
  int? selectedFromWareHouseId;
  int? selectedToWareHouseId;
  AllWareHouseModel? getWareHousesModel;
  Future<void> getWareHouses() async {
    emit(LoadingGetWareHouses());
    final response = await api.getWareHouses();
    response.fold((l) {
      emit(ErrorGetWareHouses());
    }, (right) async {
      getWareHousesModel = right;
      if (right.result!.isNotEmpty) {
        selectedFromWareHouseId = right.result!.first.id;
      }
      emit(SuccessGetWareHouses());
    });
  }
  // int? selectedToWareHouseId;

  GeyAllUsersModel? getAllUsersModel;
    List<UserModel> selectedUsers = [];
    void addOrRemoveUser(UserModel userModel){
      if(selectedUsers.contains(userModel)){
        selectedUsers.remove(userModel);
      }else{
        selectedUsers.add(userModel);
      }
      emit(AddOrRemoveUser());
    }
  void getAllUsers() async {
    emit(LoadingGetWareHouses());
    final response = await api.getAllUsers();
    response.fold((l) {
      emit(ErrorGetWareHouses());
    }, (right) async {
      getAllUsersModel = right;     
      emit(SuccessGetWareHouses());
    });
  }



  WareHouse? myWareHouse;
  Future<void> getMyWareHouse() async {
    emit(LoadingGetWareHouses());
    final response = await api.getWareHouseById();
    response.fold((l) {
      emit(ErrorGetWareHouses());
    }, (right) async {
      myWareHouse = right;
      selectedToWareHouseId = right.id;

      emit(SuccessGetWareHouses());
    });
  }

  bool isGiftt = false;
  changeIsGift(bool isGift) {
    isGiftt = isGift;
    emit(ChangeIsGift());
  }

  AllPartnerResults? partner;
  setPartner(AllPartnerResults? partner) {
    this.partner = partner;
    if (myWareHouse != null && partner != null) {

      selectedFromWareHouseId = myWareHouse?.id;
    }
    emit(ChangeIsGift());
  }
  
  File? profileImage;
  String selectedBase64String = "";
  removeImage() {
    profileImage = null;
    emit(FileRemovedSuccessfully());
  }

  void showImageSourceDialog(
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'select_image'.tr(),
            style: getMediumStyle(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                pickFile(context, true);
              },
              child: Text(
                'gallery'.tr(),
                style:
                    getRegularStyle(fontSize: 12.sp, color: AppColors.primary),
              ),
            ),
            TextButton(
              onPressed: () async {
                pickImage(context, false);
            
              },
              child: Text(
                "camera".tr(),
                style:
                    getRegularStyle(fontSize: 12.sp, color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  Future pickImage(BuildContext context, bool isGallery) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        maxWidth: 1024,
        maxHeight: 1024,
        source: isGallery ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      selectedBase64String = await fileToBase64String(pickedFile.path);
      emit(UpdateProfileImagePicked()); // Emit state for image picked
      Navigator.pop(context);
    } else {
      emit(UpdateProfileError());
    }
  }

  Future pickFile(BuildContext context, bool isGallery) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickMedia();
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      selectedBase64String = await fileToBase64String(pickedFile.path);
      emit(UpdateProfileImagePicked()); // Emit state for image picked
      Navigator.pop(context);
    } else {
      emit(UpdateProfileError());
    }
  }

  //photo transfer
  Future<String> fileToBase64String(String filePath) async {
    File file = File(filePath);
    Uint8List bytes = await file.readAsBytes();
    String base64String = base64Encode(bytes);
    return base64String;
  }


}
