import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../dummy_data.dart';
import '../utils/widgets/dialog_widget.dart';

class ServiceCenter extends StatefulWidget {
  const ServiceCenter({super.key});

  @override
  State<ServiceCenter> createState() => ServiceCenterState();
}

class ServiceCenterState extends State<ServiceCenter> {
  late GoogleMapController _mapController;
  final Set<Polyline> _polylines = {};
  Position? _currentPosition;
  PolylinePoints polylinePoints = PolylinePoints();
  final DraggableScrollableController _sheetController =
  DraggableScrollableController();

  final Set<Marker> _markers = {};
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 12,
  );

  // Cache service center items
  late final List<Widget> _serviceItems;

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
    _checkLocationPermission();
    _serviceItems = _buildServiceItems();
  }

  List<Widget> _buildServiceItems() {
    return List.generate(
      serviceCenters.length,
          (index) => ServiceCenterItem(
        key: ValueKey('service_center_$index'),
        center: serviceCenters[index],
        onDirectionsPressed: (lat, lng) => _drawPolyline(LatLng(lat, lng)),
      ),
    );
  }

  void _initializeMarkers() {
    _markers.clear();
    for (var center in serviceCenters) {
      _markers.add(
        Marker(
          markerId: MarkerId(center['name']),
          position: LatLng(center['lat'], center['lng']),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: center['name'],
            snippet: '${center['distance']}',
          ),
        ),
      );
    }
    setState(() {});
  }

  void _minimizeSheet() {
    _sheetController.animateTo(
      0.3,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _getCurrentLocation() async {
    final Position position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _currentPosition = position;
      });
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ),
      );
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('current-location'),
            position: LatLng(position.latitude, position.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            infoWindow: const InfoWindow(title: 'You are here'),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _mapController.dispose();
    _markers.clear();
    _polylines.clear();
    super.dispose();
  }

  Future<void> _drawPolyline(LatLng destination) async {
    _minimizeSheet();
    if (_currentPosition == null) {
      _showNotification(
        message: 'Unable to get current location. Please try again.',
        onPressed: () => _getCurrentLocation(),
      );
      return;
    }

    LatLng origin = LatLng(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: 'api key',

        request: PolylineRequest(
          origin: PointLatLng(origin.latitude, origin.longitude),
          destination: PointLatLng(destination.latitude, destination.longitude),
          mode: TravelMode.walking,
        ),
      );

      if (result.points.isNotEmpty) {
        List<LatLng> polylineCoordinates = [];

        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        setState(() {
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              color: const Color(0xFFff002b),
              points: polylineCoordinates,
              width: 5,
            ),
          );
        });

        LatLngBounds bounds = LatLngBounds(
          southwest: LatLng(
            origin.latitude < destination.latitude
                ? origin.latitude
                : destination.latitude,
            origin.longitude < destination.longitude
                ? origin.longitude
                : destination.longitude,
          ),
          northeast: LatLng(
            origin.latitude > destination.latitude
                ? origin.latitude
                : destination.latitude,
            origin.longitude > destination.longitude
                ? origin.longitude
                : destination.longitude,
          ),
        );

        _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
      } else {
        _showNotification(
          message: 'Unable to find a route to the destination.',
        );
      }
    } catch (e) {
      _showNotification(
        message: 'Error getting directions. Please try again. ${e.toString()}',
      );
    }
  }

  void _showLocationPermissionDialog() {
    CustomDialog.show(
      context: context,
      title: 'Location Permission Required',
      content:
      'Location permission is required to show your location on the map. Please enable it in your phone settings.',
      confirmText: 'Open Settings',
      cancelText: 'Cancel',
      onConfirm: () async {
        context.pop();
        await openAppSettings();
      },
      onCancel: () {
        context.pop();
      },
    );
  }

  void _showNotification({
    required String message,
    bool showButton = false,
    VoidCallback? onPressed,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action:
        showButton
            ? SnackBarAction(label: 'OK', onPressed: onPressed ?? () {})
            : null,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _checkLocationPermission() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      if (await Permission.location.isGranted) {
        _getCurrentLocation();
      } else if (await Permission.location.isPermanentlyDenied) {
        _showLocationPermissionDialog();
      } else {
        final status = await Permission.location.request();
        if (status.isGranted) {
          _getCurrentLocation();
        } else {
          _showNotification(
            message:
            'Location permissions are required to show your location on the map',
          );
        }
      }
    } else {
      _showNotification(
        message:
        'Location services are disabled. Please enable location services in your phone settings.',
        showButton: true,
        onPressed: () {
          Geolocator.openLocationSettings();
        },
      );
    }
  }

  Widget _buildServiceCenterList(ScrollController scrollController) {
    return Column(
      children: [
        const DragHandle(),
        const Padding(
          padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
          child: Text(
            'Service Centers Near You',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: _serviceItems.length,
            itemBuilder: (context, index) => _serviceItems[index],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Service Centers')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
          ),
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.2,
              maxChildSize: 0.8,
              controller: _sheetController,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: _buildServiceCenterList(scrollController),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class ServiceCenterItem extends StatelessWidget {
  const ServiceCenterItem({
    super.key,
    required this.center,
    required this.onDirectionsPressed,
  });

  final Map<String, dynamic> center;
  final void Function(double lat, double lng) onDirectionsPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    center['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    center['address'],
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    center['distance'],
                    style: TextStyle(
                      color: Color(0xFFff002b),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  ActionButton(
                    icon: Icons.directions,
                    label: 'Directions',
                    onPressed:
                        () => onDirectionsPressed(center['lat'], center['lng']),
                  ),
                  const SizedBox(width: 16),
                  ActionButton(
                    icon: Icons.share,
                    label: 'Share',
                    isOutlined: true,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isOutlined = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.red, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.directions, color: Colors.white, size: 20),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
