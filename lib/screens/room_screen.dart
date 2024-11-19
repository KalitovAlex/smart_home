import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/screens/timer_screen.dart';
import '../models/room.dart';
import '../providers/home_provider.dart';
import '../widgets/device_card.dart';

class RoomScreen extends StatelessWidget {
  final Room room;

  const RoomScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(room.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDeviceDialog(context),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          final currentRoom = provider.rooms.firstWhere((r) => r.id == room.id);
          return LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: currentRoom.devices.length,
                itemBuilder: (context, index) {
                  final device = currentRoom.devices[index];
                  return DeviceCard(
                    icon: _getDeviceIcon(device.type),
                    title: device.name,
                    subtitle: device.isActive ? 'Включено' : 'Выключено',
                    isActive: device.isActive,
                    timerEndTime: device.timerEndTime,
                    onTap: () => provider.toggleDevice(room.id, device.id),
                    onTimerPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimerScreen(
                            device: device,
                            roomId: room.id,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  IconData _getDeviceIcon(DeviceType type) {
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

  void _showAddDeviceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddDeviceDialog(roomId: room.id),
    );
  }
}

class AddDeviceDialog extends StatefulWidget {
  final String roomId;

  const AddDeviceDialog({super.key, required this.roomId});

  @override
  State<AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {
  final TextEditingController _nameController = TextEditingController();
  DeviceType _selectedType = DeviceType.tv;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить устройство'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Название устройства',
              hintText: 'Телевизор, Лампа и т.д.',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<DeviceType>(
            value: _selectedType,
            items: DeviceType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.toString().split('.').last),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedType = value);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              context.read<HomeProvider>().addDevice(
                    widget.roomId,
                    _nameController.text,
                    _selectedType,
                  );
              Navigator.pop(context);
            }
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}
