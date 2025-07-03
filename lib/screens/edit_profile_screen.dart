import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/custom_encryption.dart';
import 'dart:convert';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = AuthService().currentUser;
    _nameController.text = user?.name ?? '';
    _phoneController.text = user?.phone ?? '';
  }

  Future<void> _save() async {
    final user = AuthService().currentUser;
    if (user == null) return;

    final files = Directory('lib/data').listSync();
    for (var file in files) {
      if (file is File && file.path.contains(user.id)) {
        final encrypted = await file.readAsString();
        final decrypted = CustomEncryption.decrypt(encrypted);
        final data = jsonDecode(decrypted);

        data['name'] = CustomEncryption.encrypt(_nameController.text.trim());
        data['phone'] = CustomEncryption.encrypt(_phoneController.text.trim());

        final updatedJson = jsonEncode(data);
        final updatedEncrypted = CustomEncryption.encrypt(updatedJson);
        await file.writeAsString(updatedEncrypted);

        AuthService().setCurrentUser(
          user.copyWith(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
          ),
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
        Navigator.pop(context);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'No. HP'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
