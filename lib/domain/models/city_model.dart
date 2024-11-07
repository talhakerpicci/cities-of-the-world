import 'package:freezed_annotation/freezed_annotation.dart';

import 'country_model.dart';

part 'city_model.freezed.dart';
part 'city_model.g.dart';

@freezed
class CityModel with _$CityModel {
  const CityModel._();

  const factory CityModel({
    required int id,
    required String name,
    @JsonKey(name: 'local_name') required String localName,
    @JsonKey(name: 'lat') required double? latitude,
    @JsonKey(name: 'lng') required double? longitude,
    required CountryModel country,
  }) = _CityModel;

  factory CityModel.fromJson(Map<String, dynamic> json) => _$CityModelFromJson(json);
}
