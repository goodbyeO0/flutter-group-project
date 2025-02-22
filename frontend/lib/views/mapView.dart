import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_frontend/utils/app_colors.dart';

class MapView extends StatelessWidget {
  final double userLatitude;
  final double userLongitude;
  final String userAddress;
  final List<Map<String, dynamic>> nearbyHospitals;

  const MapView({
    Key? key,
    required this.userLatitude,
    required this.userLongitude,
    required this.userAddress,
    required this.nearbyHospitals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Hospitals'),
        backgroundColor: AppColors.lightGrey,
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(userLatitude, userLongitude),
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: [
                    // User's location marker
                    Marker(
                      point: LatLng(userLatitude, userLongitude),
                      builder: (ctx) => Container(
                        child: Icon(
                          Icons.location_pin,
                          color: AppColors.turquoise,
                          size: 40,
                        ),
                      ),
                    ),
                    // Hospital markers
                    ...nearbyHospitals
                        .map((hospital) => Marker(
                              point: LatLng(
                                hospital["HospitalLang"]?.toDouble() ?? 0.0,
                                hospital["HospitalLong"]?.toDouble() ?? 0.0,
                              ),
                              builder: (ctx) => GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => Container(
                                      padding: EdgeInsets.all(16),
                                      color: AppColors.darkNavy,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            hospital["HospitalName"] ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  color: AppColors.lightGrey,
                                                ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            hospital["HospitalAddress"] ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: AppColors.lightGrey,
                                                ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Distance: ${hospital["Distance"].toStringAsFixed(2)} km',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: AppColors.lightGrey,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.local_hospital,
                                  color: AppColors.darkNavy,
                                  size: 40,
                                ),
                              ),
                            ))
                        .toList(),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: AppColors.darkNavy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Location',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.lightGrey,
                      ),
                ),
                SizedBox(height: 8),
                Text(
                  userAddress,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.lightGrey,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
