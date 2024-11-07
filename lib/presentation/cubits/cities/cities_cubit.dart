import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/debouncer.dart';
import '../../../domain/models/city_model.dart';
import '../../../domain/models/search_history_model.dart';
import '../../../domain/repositories/cities_repository.dart';

part 'cities_cubit.freezed.dart';
part 'cities_state.dart';

@injectable
class CitiesCubit extends Cubit<CitiesState> {
  final CitiesRepository _repository;
  final Debouncer _searchDebouncer;

  CitiesCubit(
    this._repository,
  )   : _searchDebouncer = Debouncer(
          duration: AppConstants.searchDebounceTime,
        ),
        super(CitiesState.initial()) {
    _loadSearchHistory();
  }

  @override
  Future<void> close() {
    _searchDebouncer.dispose();
    return super.close();
  }

  Future<void> loadCities() async {
    if (state.isLoading) return;

    emit(state.copyWith(
      isLoading: true,
      error: null,
    ));

    try {
      final cities = await _repository.getCities(
        page: 1,
        searchQuery: state.searchQuery.isEmpty ? null : state.searchQuery,
      );

      emit(state.copyWith(
        cities: cities,
        isLoading: false,
        currentPage: 1,
        hasReachedMax: cities.isEmpty,
      ));

      if (state.searchQuery.isNotEmpty) {
        _loadSearchHistory();
      }
    } on CityException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.message,
      ));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || state.hasReachedMax) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextPage = state.currentPage + 1;
      final moreCities = await _repository.getCities(
        page: nextPage,
        searchQuery: state.searchQuery.isEmpty ? null : state.searchQuery,
      );

      if (moreCities.isEmpty) {
        emit(state.copyWith(
          isLoadingMore: false,
          hasReachedMax: true,
        ));
      } else {
        emit(state.copyWith(
          cities: [...state.cities, ...moreCities],
          currentPage: nextPage,
          isLoadingMore: false,
        ));
      }
    } on CityException catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        error: e.message,
      ));
    }
  }

  void searchCities(String query) {
    if (query == state.searchQuery) return;

    _searchDebouncer.run(() {
      emit(state.copyWith(
        searchQuery: query,
        currentPage: 1,
        cities: [],
        hasReachedMax: false,
      ));

      loadCities();
    });
  }

  void _loadSearchHistory() {
    final history = _repository.getSearchHistory();
    emit(state.copyWith(searchHistory: history));
  }

  void updateSearchField(String text) {
    searchCities(text);
    emit(state.copyWith(searchQuery: text));
  }

  void toggleViewMode() {
    emit(state.copyWith(
      viewMode: state.viewMode == ViewMode.list ? ViewMode.map : ViewMode.list,
    ));
  }

  void removeSearchHistoryItem(String query) {
    _repository.removeSearchHistoryItem(query);
    _loadSearchHistory();
  }
}
