import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  User? get currentFirebaseUser => _firebaseAuth.currentUser;

  Future<UserModel?> getUserModel(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw Exception('Sign in failed.');
    }

    final userModel = await getUserModel(user.uid);
    if (userModel == null) {
      // Create user doc if it doesn't exist for some reason
      final newUserModel = UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        role: UserRole.user,
      );
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(newUserModel.toMap());
      return newUserModel;
    }
    return userModel;
  }

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Sign up failed.');
    }

    await user.updateDisplayName(name.trim());
    await user.reload();

    final userModel = UserModel(
      id: user.uid,
      name: name.trim(),
      email: email.trim(),
      role: UserRole.user,
    );

    await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

    return userModel;
  }

  Future<void> signOut() => _firebaseAuth.signOut();
}
