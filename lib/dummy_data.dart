import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'common/assets_config.dart';

final List<Map<String, dynamic>> trendingItems = [
  {'title': 'Mobiles', 'icon': Assets.images.mobile},
  {'title': 'Watches', 'icon': Assets.images.watch},
  {'title': 'Accessories', 'icon': Assets.images.cables},
];
final List<Map<String, dynamic>> trendingGames = [
  {'title': 'Surf\'s Up', 'icon': Assets.images.game1},
  {'title': 'Gold rush', 'icon': Assets.images.game2},
  {'title': 'Sniper 3D', 'icon': Assets.images.game3},
];

final List<Map<String, dynamic>> serviceCenters = [
  {
    'name': 'Symphony Sevice center - Badda',
    'address':
        'Service Touch Point, Configura Report Shopping Complex, Badda, Dhaka - 1212',
    'distance': '2.71 KM',
    'lat': 23.781605,
    'lng': 90.425860,
  },
  {
    'name': 'Symphony Sevice center - Mirpur',
    'address': 'Symphony Service Center, Mirpur-10, Dhaka - 1216',
    'distance': '3.5 KM',
    'lat': 23.806955,
    'lng': 90.369053,
  },
  {
    'name': 'Symphony Sevice center - Uttara',
    'address': 'Symphony Service Point, Uttara Sector-7, Dhaka - 1230',
    'distance': '4.2 KM',
    'lat': 23.867452,
    'lng': 90.399748,
  },
];

final List<Map<String, dynamic>> socialPlatforms = [
  {
    'name': 'Facebook',
    'icon': FontAwesomeIcons.facebook,
    'description': 'Join our Facebook community',
  },
  {
    'name': 'Instagram',
    'icon': FontAwesomeIcons.instagram,
    'description': 'Follow us for product photos',
  },
  {
    'name': 'YouTube',
    'icon': FontAwesomeIcons.youtube,
    'description': 'Watch product reviews',
  },
  {
    'name': 'Twitter',
    'icon': FontAwesomeIcons.twitter,
    'description': 'Get real-time updates',
  },
];
