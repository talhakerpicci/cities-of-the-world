import 'package:cities_of_the_world/domain/models/city_model.dart';
import 'package:cities_of_the_world/domain/models/search_history_model.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/exceptions.dart';
import '../../domain/repositories/cities_repository.dart';
import '../datasources/local/cities_local_datasource.dart';
import '../datasources/remote/cities_remote_datasource.dart';

@Injectable(as: CitiesRepository)
class CitiesRepositoryImpl implements CitiesRepository {
  CitiesRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  final CitiesRemoteDataSource _remoteDataSource;
  final CitiesLocalDataSource _localDataSource;

  @override
  Future<List<CityModel>> getCities({
    required int page,
    String? searchQuery,
  }) async {
    try {
      final cachedCities = await _localDataSource.getCachedCities(
        searchQuery ?? '',
        page,
      );

      if (cachedCities != null) {
        return cachedCities;
      }

      final cities = await _remoteDataSource.getCities(
        page: page,
        searchQuery: searchQuery,
      );

      await _localDataSource.cacheCities(searchQuery ?? '', page, cities);

      return cities;
    } on CityException {
      rethrow;
    } catch (e) {
      throw CityException('An unexpected error occurred');
    }
  }

  @override
  List<SearchHistoryModel> getSearchHistory() {
    return _localDataSource.getSearchHistory();
  }

  @override
  void removeSearchHistoryItem(String query) {
    _localDataSource.removeSearchHistoryItem(query);
  }
}
