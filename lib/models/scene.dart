class Scene {
  final String id;
  final String name;
  final SceneType type;
  final Map<String, bool> deviceStates; // deviceId -> state

  Scene({
    required this.id,
    required this.name,
    required this.type,
    this.deviceStates = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString(),
      'deviceStates': deviceStates,
    };
  }

  factory Scene.fromJson(Map<String, dynamic> json) {
    return Scene(
      id: json['id'],
      name: json['name'],
      type: SceneType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => SceneType.custom,
      ),
      deviceStates: Map<String, bool>.from(json['deviceStates'] ?? {}),
    );
  }
}

enum SceneType {
  morning,
  night,
  custom
} 