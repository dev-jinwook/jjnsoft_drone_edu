import 'package:drone_portal/utils/log_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
import 'package:kakaomap_webview/kakaomap_webview.dart' as kakao;
import 'package:location/location.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FlyMapPage extends StatefulWidget {
  const FlyMapPage({super.key});

  @override
  State<StatefulWidget> createState() => _FlyMapPage();
}

class _FlyMapPage extends State<FlyMapPage> {
  // late LocationData _locationData;

  late WebViewController _kakaoMapContrller;

  // late double _lat = 33.450701;
  // late double _lng = 126.570667;

  // static const CameraPosition _kGooglePlex = ;

  @override
  void initState() {
    super.initState();

    getLocationInfo();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getLocationInfo(),
      builder: (context, snapShot) {
        Widget child = const Center(
          child: Text('Loading...'),
        );

        if (snapShot.hasData) {
          LocationData info = snapShot.data!;
          child = getKakaoMap(info.latitude!, info.longitude!);
        }

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('현재 위비행'),
            ),
            body: child,
          ),
        );
      },
    );
  }

  Widget getKakaoMap(double lat, double lng) {
    return kakao.KakaoMapView(
      width: double.infinity,
      height: double.infinity,
      kakaoMapKey: '3e57091b24bbf0fad1ab62ed3798bd06',
      lat: lat,
      lng: lng,
      // draggableMarker: true,
      // onTapMarker: (message) {
      //   logger.d('message : $message');
      // },
      mapController: (WebViewController controller) {
        _kakaoMapContrller = controller;
        // setClickMark(controller);
      },
      customScript: getCustomScript(lat, lng),
    );
  }

  void getController() {}

  Widget getGoogleMap(double lat, double lng) {
    return google.GoogleMap(
      mapType: google.MapType.normal,
      initialCameraPosition: google.CameraPosition(
        target: google.LatLng(lat, lng),
        zoom: 15.0,
      ),
      onMapCreated: (google.GoogleMapController controller) {
        // _controller.complete(controller);
      },
    );
  }

  Future<LocationData?> getLocationInfo() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    logger.d('serviceEnabled $serviceEnabled');

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      logger.d('serviceEnabled $serviceEnabled');

      if (!serviceEnabled) {
        return null;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    logger.d('permissionGranted $permissionGranted');

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      logger.d('permissionGranted $permissionGranted');

      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    LocationData locationData = await location.getLocation();

    return locationData;
  }

  /// KakaoMap SetMark
  void setMark(double lat, double lng) {
    String strScript = 'marker.setMap(null); new kakao.maps.Marker({position: new kakao.maps.LatLng($lat, $lng)}).setMap(map);';
    logger.d('strScript :  $strScript');
    _kakaoMapContrller.runJavascript(strScript);
  }

  void setClickMark(WebViewController controller) {
    String strScript = '''
    kakao.maps.event.addListener(map, 'click', function(mouseEvent) { 
      marker.setPosition(mouseEvent.latLng);
    });
    ''';
    logger.d('strScript :  $strScript');
    _kakaoMapContrller.runJavascript(strScript);
  }

  String getCustomScript(double lat, double lng){

    String strScript = '''   
    new kakao.maps.Marker({position: new kakao.maps.LatLng($lat, $lng)}).setMap(map);
    kakao.maps.event.addListener(map, 'click', function(mouseEvent) { 
      marker.setPosition(mouseEvent.latLng);
    });
    ''';

    logger.d('strScript :  $strScript');

    return strScript;
  }

// void set
}
