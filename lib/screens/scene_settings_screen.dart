import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/scene.dart';
import '../providers/home_provider.dart';
import '../utils/device_utils.dart';

class SceneSettingsScreen extends StatelessWidget {
  final Scene scene;

  const SceneSettingsScreen({super.key, required this.scene});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${scene.name} Настройки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await context.read<HomeProvider>().resetSceneState(scene.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Сцена была сброшена')),
                );
              }
            },
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Настройки сцены сохранены')),
              );
            },
            child: const Text('Done'),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          final currentScene = provider.getSceneById(scene.id);
          if (currentScene == null)
            return const Center(child: Text('Scene not found'));

          final allDevices = provider.getAllDevices();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: allDevices.length,
            itemBuilder: (context, index) {
              final device = allDevices[index];
              final savedState =
                  currentScene.deviceStates[device.id] ?? device.isActive;

              return SwitchListTile(
                title: Text(device.name),
                subtitle: Text(getDeviceTypeName(device.type)),
                value: savedState,
                onChanged: (value) async {
                  await provider.updateSceneDeviceState(
                      scene.id, device.id, value);
                },
              );
            },
          );
        },
      ),
    );
  }
}
