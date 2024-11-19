import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/screens/statistics_screen.dart';
import '../providers/home_provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.analytics),
          title: const Text('Статистика'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StatisticsScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.refresh),
          title: const Text('Сбросить все сцены'),
          onTap: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Сбросить сцены'),
                content:
                    const Text('Вы уверены, что хотите сбросить все сцены?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Отмена'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Сбросить'),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              final provider = context.read<HomeProvider>();
              await provider.resetSceneState('morning');
              await provider.resetSceneState('night');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Все сцены были сброшены')),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
