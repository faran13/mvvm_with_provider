import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:mvvm_with_provider/core/failure.dart';
import 'package:mvvm_with_provider/core/success.dart';
import 'package:mvvm_with_provider/main_contract.dart';
import 'package:mvvm_with_provider/models/mock_response.dart';
import 'package:mvvm_with_provider/network/api_end_points.dart';
import 'package:mvvm_with_provider/network/network_helper.dart';
import 'package:mvvm_with_provider/network/network_helper_impl.dart';

class ViewModel extends ChangeNotifier {
  MockResponse _mockResponse;
  MainPageView _mainPageView;
  bool _isDataLoaded = false;
  NetworkHelper _networkHelper = NetworkHelperImpl();
  
  ViewModel({MockResponse mockResponse}){
    this._mockResponse = mockResponse;
  }

  void init({MainPageView mainPageView}){
    _isDataLoaded = false;
    this._mainPageView = mainPageView;
  }

  List<ViewModel> _viewModels = [];

  Future<Either<Success, Failure>> getAllUsers() async {
    _viewModels = [];
    try {
      _mainPageView.showLoading();
      notifyListeners();
      final either = await _networkHelper.get(
        APIEndpoints.getAllUsers,
      );
      either.fold(
        (success) {
          final response = jsonDecode(success);
          if (response != null) {
            response.forEach(
              (v) {
                _viewModels.add(ViewModel(mockResponse: MockResponse.fromJson(v)));
              },
            );
            _isDataLoaded = true;
          }
          notifyListeners();
          _mainPageView.hideLoading();
          return Left(Success());
        },
        (error) {
          _mainPageView.hideLoading();
          return Right(Failure());
        },
      );
    } catch (e) {
      _mainPageView.hideLoading();
      return Right(Failure());
    }
  }
  
  List<ViewModel> getAllData() => this._viewModels;

  MockResponse getSingleResponse() => this._mockResponse;
  
  bool getIsDataLoaded() => this._isDataLoaded;

  void setIsDataLoaded({bool value}){
    this._isDataLoaded = value;
    notifyListeners();
  }
}
