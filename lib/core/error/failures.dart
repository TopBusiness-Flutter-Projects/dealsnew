import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  final String? message;

  ServerFailure({ this.message});

  @override
  List<Object?> get props => [message];
}
class CacheFailure extends Failure {}
// abstract class Failure {
//   final String? message;

//   Failure({this.message});
// }
// class ServerFailure extends Failure {
//   // ServerFailure(super.message);
// ServerFailure({super.message});
//   factory ServerFailure.fromDiorError(DioError e) {
//     switch (e.type) {
//       case DioErrorType.connectionTimeout:
//         return ServerFailure(message: 'Connection timeout with api server');

//       case DioErrorType.sendTimeout:
//         return ServerFailure(message:'Send timeout with ApiServer');
//       case DioErrorType.receiveTimeout:
//         return ServerFailure(message:'Receive timeout with ApiServer');
//       case DioErrorType.badCertificate:
//         return ServerFailure(message:'badCertificate with api server');
//       case DioErrorType.badResponse:
//         return ServerFailure.fromResponse(
//             e.response!.statusCode!, e.response!.data);
//       case DioErrorType.cancel:
//         return ServerFailure(message:'Request to ApiServer was canceld');
//       case DioErrorType.connectionError:
//         return ServerFailure(message:'No Internet Connection');
//       case DioErrorType.unknown:
//         return ServerFailure(message:'Opps There was an Error, Please try again');
//     }
//   }

//   factory ServerFailure.fromResponse(int statusCode, dynamic response) {
//     if (statusCode == 404) {
//       return ServerFailure(message:'Your request was not found, please try later');
//     } else if (statusCode == 500) {
//       return ServerFailure(message:'There is a problem with server, please try later');
//     } else if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
//       return ServerFailure(message:response['error']['message']);
//     } else {
//       return ServerFailure(message:'There was an error , please try again');
//     }
//   }
// }
// class CacheFailure extends Failure {
//   CacheFailure({super.message});
// }