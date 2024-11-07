import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/di.dart';
import '../cubits/cities/cities_cubit.dart';
import 'cities_content.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/search_history_list_widget.dart';

class CitiesPage extends StatelessWidget {
  const CitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CitiesCubit>()..loadCities(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cities of the World'),
          actions: [
            BlocBuilder<CitiesCubit, CitiesState>(
              buildWhen: (previous, current) => previous.viewMode != current.viewMode,
              builder: (context, state) {
                return IconButton(
                  icon: Icon(
                    state.viewMode == ViewMode.list ? Icons.map : Icons.list,
                  ),
                  onPressed: () => context.read<CitiesCubit>().toggleViewMode(),
                );
              },
            ),
          ],
        ),
        body: const Column(
          children: [
            SearchBarWidget(),
            SearchHistoryListWidget(),
            Expanded(
              child: CitiesContent(),
            ),
          ],
        ),
      ),
    );
  }
}
