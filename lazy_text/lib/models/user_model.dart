class UserModel {
  final String id;
  final String fullname;
  final String email;
  final String profilePic;

  UserModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.profilePic,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserModel(
      id: json["_id"],
      fullname: json["fullname"] ?? "",
      email: json["email"] ?? "",
      profilePic: json["profilePic"] ?? "",
    );
  }
}