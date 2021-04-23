import 'package:flutter/material.dart';

const int SECONDS_OF_DAY = 24 * 60 * 60; // seconds of one day
const int SECONDS_OF_YEAR = 365 * 24 * 60 * 60; // seconds of one year

const node_list_edgeware = [
  {
    'name': 'Edgeware Mainnet #1 (hosted by Commonwealth Labs)',
    'ss58': 7,
    'endpoint': 'wss://mainnet1.edgewa.re/',
  },
  // {
  //   'name': 'Edgeware Mainnet #2 (hosted by Commonwealth Labs)',
  //   'ss58': 7,
  //   'endpoint': 'wss://mainnet2.edgewa.re/',
  // },
  // {
  //   'name': 'Edgeware Mainnet #3 (hosted by Commonwealth Labs)',
  //   'ss58': 7,
  //   'endpoint': 'wss://mainnet3.edgewa.re/',
  // },
  {
    'name': 'Edgeware Mainnet #4 (hosted by Commonwealth Labs)',
    'ss58': 7,
    'endpoint': 'wss://mainnet4.edgewa.re/',
  },
  {
    'name': 'Edgeware Mainnet #5 (hosted by Commonwealth Labs)',
    'ss58': 7,
    'endpoint': 'wss://mainnet5.edgewa.re/',
  },
  {
    'name': 'Edgeware Mainnet #6 (hosted by Commonwealth Labs)',
    'ss58': 7,
    'endpoint': 'wss://mainnet6.edgewa.re/',
  },
  {
    'name': 'Edgeware Mainnet #7 (hosted by Commonwealth Labs)',
    'ss58': 7,
    'endpoint': 'wss://mainnet7.edgewa.re/',
  },
  {
    'name': 'Edgeware Mainnet #8 (hosted by Commonwealth Labs)',
    'ss58': 7,
    'endpoint': 'wss://mainnet8.edgewa.re/',
  },
  {
    'name': 'Edgeware Mainnet #9 (hosted by Commonwealth Labs)',
    'ss58': 7,
    'endpoint': 'wss://mainnet9.edgewa.re/',
  },
];

const MaterialColor edgeware_jaco_blue = const MaterialColor(
  0xFF0A95DF,
  const <int, Color>{
    50: const Color(0xFFE2F2FB),
    100: const Color(0xFFB6DFF5),
    200: const Color(0xFF85CAEF),
    300: const Color(0xFF54B5E9),
    400: const Color(0xFF2FA5E4),
    500: const Color(0xFF0A95DF),
    600: const Color(0xFF098DDB),
    700: const Color(0xFF0782D7),
    800: const Color(0xFF0578D2),
    900: const Color(0xFF0367CA),
  },
);

const home_nav_items = ['staking', 'governance'];

const String genesis_hash_edgeware =
    '0x742a2ca70c2fda6cee4f8df98d64c4c670a052d9568058982dad9d5a7a135c5b';
const String network_name_edgeware = 'edgeware';
