abstract class DetailsOrdersState {}

class DetailsOrdersInitial extends DetailsOrdersState {}

class GetDetailsOrdersLoadedState extends DetailsOrdersState {}

class GetDetailsOrdersLoadingState extends DetailsOrdersState {}

class GetDetailsOrdersErrorState extends DetailsOrdersState {
  String error;
  GetDetailsOrdersErrorState(this.error);
}

class ConfirmDeliveryLoadedState extends DetailsOrdersState {}

class ConfirmDeliveryLoadingState extends DetailsOrdersState {}

class ConfirmDeliveryErrorState extends DetailsOrdersState {
  String error;
  ConfirmDeliveryErrorState(this.error);
}

class CreateAndValidateInvoiceLoadedState extends DetailsOrdersState {}

class CreateAndValidateInvoiceLoadingState extends DetailsOrdersState {}

class CreateAndValidateInvoiceErrorState extends DetailsOrdersState {
  String error;
  CreateAndValidateInvoiceErrorState(this.error);
}

class GetAllJournalsLoadedState extends DetailsOrdersState {}

class GetAllJournalsLoadingState extends DetailsOrdersState {}

class GetAllJournalsErrorState extends DetailsOrdersState {
  String error;
  GetAllJournalsErrorState(this.error);
}

class RegisterPaymentLoadedState extends DetailsOrdersState {}

class RegisterPaymentLoadingState extends DetailsOrdersState {}

class RegisterPaymentErrorState extends DetailsOrdersState {
  String error;
  RegisterPaymentErrorState(this.error);
}

class RemoveItemFromOrderLineLoadedState extends DetailsOrdersState {}

class ClickBackState extends DetailsOrdersState {}

class LoadingTheQuantityCount extends DetailsOrdersState {}

class IncreaseTheQuantityCount extends DetailsOrdersState {}

class DecreaseTheQuantityCount extends DetailsOrdersState {}

class LoadingUpdateQuotation extends DetailsOrdersState {}

class LoadedUpdateQuotation extends DetailsOrdersState {}

class ErrorUpdateQuotation extends DetailsOrdersState {}

class ChangePageState extends DetailsOrdersState {}

class LoadingConfirmQuotation extends DetailsOrdersState {}

class LoadedConfirmQuotation extends DetailsOrdersState {}

class ErrorConfirmQuotation extends DetailsOrdersState {}

class OnChangeUnitPriceOfItem extends DetailsOrdersState {}

class GetLatLongSuccess extends DetailsOrdersState {}

class ScreenshootState extends DetailsOrdersState {}

class LoadedCancel extends DetailsOrdersState {}

class ErrorCancel extends DetailsOrdersState {}

class LoadingCancel extends DetailsOrdersState {}

class OnChangeAllUnitPriceOfItem extends DetailsOrdersState {}

class LoadingUpdateDleiery extends DetailsOrdersState {}

class FailureUpdateDleiery extends DetailsOrdersState {}

class SuccessUpdateDleiery extends DetailsOrdersState {}
class FileRemovedSuccessfully extends DetailsOrdersState {}
class UpdateProfileImagePicked extends DetailsOrdersState {}
class UpdateProfileError extends DetailsOrdersState {}
class ChangeJournalStatee extends DetailsOrdersState {}
