abstract class BasketState {}

class InitBasketState extends BasketState {}
class LoadingGetWareHouses extends BasketState {}
class SuccessGetWareHouses extends BasketState {}
class ErrorGetWareHouses extends BasketState {}
class ChangeIsGift extends BasketState {}
class UpdateProfileImagePicked extends BasketState {}
class UpdateProfileError extends BasketState {}
class FileRemovedSuccessfully extends BasketState {}
class AddOrRemoveUser extends BasketState {}
