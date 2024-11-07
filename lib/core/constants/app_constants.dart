class AppConstants {
  static const baseUrl = 'http://connect-demo.mobile1.io/square1/connect/v1';
  static const searchDebounceTime = Duration(milliseconds: 500);

  // Hive box names
  static const citiesBoxName = 'cities_box';
  static const searchHistoryBoxName = 'search_history_box';

  // Cache keys
  static String getCitiesCacheKey(String query, int page) => '${query.isEmpty ? "all" : query}:$page';
}
