import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/cities/cities_cubit.dart';
import 'search_history_chip_widget.dart';

class SearchHistoryListWidget extends StatelessWidget {
  const SearchHistoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CitiesCubit, CitiesState>(
      bloc: BlocProvider.of<CitiesCubit>(context),
      buildWhen: (previous, current) => previous.searchHistory != current.searchHistory,
      builder: (context, state) {
        if (state.searchHistory.isEmpty) {
          return const SizedBox();
        }

        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.searchHistory.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final history = state.searchHistory[index];
              return SearchHistoryChipWidget(history: history);
            },
          ),
        );
      },
    );
  }
}
