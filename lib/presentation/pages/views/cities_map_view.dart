import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../domain/models/city_model.dart';
import '../widgets/country_flag_widget.dart';

class CitiesMapView extends StatelessWidget {
  final List<CityModel> cities;

  const CitiesMapView({
    super.key,
    required this.cities,
  });

  List<Marker> _buildMarkers(BuildContext context) {
    return cities
        .where((city) => city.latitude != null && city.longitude != null)
        .map(
          (city) => Marker(
            point: LatLng(city.latitude!, city.longitude!),
            width: 120,
            height: 120,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Row(
                      children: [
                        CountryFlagWidget(countryCode: city.country.code),
                        const SizedBox(width: 8),
                        Expanded(child: Text(city.name)),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${city.localName}, ${city.country.name}'),
                        Text('Latitude: ${city.latitude}'),
                        Text('Longitude: ${city.longitude}'),
                      ],
                    ),
                  ),
                );
              },
              child: const Icon(Icons.location_pin, color: Colors.red),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final markers = _buildMarkers(context);

    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(0, 0),
        initialZoom: 2,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.cities_of_the_world',
        ),
        MarkerLayer(
          markers: markers,
        ),
      ],
    );
  }
}
