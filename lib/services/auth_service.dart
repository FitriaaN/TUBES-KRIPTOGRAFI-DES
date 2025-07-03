import '../models/user_model.dart';
import '../helpers/des_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  void setCurrentUser(UserModel user) {
    _currentUser = user;
  }

  final String _defaultKey = '133457799BBCDFF1'; // DES Key

  Future<bool> register(String name, String email, String password) async {
    try {
      _isLoading = true;

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      final salt = 'static-salt';

      final des = LocalDES(_defaultKey);

      final encryptedData = {
        'encryptedEmail': des.encrypt(email),
        'encryptedPassword': des.encrypt(password),
        'name': des.encrypt(name),
        'phone': des.encrypt('-'),
        'salt': salt,
      };

      await _firestore.collection('users').doc(uid).set(encryptedData);

      _currentUser = UserModel(
        id: uid,
        name: name,
        email: email,
        password: password,
        phone: '-',
        salt: salt,
      );

      return true;
    } catch (e) {
      print("Registration Error: $e");
      return false;
    } finally {
      _isLoading = false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) return false;

      final data = userDoc.data()!;
      final des = LocalDES(_defaultKey);
      final salt = data['salt'];

      // Cocokkan hasil enkripsi input dengan data tersimpan
      final encryptedInputEmail = des.encrypt(email);
      final encryptedInputPassword = des.encrypt(password);

      if (encryptedInputEmail == data['encryptedEmail'] &&
          encryptedInputPassword == data['encryptedPassword']) {
        // DEKRIPSI saat mengambil data user
        final decryptedName = des.decrypt(data['name']);
        final decryptedPhone = des.decrypt(data['phone']);

        _currentUser = UserModel(
          id: uid,
          name: decryptedName,
          email: email,
          password: password,
          phone: decryptedPhone,
          salt: salt,
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Login Error: $e");
      return false;
    } finally {
      _isLoading = false;
    }
  }

  void logout() {
    _auth.signOut();
    _currentUser = null;
  }
}
