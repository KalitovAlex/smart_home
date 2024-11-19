import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/models/room.dart';
import 'package:smart_home/screens/add_room_screen.dart';
import '../providers/home_provider.dart';
import 'room_screen.dart';

class RoomsView extends StatelessWidget {
  const RoomsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.rooms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Комнаты еще не добавлены',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddRoomScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Добавить комнату'),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
            final itemWidth = (constraints.maxWidth - (16 * (crossAxisCount + 1))) / crossAxisCount;
            final itemHeight = itemWidth * 1.2;
            final aspectRatio = itemWidth / itemHeight;

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: aspectRatio,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: provider.rooms.length,
              itemBuilder: (context, index) {
                final room = provider.rooms[index];
                final activeDevices = room.devices.where((d) => d.isActive).length;

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomScreen(room: room),
                        ),
                      );
                    },
                    child: LayoutBuilder(
                      builder: (context, cardConstraints) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: cardConstraints.maxHeight * 0.6,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    _buildRoomImage(room),
                                    _buildGradientOverlay(),
                                    if (room.devices.isNotEmpty)
                                      _buildDeviceCounter(activeDevices, room.devices.length),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      room.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${room.devices.length} ${room.devices.length == 1 ? 'device' : 'devices'}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const Spacer(),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: room.devices.isEmpty
                                            ? 0
                                            : activeDevices / room.devices.length,
                                        backgroundColor: Colors.grey[200],
                                        valueColor: AlwaysStoppedAnimation(
                                          Theme.of(context).colorScheme.primary,
                                        ),
                                        minHeight: 4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildRoomImage(Room room) {
    return room.imageUrl != null
        ? Image.asset(
            room.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholder();
            },
          )
        : _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.home_outlined,
        size: 48,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black54,
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCounter(int activeDevices, int totalDevices) {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '$activeDevices/$totalDevices active',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
