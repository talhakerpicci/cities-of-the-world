import 'dart:math';

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoadingListItemWidget extends StatelessWidget {
  const LoadingListItemWidget({super.key});

  String _randomLengthString(int minLength, int maxLength) {
    final random = Random();
    return '-' * (minLength + random.nextInt(maxLength - minLength));
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListTile(
        leading: const CircleAvatar(radius: 20),
        title: Text(_randomLengthString(10, 30)),
        subtitle: Text(_randomLengthString(30, 50)),
        trailing: const Icon(Icons.location_on),
      ),
    );
  }
}
