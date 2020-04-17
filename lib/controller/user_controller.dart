import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

class UserModel extends Model {
  //usuario atual

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(listener) {
    // TODO: implement addListener
    super.addListener(listener);
    _loadCurrentUser();
  }

  void _loading() {
    isLoading = true;
    notifyListeners();
  }

  void _notLoading() {
    isLoading = false;
    notifyListeners();
  }

  //TODO: Função responsavel por realizar o cadastro
  Future<void> singUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    _loading();

    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: userData["email"], password: pass);

      firebaseUser = result.user;

      await _saveUserData(userData);
      onSuccess();

      _notLoading();
    } catch (err) {
      onFail();
      _notLoading();
    }
  }

  //TODO: Função responsavel por realizar o login
  Future<void> singIn({
    @required String email,
    @required String pass,
    @required VoidCallback onSecess,
    @required VoidCallback onFail,
  }) async {
    _loading();

    try {
      var user =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);

      firebaseUser = user.user;

      await _loadCurrentUser();

      onSecess();
      _notLoading();
    } catch (err) {
      onFail();
      _notLoading();
    }
  }

  void singOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  Future<void> recoverPass(String email) async {
    try {
      var result = await _auth.sendPasswordResetEmail(email: email);
    } catch (err) {
      print("email não existe no firebase");
    }
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) {
      firebaseUser = await _auth.currentUser();
    }
    if (firebaseUser != null) {
      if (userData['name'] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }
}
