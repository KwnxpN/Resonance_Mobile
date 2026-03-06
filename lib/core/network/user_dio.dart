import 'package:dio/dio.dart';
import 'package:flutter_project/core/network/base_dio_factory.dart';

class UserDio {
  static Dio create() {
    return BaseDioFactory.create('http://10.0.2.2:9091', attachToken: true);
  }
}
