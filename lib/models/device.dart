enum DeviceType {
  light,
  thermostat,
  tv,
  speaker,
  securityCamera,
  smartPlug,
  airPurifier
}

class Device {
  final String id;
  final String name;
  final DeviceType type;
  bool isActive;
  bool isFavorite;
  DateTime? timerEndTime;
  int usageMinutes;
  Map<String, dynamic> settings;

  Device({
    required this.id,
    required this.name,
    required this.type,
    this.isActive = false,
    this.isFavorite = false,
    this.timerEndTime,
    this.usageMinutes = 0,
    Map<String, dynamic>? settings,
  }) : settings = settings ?? {};

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.toString(),
        'isActive': isActive,
        'isFavorite': isFavorite,
        'timerEndTime': timerEndTime?.toIso8601String(),
        'usageMinutes': usageMinutes,
        'settings': settings,
      };

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        id: json['id'],
        name: json['name'],
        type: DeviceType.values.firstWhere(
          (e) => e.toString() == json['type'],
          orElse: () => DeviceType.smartPlug,
        ),
        isActive: json['isActive'] ?? false,
        isFavorite: json['isFavorite'] ?? false,
        timerEndTime: json['timerEndTime'] != null
            ? DateTime.parse(json['timerEndTime'])
            : null,
        usageMinutes: json['usageMinutes'] ?? 0,
        settings: json['settings'] ?? {},
      );
}
