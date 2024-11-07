part of 'cities_cubit.dart';

enum ViewMode { list, map }

@freezed
class CitiesState with _$CitiesState {
  const factory CitiesState({
    required List<CityModel> cities,
    required bool isLoading,
    required bool isLoadingMore,
    required bool hasReachedMax,
    required int currentPage,
    required String searchQuery,
    required ViewMode viewMode,
    @Default([]) List<SearchHistoryModel> searchHistory,
    String? error,
  }) = _CitiesState;

  factory CitiesState.initial() => const CitiesState(
        cities: [],
        isLoading: false,
        isLoadingMore: false,
        hasReachedMax: false,
        currentPage: 1,
        searchQuery: '',
        viewMode: ViewMode.list,
        error: null,
      );
}
