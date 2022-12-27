import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

import '../fly/fly_map_page.dart';

class LeftMenu extends StatelessWidget {
  const LeftMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('드론 포털'),
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
          ),
          ListTile(
            title: Text('비행정보'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => FlyMapPage()));
            },
          ),
          const Divider(),
          ListTile(
            title: Text('필기시험'),
          ),
          ListTile(
            title: Text('실기시험'),
          ),
          const Divider(),
          ListTile(
            title: const Text('기상청 날씨누리'),
            onTap: () async {
              await launchUrl(Uri.parse('https://www.weather.go.kr/w/index.do'), mode: LaunchMode.externalApplication);
            },
          ),
          ListTile(
            title: const Text('항공기상청'),
            onTap: () async {
              await launchUrl(Uri.parse('https://amo.kma.go.kr'), mode: LaunchMode.externalApplication);
            },
          ),
          ListTile(
            title: const Text('드론원스톱민원서비스'),
            onTap: () async {
              await launchUrl(Uri.parse('https://www.droneportal.or.kr'), mode: LaunchMode.externalApplication);
            },
          ),
          Link(
              uri: Uri.parse('https://www.droneportal.or.kr'),
              target: LinkTarget.blank,
              builder: (context, openLink) {
                return ListTile(
                  title: Text('드론원스톱민원서비스'),
                  onTap: openLink,
                );
              }),
          Divider(),
          ListTile(
            title: Text('공지사항'),
          ),
          ListTile(
            title: Text('설정'),
          ),
        ],
      ),
    );
  }
}
