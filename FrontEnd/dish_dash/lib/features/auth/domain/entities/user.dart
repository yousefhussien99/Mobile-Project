class User {
  final String userName;
  final String email;
  final String password;
  final String? gender;
  final int? level;

  const User({
    required this.userName,
    required this.email,
    required this.password,
    this.gender,
    this.level,
  });

  List<Object?> get props => [userName, email, password, gender, level];
}
