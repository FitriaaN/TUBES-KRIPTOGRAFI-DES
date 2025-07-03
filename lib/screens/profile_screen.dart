import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';
  String phone = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = doc.data();
    if (data != null) {
      final salt = data['salt'];
      final key = _deriveKeyFromSalt(salt);

      setState(() {
        name = _decryptDES(data['name'], key);
        email = _decryptDES(data['email'], key);
        phone = data['phone'] != null ? _decryptDES(data['phone'], key) : '-';
      });
    }
  }

  List<int> _deriveKeyFromSalt(String salt) {
    final padded = salt.padRight(8, '0').substring(0, 8);
    return utf8.encode(padded);
  }

  String _decryptDES(String encryptedText, List<int> key) {
    final encryptedBytes = base64.decode(encryptedText);
    final decryptedBytes = <int>[];
    for (int i = 0; i < encryptedBytes.length; i++) {
      decryptedBytes.add(encryptedBytes[i] ^ key[i % key.length]);
    }
    return utf8.decode(decryptedBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Pengguna',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Nama: $name'),
            const SizedBox(height: 8),
            Text('Email: $email'),
            const SizedBox(height: 8),
            Text('Nomor HP: $phone'),
          ],
        ),
      ),
    );
  }
}
