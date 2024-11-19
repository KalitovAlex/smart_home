import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/models/scene.dart';
import 'package:smart_home/utils/device_utils.dart';
import '../widgets/device_card.dart';
import '../widgets/scene_card.dart';
import '../providers/home_provider.dart';
import 'add_room_screen.dart';
import 'rooms_screen.dart';
import 'statistics_screen.dart';
import 'settings_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: [
          if (_selectedIndex == 0) ...[
            IconButton(
              icon: const Icon(Icons.analytics),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatisticsScreen()),
                );
              },
            ),
          ],
          if (_selectedIndex == 1)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddRoomScreen()),
                );
              },
            ),
        ],
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.room),
            label: 'Комнаты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Мой дом';
      case 1:
        return 'Мои комнаты';
      case 2:
        return 'Настройки';
      default:
        return 'Мой дом';
    }
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomeView();
      case 1:
        return const RoomsView();
      case 2:
        return const SettingsView();
      default:
        return const HomeView();
    }
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final allDevices = provider.getAllDevices();
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: allDevices.map((device) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: DeviceCard(
                        icon: getDeviceIcon(device.type),
                        title: device.name,
                        subtitle: device.isActive ? 'Вкл' : 'Выкл',
                        isActive: device.isActive,
                        onTap: () => provider.toggleDevice(
                          provider.findRoomIdForDevice(device.id),
                          device.id,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Сцены',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Column(
                children: [
                  SceneCard(
                    icon: Icons.wb_sunny,
                    title: 'Утренняя сцена',
                    sceneId: 'morning',
                    type: SceneType.morning,
                  ),
                  SizedBox(height: 8),
                  SceneCard(
                    icon: Icons.nightlight_round,
                    title: 'Ночная сцена',
                    sceneId: 'night',
                    type: SceneType.night,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
} 