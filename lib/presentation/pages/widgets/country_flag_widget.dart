import 'package:flutter/material.dart';
import 'package:world_countries/world_countries.dart';

class CountryFlagWidget extends StatelessWidget {
  final String countryCode;
  final double size;

  const CountryFlagWidget({
    super.key,
    required this.countryCode,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final country = WorldCountry.fromCode(countryCode);
      return EmojiFlag.platformDefault(
        country,
        size: size,
      );
    } catch (_) {
      return Text(
        '🏳️',
        style: TextStyle(fontSize: size),
      );
    }
  }
}
