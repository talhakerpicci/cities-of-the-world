import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cities/cities_cubit.dart';
import 'views/common/error_view.dart';
import 'views/common/loading_view.dart';
import 'views/cities_list_view.dart';
import 'views/cities_map_view.dart';

class CitiesContent extends StatelessWidget {
  const CitiesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CitiesCubit, CitiesState>(
      builder: (context, state) {
        if (state.error != null && state.cities.isEmpty) {
          return ErrorView(
            message: state.error!,
            onRetry: () => context.read<CitiesCubit>().loadCities(),
          );
        }

        if (state.isLoading && state.cities.isEmpty) {
          return LoadingView(viewMode: state.viewMode);
        }

        if (state.cities.isEmpty && !state.isLoading) {
          return const Center(
            child: Text('No cities found'),
          );
        }

        return switch (state.viewMode) {
          ViewMode.list => CitiesListView(state: state),
          ViewMode.map => CitiesMapView(cities: state.cities),
        };
      },
    );
  }
}
