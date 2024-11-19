import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/room.dart';
import '../providers/home_provider.dart';

class TimerScreen extends StatefulWidget {
  final Device device;
  final String roomId;

  const TimerScreen({
    super.key,
    required this.device,
    required this.roomId,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _hours = 0;
  int _minutes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Установить таймер для ${widget.device.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Hours'),
                    NumberPicker(
                      value: _hours,
                      onChanged: (value) => setState(() => _hours = value),
                      minValue: 0,
                      maxValue: 23,
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                Column(
                  children: [
                    const Text('Minutes'),
                    NumberPicker(
                      value: _minutes,
                      onChanged: (value) => setState(() => _minutes = value),
                      minValue: 0,
                      maxValue: 59,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (_hours > 0 || _minutes > 0) {
                  final duration = Duration(
                    hours: _hours,
                    minutes: _minutes,
                  );
                  context.read<HomeProvider>().setDeviceTimer(
                        widget.roomId,
                        widget.device.id,
                        duration,
                      );
                  Navigator.pop(context);
                }
              },
              child: const Text('Установить таймер'),
            ),
            if (widget.device.timerEndTime != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<HomeProvider>().clearDeviceTimer(
                        widget.roomId,
                        widget.device.id,
                      );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Очистить таймер'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NumberPicker extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int minValue;
  final int maxValue;

  const NumberPicker({
    super.key,
    required this.value,
    required this.onChanged,
    required this.minValue,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_upward),
          onPressed: () {
            if (value < maxValue) {
              onChanged(value + 1);
            }
          },
        ),
        Text(
          value.toString().padLeft(2, '0'),
          style: const TextStyle(fontSize: 24),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_downward),
          onPressed: () {
            if (value > minValue) {
              onChanged(value - 1);
            }
          },
        ),
      ],
    );
  }
}
