import 'package:cloud_firestore/cloud_firestore.dart';

extension CustomGetters on DocumentSnapshot {
  int getInt(key) {
    return data().toString().contains(key) ? get(key) : 0;
  }
  String getString(key) {
    return data().toString().contains(key) ? get(key) : '';
  }
}