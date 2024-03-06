import 'package:flutter/material.dart';

@immutable
final class UserModel {
  const UserModel(this.uid, this.username, this.password);

  final String uid;
  final String username;
  final String password;

  factory UserModel.fromJson(Map<String, String> json) => UserModel(json['uid'] as String, json['username'] as String, json['password'] as String);

  Map<String, String> toJson() => <String, String>{'uid': uid, 'username': username, 'password': password};
}
