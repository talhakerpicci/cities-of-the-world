import '../models/city_model.dart';
import '../models/search_history_model.dart';

abstract class CitiesRepository {
  Future<List<CityModel>> getCities({
    required int page,
    String? searchQuery,
  });

  List<SearchHistoryModel> getSearchHistory();

  void removeSearchHistoryItem(String query);
}
