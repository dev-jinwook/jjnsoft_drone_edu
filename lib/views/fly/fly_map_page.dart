import 'package:flutter/material.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart' as kakao;
import 'package:location/location.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FlyMapPage extends StatefulWidget {
  const FlyMapPage({super.key});

  @override
  State<StatefulWidget> createState() => _FlyMapPage();
}

class _FlyMapPage extends State<FlyMapPage> {

  @override
  void initState() {
    init();

    super.initState();
  }

  ///
  void init() {

    // 현재 좌표
    getLocationInfo();

    // 항공 정보 (비행금지 구역, 관제권)

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
              title: const Text('현재 비행'),
            ),
            body: Stack(
              children: [
                child,
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    color: Colors.grey.withOpacity(0.7),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 130,
                          height: 25,
                          child: Row(
                            children: [
                              Checkbox(value: false, onChanged: (_) {}),
                              const Text('관제권'),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          height: 25,
                          child: Row(
                            children: [
                              Checkbox(value: false, onChanged: (_) {}),
                              const Text('비행금지구역'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
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
      mapController: (WebViewController controller) {},
      customScript: getCustomScript(lat, lng),
    );
  }

  // 현재 위치 정보 조회
  Future<LocationData?> getLocationInfo() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    LocationData locationData = await location.getLocation();

    return locationData;
  }

  String getCustomScript(double lat, double lng) {
    String strScript = '''   

      var marker = new kakao.maps.Marker({ 
          // 지도 중심좌표에 마커를 생성합니다 
          position: map.getCenter() 
      });
      
      // 지도에 마커를 표시합니다
      marker.setMap(map);
      
      // 지도에 클릭 이벤트를 등록합니다
      // 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
      kakao.maps.event.addListener(map, 'click', function(mouseEvent) {        
          
          // 클릭한 위도, 경도 정보를 가져옵니다 
          var latlng = mouseEvent.latLng; 
          
          // 마커 위치를 클릭한 위치로 옮깁니다
          marker.setPosition(latlng);
         
      });
      
      //
      
    ''';

    return strScript;
  }
}
