import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../utils/device_utils.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика использования'),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          final devices = provider.getAllDevices();
          devices.sort((a, b) => b.usageMinutes.compareTo(a.usageMinutes));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              final hours = device.usageMinutes ~/ 60;
              final minutes = device.usageMinutes % 60;

              return Card(
                child: ListTile(
                  leading: Icon(getDeviceIcon(device.type)),
                  title: Text(device.name),
                  subtitle: Text(
                    'Общее использование: ${hours}ч ${minutes}м',
                  ),
                  trailing: device.isActive
                      ? const Chip(
                          label: Text('Active'),
                          backgroundColor: Colors.green,
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
} 