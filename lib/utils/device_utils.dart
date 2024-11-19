import 'package:flutter/material.dart';
import '../models/room.dart';

IconData getDeviceIcon(DeviceType type) {
  switch (type) {
    case DeviceType.tv:
      return Icons.tv;
    case DeviceType.light:
      return Icons.lightbulb_outline;
    case DeviceType.airPurifier:
      return Icons.air;
    default:
      return Icons.devices_other;
  }
}

String getDeviceTypeName(DeviceType type) {
  switch (type) {
    case DeviceType.tv:
      return 'Телевизор';
    case DeviceType.light:
      return 'Освещение';
    case DeviceType.airPurifier:
      return 'Очиститель воздуха';
    default:
      return 'Другое';
  }
} 