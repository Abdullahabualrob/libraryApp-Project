class UserModel {
  final String uid;
  final String email;
  final bool isAdmin;

  UserModel({
    required this.uid,
    required this.email,
    required this.isAdmin,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      isAdmin: data['isAdmin'] ?? false,
    );
  }
}
