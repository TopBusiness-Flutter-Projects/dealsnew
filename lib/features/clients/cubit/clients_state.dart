import '../../../core/models/all_partners_for_reports_model.dart';

abstract class ClientsState {}

class ClientsInitial extends ClientsState {}

class ErrorGetPartnersState extends ClientsState {}

class LoadingGetPartnersState extends ClientsState {}

class LoadingMorePartnersState extends ClientsState {}
class UpdateClientType extends ClientsState {}
class SucessGetPartnersState extends ClientsState {
  GetAllPartnersModel? allPartnersModel;
  SucessGetPartnersState({required this.allPartnersModel});
}
//create client
class CreateClientLoading extends ClientsState {}
class CreateClientLoaded extends ClientsState {}
class CreateClientError extends ClientsState {}
//get from search
class SearchLoading extends ClientsState {}
class SearchLoaded extends ClientsState {}
class SearchError extends ClientsState {
  String ?error;
  SearchError({required this.error});
}
//get client profile
class ProfileClientLoading extends ClientsState {}
class ProfileClientLoaded extends ClientsState {}
class ProfileClientError extends ClientsState {}
//lat,long
class GetCurrentLocationState extends ClientsState {}
class ErrorCurrentLocationAddressState extends ClientsState {}
class GetCurrentLocationAddressState extends ClientsState {}
class UpdateProfileUserLoaded extends ClientsState {}
class UpdateProfileUserError extends ClientsState {}
class UpdateProfileUserLoading extends ClientsState {}
class UpdateProfileError extends ClientsState {}
class UpdateProfileImagePicked extends ClientsState {}
class DisposeMapState extends ClientsState {}
class FailGetCarId extends ClientsState {}
class SuccessGetCarId extends ClientsState {}
class UpdateFilters extends ClientsState {}
class FileRemovedSuccessfully extends ClientsState {}

