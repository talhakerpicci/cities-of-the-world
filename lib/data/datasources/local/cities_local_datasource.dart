import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/models/city_model.dart';
import '../../../domain/models/search_history_model.dart';

@injectable
class CitiesLocalDataSource {
  CitiesLocalDataSource(
    @Named('searchHistoryBox') this._searchHistoryBox,
    @Named('citiesBox') this._citiesBox,
  );

  final Box<Map<String, dynamic>> _searchHistoryBox;
  final Box<Map<String, dynamic>> _citiesBox;

  Future<void> cacheCities(String query, int page, List<CityModel> cities) async {
    final key = AppConstants.getCitiesCacheKey(query, page);
    _citiesBox.put(key, {
      'cities': cities.map((city) => city.toJson()).toList(),
    });

    if (query.isNotEmpty) {
      final historyJson = _searchHistoryBox.get(query);
      if (historyJson != null) {
        final history = SearchHistoryModel.fromJson(historyJson);

        _searchHistoryBox.put(
          query,
          history
              .copyWith(
                timestamp: DateTime.now(),
              )
              .toJson(),
        );
      } else {
        _searchHistoryBox.put(
          query,
          SearchHistoryModel(
            query: query,
            timestamp: DateTime.now(),
          ).toJson(),
        );
      }
    }
  }

  Future<List<CityModel>?> getCachedCities(String query, int page) async {
    final key = AppConstants.getCitiesCacheKey(query, page);
    final data = _citiesBox.get(key);
    if (data != null) {
      final citiesJson = (data['cities'] as List).cast<Map<String, dynamic>>();
      return citiesJson.map((json) => CityModel.fromJson(json)).toList();
    }
    return null;
  }

  List<SearchHistoryModel> getSearchHistory() {
    final List<SearchHistoryModel> histories = [];

    for (var key in _searchHistoryBox.keys) {
      final json = _searchHistoryBox.get(key);
      if (json != null) {
        histories.add(SearchHistoryModel.fromJson(json));
      }
    }

    histories.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return histories;
  }

  void removeSearchHistoryItem(String query) async {
    _searchHistoryBox.delete(query);

    final keysToDelete = _citiesBox.keys.where(
      (key) => key.toString().startsWith('$query:'),
    );

    for (final key in keysToDelete) {
      _citiesBox.delete(key);
    }
  }
}
