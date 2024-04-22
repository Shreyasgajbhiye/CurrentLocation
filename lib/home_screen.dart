// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
//
// class PolygonCheckPage extends StatefulWidget {
//   @override
//   _PolygonCheckPageState createState() => _PolygonCheckPageState();
// }
//
// class _PolygonCheckPageState extends State<PolygonCheckPage> {
//   final List<Offset> _polygonCoordinates = [
//     Offset(20.9189175, 77.7736374),
//     Offset(20.91877333736, 77.77412238497175),
//     Offset(20.9173745628524, 77.77152887432457),
//     Offset(20.916928712934347, 77.77305309422344),
//     Offset(20.91711360142975, 77.7738880510418),
//     Offset(20.917460001100423, 77.77379249740046),
//
//   ];
//
//   Offset? _currentLocation;
//   GoogleMapController? _mapController;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Polygon Check'),
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: (controller) {
//               _mapController = controller;
//             },
//             initialCameraPosition: CameraPosition(
//               target: LatLng(_polygonCoordinates[0].dx, _polygonCoordinates[0].dy),
//               zoom: 16.0,
//             ),
//             polygons: {
//               Polygon(
//                 polygonId: PolygonId('my_polygon'),
//                 points: _polygonCoordinates.map((coord) => LatLng(coord.dx, coord.dy)).toList(),
//                 strokeWidth: 2,
//                 strokeColor: Colors.blue,
//                 fillColor: Colors.blue.withOpacity(0.4),
//               ),
//             },
//             markers: _currentLocation != null
//                 ? {
//               Marker(
//                 markerId: MarkerId('current_location'),
//                 position: LatLng(_currentLocation!.dx, _currentLocation!.dy),
//                   infoWindow: InfoWindow(
//                       title: 'My Position'
//                   )
//               ),
//             }
//                 : {},
//           ),
//           Positioned(
//             bottom: 16.0,
//             left: 16.0,
//             right: 16.0,
//             child: Container(
//               color: Colors.white,
//               padding: EdgeInsets.all(16.0),
//               child: Text(
//                 _currentLocation != null
//                     ? 'Current Location: ${_currentLocation!.dx}, ${_currentLocation!.dy}\nInside Polygon: ${isPointInsidePolygon(_currentLocation!)}'
//                     : 'Loading...',
//                 style: TextStyle(fontSize: 18),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           title: Text('Location Services Disabled'),
//           content: Text('Please enable location services to continue.'),
//           actions: [
//             TextButton(
//               child: Text('OK'),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ],
//         ),
//       );
//       return;
//     }
//
//     // Request location permissions
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) => AlertDialog(
//             title: Text('Location Permissions Denied'),
//             content: Text('Please grant location permissions to continue.'),
//             actions: [
//               TextButton(
//                 child: Text('OK'),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ],
//           ),
//         );
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           title: Text('Location Permissions Denied'),
//           content: Text(
//               'Location permissions are permanently denied, we cannot request permissions.'),
//           actions: [
//             TextButton(
//               child: Text('OK'),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ],
//         ),
//       );
//       return;
//     }
//
//     // Get the current location
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.bestForNavigation,
//     );
//
//     setState(() {
//       _currentLocation = Offset(position.latitude, position.longitude);
//     });
//   }
//
//   bool isPointInsidePolygon(Offset point) {
//     final path = Path();
//     path.addPolygon(_polygonCoordinates, true);
//     return path.contains(point);
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: PolygonCheckPage(),
//   ));
// }
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class PolygonCheckPage extends StatefulWidget {
  @override
  _PolygonCheckPageState createState() => _PolygonCheckPageState();
}

class _PolygonCheckPageState extends State<PolygonCheckPage> {
  final LatLng _circleCenter = LatLng(20.9189175, 77.7736374);
  final double _circleRadius = 500; // radius in meters

  LatLng? _currentLocation;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Circle Check'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _circleCenter,
              zoom: 16.0,
            ),
            circles: Set<Circle>.from([
              Circle(
                circleId: CircleId('my_circle'),
                center: _circleCenter,
                radius: _circleRadius,
                strokeWidth: 2,
                strokeColor: Colors.blue,
                fillColor: Colors.blue.withOpacity(0.4),
              ),
            ]),
            markers: _currentLocation != null
                ? {
              Marker(
                markerId: MarkerId('current_location'),
                position: _currentLocation!,
                infoWindow: InfoWindow(
                  title: 'My Position',
                ),
              ),
            }
                : {},
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.0),
              child: SelectableText(
                _currentLocation != null
                    ? 'Latitude: ${_currentLocation!.latitude}, Longitude: ${_currentLocation!.longitude}\nInside Circle: ${isPointInsideCircle(_currentLocation!)}'
                    : 'Loading...',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Location Services Disabled'),
          content: Text('Please enable location services to continue.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    // Request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Location Permissions Denied'),
            content: Text('Please grant location permissions to continue.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Location Permissions Denied'),
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  bool isPointInsideCircle(LatLng point) {
    double distance = Geolocator.distanceBetween(
      point.latitude,
      point.longitude,
      _circleCenter.latitude,
      _circleCenter.longitude,
    );

    return distance <= _circleRadius;
  }
}

void main() {
  runApp(MaterialApp(
    home: PolygonCheckPage(),
  ));
}
