import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/search_history_model.dart';
import '../../cubits/cities/cities_cubit.dart';

class SearchHistoryChipWidget extends StatelessWidget {
  const SearchHistoryChipWidget({
    super.key,
    required this.history,
  });

  final SearchHistoryModel history;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      avatar: const Icon(Icons.history, size: 16),
      label: Text(history.query),
      onPressed: () {
        context.read<CitiesCubit>().searchCities(history.query);
      },
      onDeleted: () {
        context.read<CitiesCubit>().removeSearchHistoryItem(history.query);
      },
      deleteIcon: const Icon(Icons.close, size: 16),
      tooltip: 'Search "${history.query}" again',
    );
  }
}
