import 'package:flutter/material.dart';

import 'presentation/pages/cities_page.dart';

class AppMain extends StatelessWidget {
  const AppMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cities of the World',
      home: CitiesPage(),
    );
  }
}
