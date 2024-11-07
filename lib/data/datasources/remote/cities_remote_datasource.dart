import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/exceptions.dart';
import '../../../domain/models/city_model.dart';

@injectable
class CitiesRemoteDataSource {
  CitiesRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<CityModel>> getCities({
    required int page,
    String? searchQuery,
  }) async {
    try {
      final response = await _dio.get(
        '/city',
        queryParameters: {
          'page': page,
          'include': 'country',
          if (searchQuery != null) 'filter[0][name][contains]': searchQuery,
        },
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final items = (data['items'] as List).map((item) => CityModel.fromJson(item as Map<String, dynamic>)).toList();

      return items;
    } on DioException catch (e) {
      throw CityException(CityException.mapDioError(e));
    } catch (e) {
      throw CityException('An unexpected error occurred');
    }
  }
}
