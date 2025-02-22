import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_frontend/utils/navigator.dart';
import 'package:mobile_frontend/views/about/about.dart';
import 'package:mobile_frontend/views/mapsInsert.dart';
import 'package:mobile_frontend/views/profile.dart';
import 'package:mobile_frontend/widget/adbox.dart';
import 'package:mobile_frontend/widget/balancedgridmenu.dart';
import 'package:mobile_frontend/widget/largelisttile.dart';
import '../controller/service.dart';
import '../widget/yes_no_dialog.dart';
// import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';
import 'package:mobile_frontend/views/login.dart';
import 'package:mobile_frontend/services/api_service.dart';
import 'package:mobile_frontend/views/mapView.dart';
import 'dart:async';
import 'package:mobile_frontend/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const HomeScreen({
    super.key,
    required this.userData,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String latitude = "Fetching...";
  String longitude = "Fetching...";
  String address = "Fetching address...";
  final LocationService _locationService = LocationService();
  final ipAddress =
      'http://10.82.187.196:8000'; // Tukar IP Sendiri Time Present
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
    // Start periodic location updates
    _locationTimer = Timer.periodic(Duration(minutes: 5), (timer) {
      _fetchLocation();
    });
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  Future<Widget> GetHospital() async {
    try {
      Position position = await _locationService.getCurrentPosition();
      final hospitals = await ApiService()
          .getNearbyHospitals(position.latitude, position.longitude);

      if (hospitals.isEmpty) {
        return Center(child: Text("No hospitals found nearby"));
      }

      return Column(
        children: hospitals
            .map((hospital) => LargeListTile(
                  leading:
                      Icon(Icons.local_hospital, color: AppColors.turquoise),
                  title: Text(hospital["HospitalName"] ?? ''),
                  subtitle: Text(hospital["HospitalAddress"] ?? ''),
                  overline: Text(
                      'Distance: ${hospital["Distance"].toStringAsFixed(2)} km'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapView(
                          userLatitude:
                              hospital["HospitalLang"]?.toDouble() ?? 0.0,
                          userLongitude:
                              hospital["HospitalLong"]?.toDouble() ?? 0.0,
                          userAddress: hospital["HospitalAddress"] ?? '',
                          nearbyHospitals: [hospital],
                        ),
                      ),
                    );
                  },
                  backgroundColor: AppColors.charcoal.withOpacity(0.1),
                ))
            .toList(),
      );
    } catch (e) {
      print('Error in GetHospital: $e');
      return Center(child: Text("Error loading nearby hospitals: $e"));
    }
  }

  Future<void> _handleLogout() async {
    final continueLogout = await showYesNoDialog(
      context: context,
      title: 'Log out',
      message: 'Are you sure you want to logout?',
    );

    if (continueLogout == true) {
      // Use the navigation utility instead
      toNavigate.gotoLogin(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
        backgroundColor: AppColors.lightGrey,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 10.0),
            child: IconButton(
              icon: Icon(
                Icons.logout_rounded,
                color: AppColors.lightGrey,
                size: 28,
              ),
              onPressed: _handleLogout,
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: AppColors.darkNavy,
            boxShadow: [
              BoxShadow(
                color: AppColors.charcoal.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: MediaQuery.of(context).padding.top + 35,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome,",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "${widget.userData['UserName'] ?? 'User'}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.charcoal.withOpacity(0.1),
                ),
                child: BalancedGridView(
                  columnCount: 4,
                  children: [
                    MenuCardSmallTile(
                      icon: Icon(Icons.person,
                          size: 32, color: AppColors.darkNavy),
                      label: 'Profile',
                      builder: (context) =>
                          ProfilePage(userData: widget.userData),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfilePage(userData: widget.userData),
                          ),
                        );
                        // Update userData if profile was edited
                        if (result != null && mounted) {
                          setState(() {
                            widget.userData['UserName'] = result['UserName'];
                            widget.userData['UserEmail'] = result['UserEmail'];
                          });
                        }
                      },
                      backgroundColor: AppColors.lightGrey,
                    ),
                    MenuCardSmallTile(
                      icon:
                          Icon(Icons.logout, size: 32, color: Colors.blue[900]),
                      label: 'Logout',
                      builder: (context) => Container(),
                      onTap: _handleLogout,
                    ),
                  ],
                ),
              ),
              const Gap(20),
              const Text(
                "Your Current Location: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              ),
              const Gap(20),
              LargeListTile(
                leading: Icon(Icons.map, color: AppColors.turquoise),
                title: const Text('Your Location'),
                subtitle: Text(
                  'Latitude: $latitude , Longitude: $longitude',
                  style: TextStyle(fontSize: 12),
                ),
                bottom: Text(
                  'Address: $address',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: CircleAvatar(
                  backgroundColor: AppColors.darkNavy,
                  child: IconButton(
                    color: AppColors.lightGrey,
                    onPressed: () async {
                      await _fetchLocation();
                      setState(() {});
                    },
                    icon: const Icon(Icons.gps_fixed),
                  ),
                ),
                onTap: () async {
                  // Get nearby hospitals
                  Position position =
                      await _locationService.getCurrentPosition();
                  final hospitals = await ApiService().getNearbyHospitals(
                      position.latitude, position.longitude);

                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapView(
                          userLatitude: position.latitude,
                          userLongitude: position.longitude,
                          userAddress: address,
                          nearbyHospitals: hospitals,
                        ),
                      ),
                    );
                  }
                },
                backgroundColor: AppColors.charcoal.withOpacity(0.1),
              ),
              const Gap(20),
              const Text(
                "Hospital Nearby List: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              ),
              const Gap(20),
              FutureBuilder(
                  future: GetHospital(),
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // While waiting for the future to complete
                    } else if (snapshot.hasError) {
                      return Text(
                          'Error: ${snapshot.error}'); // If there is an error
                    } else {
                      return snapshot.data!; // Display the resulting widget
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchLocation() async {
    try {
      print("Fetching location...");
      Position position = await _locationService.getCurrentPosition();
      String addr = await _locationService.getAddressFromLatLng(
          position.latitude, position.longitude);

      // Track location on server
      await ApiService().trackLocation(
        userId: widget.userData['UserID'],
        latitude: position.latitude,
        longitude: position.longitude,
        address: addr,
      );

      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        address = addr;
      });
    } catch (e) {
      print("Error fetching location: $e");
      setState(() {
        address = e.toString();
      });
    }
  }
}

class MenuCardSmallTile extends StatelessWidget {
  const MenuCardSmallTile({
    Key? key,
    required this.icon,
    required this.label,
    required this.builder,
    this.onTap,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  final Icon icon;
  final String label;
  final WidgetBuilder builder;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: icon,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: textTheme.labelMedium!.copyWith(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
