import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.userName,
    required super.email,
    required super.password,
    super.gender,
    super.level,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json['userName'],
      email: json['email'],
      password: json['password'],
      gender: json['gender'],
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': userName,
      'email': email,
      'password': password,
      if (gender != null) 'gender': gender,
      if (level != null) 'level': level,
    };
  }
}
