class UserModel {
  final String email;
  final String image;
  final String username;
  final String uid;

  const UserModel({
    required this.email,
    required this.image,
    required this.username,
    required this.uid,
  });

  factory UserModel.fromJSON({required Map<String, dynamic> dataMap}) {
    return UserModel(
      email: dataMap["email"],
      image: dataMap["image_url"],
      username: dataMap["username"],
      uid: dataMap["id"],
    );
  }
}
