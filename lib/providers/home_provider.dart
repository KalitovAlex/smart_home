import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/room.dart';
import '../models/scene.dart';
import 'dart:async';

class HomeProvider with ChangeNotifier {
  List<Room> _rooms = [];
  List<Room> get rooms => _rooms;

  List<Scene> _scenes = [];
  List<Scene> get scenes => _scenes;

  SharedPreferences? _prefs;
  static const String _roomsKey = 'rooms';
  static const String _scenesKey = 'scenes';

  Timer? _usageTimer;
  Timer? _deviceCheckTimer;

  HomeProvider() {
    // Remove initialization from constructor since we need async init
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadRooms();
    await _loadScenes();
    _startUsageTracking();
    _startDeviceCheck();

    if (_scenes.isEmpty) {
      _scenes = [
        Scene(
          id: 'morning',
          name: 'Morning scene',
          type: SceneType.morning,
          deviceStates: {},
        ),
        Scene(
          id: 'night',
          name: 'Night scene',
          type: SceneType.night,
          deviceStates: {},
        ),
      ];
      await _saveScenes();
    }

    if (_rooms.isEmpty) {
      _initializeDefaultRooms();
    }
  }

  Future<void> _loadRooms() async {
    try {
      final roomsJson = _prefs?.getString(_roomsKey);
      if (roomsJson != null) {
        final List<dynamic> decoded = jsonDecode(roomsJson);
        _rooms = decoded.map((json) => Room.fromJson(json)).toList();
      } else {
        // Инициализация комнат по умолчанию
        _rooms = [
          Room(
            id: 'living_room',
            name: 'Гостиная',
            imageUrl: 'assets/images/living_room.jpg',
          ),
          Room(
            id: 'bedroom',
            name: 'Спальня',
            imageUrl: 'assets/images/bedroom.jpg',
          ),
          Room(
            id: 'kitchen',
            name: 'Кухня',
            imageUrl: 'assets/images/kitchen.jpg',
          ),
        ];
        await _saveRooms();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading rooms: $e');
      _rooms = [];
    }
  }

  Future<void> _loadScenes() async {
    try {
      final scenesJson = _prefs?.getString(_scenesKey);
      if (scenesJson != null) {
        final List<dynamic> decoded = jsonDecode(scenesJson);
        _scenes = decoded.map((json) => Scene.fromJson(json)).toList();
      } else {
        // Инициализация сцен по умолчанию
        _scenes = [
          Scene(
            id: 'morning',
            name: 'Morning scene',
            type: SceneType.morning,
            deviceStates: {},
          ),
          Scene(
            id: 'night',
            name: 'Night scene',
            type: SceneType.night,
            deviceStates: {},
          ),
        ];
        await _saveScenes();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading scenes: $e');
      _scenes = [];
    }
  }

  Future<void> _saveRooms() async {
    try {
      final encoded = jsonEncode(_rooms.map((room) => room.toJson()).toList());
      await _prefs?.setString(_roomsKey, encoded);
    } catch (e) {
      debugPrint('Error saving rooms: $e');
    }
  }

  Future<void> _saveScenes() async {
    try {
      final encoded = jsonEncode(_scenes.map((scene) => scene.toJson()).toList());
      await _prefs?.setString(_scenesKey, encoded);
    } catch (e) {
      debugPrint('Error saving scenes: $e');
    }
  }

  Future<void> addRoom(String name, {String? imageUrl}) async {
    final room = Room(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      devices: [],
      imageUrl: imageUrl,
    );
    _rooms.add(room);
    await _saveRooms();
    notifyListeners();
  }

  Future<void> toggleDevice(String roomId, String deviceId) async {
    final roomIndex = _rooms.indexWhere((room) => room.id == roomId);
    if (roomIndex != -1) {
      final deviceIndex = _rooms[roomIndex]
          .devices
          .indexWhere((device) => device.id == deviceId);
      if (deviceIndex != -1) {
        _rooms[roomIndex].devices[deviceIndex].isActive =
            !_rooms[roomIndex].devices[deviceIndex].isActive;
        await _saveRooms();
        notifyListeners();
      }
    }
  }

  Future<void> addDevice(String roomId, String name, DeviceType type) async {
    final roomIndex = _rooms.indexWhere((room) => room.id == roomId);
    if (roomIndex != -1) {
      final device = Device(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        type: type,
      );
      _rooms[roomIndex].devices.add(device);
      await _saveRooms();
      notifyListeners();
    }
  }

  Future<void> activateScene(String sceneId) async {
    try {
      final scene = _scenes.firstWhere((s) => s.id == sceneId);

      if (scene.deviceStates.isNotEmpty) {
        for (var entry in scene.deviceStates.entries) {
          final deviceId = entry.key;
          final targetState = entry.value;

          for (var room in _rooms) {
            final deviceIndex =
                room.devices.indexWhere((d) => d.id == deviceId);
            if (deviceIndex != -1) {
              final device = room.devices[deviceIndex];
              if (device.isActive != targetState) {
                await toggleDevice(room.id, deviceId);
              }
            }
          }
        }
      } else {
        switch (scene.type) {
          case SceneType.morning:
            for (var room in _rooms) {
              for (var device in room.devices) {
                if (!device.isActive) {
                  await toggleDevice(room.id, device.id);
                }
              }
            }
            break;
          case SceneType.night:
            for (var room in _rooms) {
              for (var device in room.devices) {
                if (device.isActive) {
                  await toggleDevice(room.id, device.id);
                }
              }
            }
            break;
          default:
            break;
        }
      }
    } catch (e) {
      debugPrint('Error activating scene: $e');
    }
  }

  Future<void> saveSceneState(String sceneId) async {
    final sceneIndex = _scenes.indexWhere((s) => s.id == sceneId);
    if (sceneIndex != -1) {
      final deviceStates = <String, bool>{};
      for (var room in _rooms) {
        for (var device in room.devices) {
          deviceStates[device.id] = device.isActive;
        }
      }

      _scenes[sceneIndex] = Scene(
        id: _scenes[sceneIndex].id,
        name: _scenes[sceneIndex].name,
        type: _scenes[sceneIndex].type,
        deviceStates: deviceStates,
      );

      await _saveScenes();
      notifyListeners();
    }
  }

  List<Device> getAllDevices() {
    return _rooms.expand((room) => room.devices).toList();
  }

  String findRoomIdForDevice(String deviceId) {
    for (var room in _rooms) {
      if (room.devices.any((device) => device.id == deviceId)) {
        return room.id;
      }
    }
    return '';
  }

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

  Future<void> setDeviceTimer(
      String roomId, String deviceId, Duration duration) async {
    final roomIndex = _rooms.indexWhere((room) => room.id == roomId);
    if (roomIndex != -1) {
      final deviceIndex = _rooms[roomIndex]
          .devices
          .indexWhere((device) => device.id == deviceId);
      if (deviceIndex != -1) {
        _rooms[roomIndex].devices[deviceIndex].timerEndTime =
            DateTime.now().add(duration);
        await _saveRooms();
        notifyListeners();
      }
    }
  }

  Future<void> clearDeviceTimer(String roomId, String deviceId) async {
    final roomIndex = _rooms.indexWhere((room) => room.id == roomId);
    if (roomIndex != -1) {
      final deviceIndex = _rooms[roomIndex]
          .devices
          .indexWhere((device) => device.id == deviceId);
      if (deviceIndex != -1) {
        _rooms[roomIndex].devices[deviceIndex].timerEndTime = null;
        await _saveRooms();
        notifyListeners();
      }
    }
  }

  Future<void> updateSceneDeviceState(String sceneId, String deviceId, bool state) async {
    final sceneIndex = _scenes.indexWhere((s) => s.id == sceneId);
    if (sceneIndex != -1) {
      final updatedStates = Map<String, bool>.from(_scenes[sceneIndex].deviceStates);
      updatedStates[deviceId] = state;
      
      _scenes[sceneIndex] = Scene(
        id: _scenes[sceneIndex].id,
        name: _scenes[sceneIndex].name,
        type: _scenes[sceneIndex].type,
        deviceStates: updatedStates,
      );
      
      await _saveScenes();
      notifyListeners();
    }
  }

  Future<void> resetSceneState(String sceneId) async {
    final sceneIndex = _scenes.indexWhere((s) => s.id == sceneId);
    if (sceneIndex != -1) {
      _scenes[sceneIndex] = Scene(
        id: _scenes[sceneIndex].id,
        name: _scenes[sceneIndex].name,
        type: _scenes[sceneIndex].type,
        deviceStates: {},
      );
      
      await _saveScenes();
      notifyListeners();
    }
  }

  Scene? getSceneById(String sceneId) {
    try {
      return _scenes.firstWhere((s) => s.id == sceneId);
    } catch (e) {
      return null;
    }
  }

  Future<void> _initializeDefaultRooms() async {
    _rooms = [
      Room(
        id: 'living_room',
        name: 'Living Room',
        devices: [
          Device(
            id: 'light_1',
            name: 'Main Light',
            type: DeviceType.light,
          ),
          Device(
            id: 'tv_1',
            name: 'Smart TV',
            type: DeviceType.tv,
          ),
        ],
      ),
      Room(
        id: 'bedroom',
        name: 'Bedroom',
        devices: [
          Device(
            id: 'light_2',
            name: 'Bedroom Light',
            type: DeviceType.light,
          ),
        ],
      ),
    ];
    await _saveRooms();
    notifyListeners();
  }

  void _startUsageTracking() {
    _usageTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      bool needsSave = false;
      for (var room in _rooms) {
        for (var device in room.devices) {
          if (device.isActive) {
            device.usageMinutes++;
            needsSave = true;
          }
        }
      }
      if (needsSave) {
        _saveRooms();
      }
    });
  }

  void _startDeviceCheck() {
    _deviceCheckTimer =
        Timer.periodic(const Duration(seconds: 30), (timer) async {
      final now = DateTime.now();
      bool needsSave = false;

      for (var room in _rooms) {
        for (var device in room.devices) {
          if (device.timerEndTime != null &&
              now.isAfter(device.timerEndTime!)) {
            device.timerEndTime = null;
            if (device.isActive) {
              await toggleDevice(room.id, device.id);
              needsSave = true;
            }
          }
        }
      }

      if (needsSave) {
        await _saveRooms();
      }
    });
  }

  @override
  void dispose() {
    _usageTimer?.cancel();
    _deviceCheckTimer?.cancel();
    super.dispose();
  }
}
