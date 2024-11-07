import 'package:freezed_annotation/freezed_annotation.dart';

import 'city_model.dart';

part 'search_history_model.freezed.dart';
part 'search_history_model.g.dart';

@freezed
class SearchHistoryModel with _$SearchHistoryModel {
  const SearchHistoryModel._();

  const factory SearchHistoryModel({
    required String query,
    required DateTime timestamp,
    required Map<int, List<CityModel>> cachedPages,
  }) = _SearchHistoryModel;

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) => SearchHistoryModel.fromCustomJson(json);

  factory SearchHistoryModel.fromCustomJson(Map<String, dynamic> json) {
    return SearchHistoryModel(
      query: json['query'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      cachedPages: (json['cachedPages'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          int.parse(key),
          (value as List).cast<Map<String, dynamic>>().map((cityJson) => CityModel.fromJson(cityJson)).toList(),
        ),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'timestamp': timestamp.toIso8601String(),
      'cachedPages': cachedPages.map(
        (key, value) => MapEntry(
          key.toString(),
          value.map((city) => city.toJson()).toList(),
        ),
      ),
    };
  }
}
