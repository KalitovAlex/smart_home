import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../models/scene.dart';
import '../screens/scene_settings_screen.dart';

class SceneCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sceneId;
  final SceneType type;

  const SceneCard({
    super.key,
    required this.icon,
    required this.title,
    required this.sceneId,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final scene = provider.scenes.firstWhere((s) => s.id == sceneId);

        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon),
          ),
          title: Text(title),
          subtitle: Text('${scene.deviceStates.length} устройств настроено'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SceneSettingsScreen(scene: scene),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () {
                  provider.activateScene(sceneId);
                },
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }
}
