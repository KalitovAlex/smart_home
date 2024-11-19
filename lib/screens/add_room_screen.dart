import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedImageUrl;

  Future<void> _pickImage() async {
    // Используем предустановленные изображения из ассетов
    final images = [
      'assets/images/living_room.jpg',
      'assets/images/bedroom.jpg',
      'assets/images/kitchen.jpg',
    ];

    final selectedImage = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Выберите изображение комнаты'),
        children: images
            .map((path) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, path),
                  child: Image.asset(path, height: 100, fit: BoxFit.cover),
                ))
            .toList(),
      ),
    );

    if (selectedImage != null) {
      setState(() => _selectedImageUrl = selectedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить комнату'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  image: _selectedImageUrl != null
                      ? DecorationImage(
                          image: AssetImage(
                              _selectedImageUrl!), // Заменил NetworkImage на AssetImage
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _selectedImageUrl == null
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 48),
                            SizedBox(height: 8),
                            Text('Добавить изображение комнаты'),
                          ],
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Название комнаты',
                hintText: 'Гостиная, Кухня и т.д.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.home),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  await context.read<HomeProvider>().addRoom(
                        _nameController.text,
                        imageUrl: _selectedImageUrl,
                      );
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Создать комнату'),
            ),
          ],
        ),
      ),
    );
  }
}
