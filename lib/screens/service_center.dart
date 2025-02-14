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


  @override
  void initState() {
    super.initState();

  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Service Center',
        ),
      ),
      body: Center(
        child: Text(
          'Service Center',
        ),
      ),
    );
  }
}