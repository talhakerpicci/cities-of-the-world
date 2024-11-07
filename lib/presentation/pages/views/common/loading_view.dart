import 'package:flutter/material.dart';

import '../../../cubits/cities/cities_cubit.dart';
import '../../widgets/loading_list_item_widget.dart';

class LoadingView extends StatelessWidget {
  final ViewMode viewMode;

  const LoadingView({
    super.key,
    required this.viewMode,
  });

  @override
  Widget build(BuildContext context) {
    return switch (viewMode) {
      ViewMode.list => _ListLoadingView(),
      ViewMode.map => _MapLoadingView(),
    };
  }
}

class _ListLoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) => const LoadingListItemWidget(),
    );
  }
}

class _MapLoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          ),
          SizedBox(height: 30),
          Text('Loading Map...'),
        ],
      ),
    );
  }
}
