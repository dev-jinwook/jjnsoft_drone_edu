import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:location/location.dart';

class FlyMapPage extends StatefulWidget {
  const FlyMapPage({super.key});

  @override
  State<StatefulWidget> createState() => _FlyMapPage();
}

class _FlyMapPage extends State<FlyMapPage> {

  late LocationData _locationData;

  @override
  void initState() {

    getLocationInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double lat = 33.450701;
    double lng = 126.570667;

    // if (_locationData != null) {
    //   lat = _locationData.latitude ?? 0.0;
    //   lng = _locationData.longitude ?? 0.0;
    // }

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('비행'),
      ),
      body: KakaoMapView(
        kakaoMapKey: '3e57091b24bbf0fad1ab62ed3798bd06',
        width: double.infinity,
        height: double.infinity,
        lat: lat,
        lng: lng,
      ),
    ));
  }

  Future<void> getLocationInfo() async {

    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData locationData = await location.getLocation();

    setState(() {
      _locationData = locationData;
    });
  }
}
