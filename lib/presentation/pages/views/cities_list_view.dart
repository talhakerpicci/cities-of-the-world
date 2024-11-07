import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/cities/cities_cubit.dart';
import '../widgets/city_list_item_widget.dart';
import '../widgets/loading_list_item_widget.dart';

class CitiesListView extends StatefulWidget {
  final CitiesState state;

  const CitiesListView({
    super.key,
    required this.state,
  });

  @override
  State<CitiesListView> createState() => _CitiesListViewState();
}

class _CitiesListViewState extends State<CitiesListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CitiesCubit>().loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      itemCount: widget.state.cities.length + (widget.state.isLoadingMore ? 5 : 0),
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        if (index >= widget.state.cities.length) {
          return const LoadingListItemWidget();
        }

        return CityListItemWidget(
          city: widget.state.cities[index],
        );
      },
    );
  }
}
