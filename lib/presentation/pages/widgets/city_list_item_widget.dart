import 'package:cities_of_the_world/domain/models/city_model.dart';
import 'package:flutter/material.dart';

import 'country_flag_widget.dart';

class CityListItemWidget extends StatelessWidget {
  final CityModel city;

  const CityListItemWidget({
    super.key,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CountryFlagWidget(
        countryCode: city.country.code,
      ),
      title: Text(city.name),
      subtitle: Text(
        '${city.localName}, ${city.country.name}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: city.latitude != null && city.longitude != null
          ? Tooltip(
              message: 'Latitude: ${city.latitude}\nLongitude: ${city.longitude}',
              child: const Icon(Icons.location_on),
            )
          : null,
    );
  }
}
