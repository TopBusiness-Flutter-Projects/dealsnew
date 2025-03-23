
 class CreateReceiptCoucherState {}

 class CreateReceiptCoucherInitial extends CreateReceiptCoucherState {}
 class GetAllJournalsLoadedState extends CreateReceiptCoucherState {}

 class GetAllJournalsLoadingState extends CreateReceiptCoucherState {}

 class GetAllJournalsErrorState extends CreateReceiptCoucherState {
  String error;
  GetAllJournalsErrorState(this.error);
 }
 class GetPaymentsLoaded extends CreateReceiptCoucherState {}
 class GetPaymentsLoading extends CreateReceiptCoucherState {}
 class GetPaymentsError extends CreateReceiptCoucherState {}
 class UpdateProfileError extends CreateReceiptCoucherState {}
 class UpdateProfileImagePicked extends CreateReceiptCoucherState {}
 class FileRemovedSuccessfully extends CreateReceiptCoucherState {}
