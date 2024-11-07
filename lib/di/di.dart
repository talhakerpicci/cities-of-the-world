import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../core/constants/app_constants.dart';
import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await _initHive();
  await getIt.init();
}

Future<void> _initHive() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;
}

@module
abstract class AppModule {
  @lazySingleton
  Dio get dio => Dio(
        BaseOptions(
          baseUrl: AppConstants.baseUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
        ),
      )..interceptors.add(
          LogInterceptor(
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: true,
          ),
        );

  @preResolve
  @lazySingleton
  @Named('citiesBox')
  Future<Box<Map<String, dynamic>>> get citiesBox async {
    return Hive.box<Map<String, dynamic>>(name: AppConstants.citiesBoxName);
  }

  @preResolve
  @lazySingleton
  @Named('searchHistoryBox')
  Future<Box<Map<String, dynamic>>> get searchHistoryBox async {
    return Hive.box<Map<String, dynamic>>(name: AppConstants.searchHistoryBoxName);
  }
}
