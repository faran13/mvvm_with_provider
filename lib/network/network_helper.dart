import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:mvvm_with_provider/core/failure.dart';

abstract class NetworkHelper {
  Future<Either<String, Failure>> get(String url, {Map headers});

  Future<Either<String, Failure>> post(String url,
      {Map headers, body, encoding});

  Future<Either<String, Failure>> delete(String url, {Map headers});

  Future<Either<String, Failure>> put(String url,
      {Map headers, body, encoding});

  Map appendHeader({Map headers});

  Either<String, Failure> handleResponse(http.Response response);
}
