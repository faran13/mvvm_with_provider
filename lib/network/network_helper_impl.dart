import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mvvm_with_provider/core/failure.dart';

import 'network_helper.dart';

class NetworkHelperImpl extends NetworkHelper {
  @override
  Future<Either<String, Failure>> get(String url, {Map headers}) async {
    try {
      final response = await http.get(
        url,
        headers: appendHeader(
          headers: headers,
        ),
      );
      return handleResponse(response);
    } catch (e) {
      return Right(
        Failure(),
      );
    }
  }

  @override
  Future<Either<String, Failure>> post(
    String url, {
    Map headers,
    body,
    encoding,
    bool modifyHeader = true,
    bool encodeBody = true,
  }) async {
    try {
      final response = await http.post(
        url,
        body: encodeBody ? json.encode(body) : body,
        headers: modifyHeader ? appendHeader(headers: headers) : headers,
        encoding: encoding,
      );
      return handleResponse(response);
    } catch (e) {
      return Right(
        Failure(),
      );
    }
  }

  @override
  Either<String, Failure> handleResponse(http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode >= 400) {
      Map errorJson = jsonDecode(response.body.toString());
      return Right(
        Failure(),
      );
    } else {
      return Left(response.body.toString());
    }
  }

  @override
  Future<Either<String, Failure>> delete(String url, {Map headers}) async {
    return http
        .delete(url, headers: appendHeader(headers: headers))
        .then((http.Response response) {
      return handleResponse(response);
    });
  }

  @override
  Future<Either<String, Failure>> put(String url,
      {Map headers, body, encoding}) async {
    return http
        .put(url,
            body: json.encode(body),
            headers: appendHeader(headers: headers),
            encoding: encoding)
        .then(
      (http.Response response) {
        return handleResponse(response);
      },
    );
  }

  @override
  Map appendHeader({Map headers, bool refresh = false}) {
    try {
      if (headers == null) {
        headers = <String, String>{};
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return headers;
  }
}
