// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'edit_profile_screen.dart' as edit;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              child: const Text('Lihat Profil'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const edit.EditProfileScreen()),
                );
              },
              child: const Text('Edit Profil'),
            ),
          ],
        ),
      ),
    );
  }
}
