import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isActive;
  final VoidCallback? onTap;
  final bool isFavorite;
  final DateTime? timerEndTime;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onTimerPressed;

  const DeviceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isActive,
    this.onTap,
    this.isFavorite = false,
    this.timerEndTime,
    this.onFavoritePressed,
    this.onTimerPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: isActive ? Colors.white : Colors.black,
                  size: 24,
                ),
                Row(
                  children: [
                    if (onTimerPressed != null)
                      IconButton(
                        icon: Icon(
                          timerEndTime != null ? Icons.timer : Icons.timer_outlined,
                          color: isActive ? Colors.white : Colors.black,
                        ),
                        onPressed: onTimerPressed,
                      ),
                    if (onFavoritePressed != null)
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          color: isActive ? Colors.white : Colors.black,
                        ),
                        onPressed: onFavoritePressed,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: isActive ? Colors.white70 : Colors.black54,
                fontSize: 12,
              ),
            ),
            if (timerEndTime != null) ...[
              const SizedBox(height: 4),
              Text(
                'Timer: ${_formatRemainingTime(timerEndTime!)}',
                style: TextStyle(
                  color: isActive ? Colors.white70 : Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatRemainingTime(DateTime endTime) {
    final remaining = endTime.difference(DateTime.now());
    if (remaining.isNegative) return 'Завершен';
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    return '${hours}ч ${minutes}м';
  }
} 