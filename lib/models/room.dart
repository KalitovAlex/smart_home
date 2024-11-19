class Room {
  final String id;
  final String name;
  List<Device> devices;
  String? imageUrl;

  Room({
    required this.id,
    required this.name,
    this.devices = const [],
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'devices': devices.map((device) => device.toJson()).toList(),
      'imageUrl': imageUrl,
    };
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      devices: (json['devices'] as List?)
          ?.map((device) => Device.fromJson(device))
          .toList() ?? [],
      imageUrl: json['imageUrl'],
    );
  }
}

class Device {
  final String id;
  final String name;
  final DeviceType type;
  bool isActive;
  DateTime? timerEndTime;
  int usageMinutes;

  Device({
    required this.id,
    required this.name,
    required this.type,
    this.isActive = false,
    this.timerEndTime,
    this.usageMinutes = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString(),
      'isActive': isActive,
      'timerEndTime': timerEndTime?.toIso8601String(),
      'usageMinutes': usageMinutes,
    };
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      type: DeviceType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => DeviceType.other,
      ),
      isActive: json['isActive'] ?? false,
      timerEndTime: json['timerEndTime'] != null 
          ? DateTime.parse(json['timerEndTime'])
          : null,
      usageMinutes: json['usageMinutes'] ?? 0,
    );
  }
}

enum DeviceType {
  tv,
  light,
  airPurifier,
  other
} 