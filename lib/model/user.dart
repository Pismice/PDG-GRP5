class User {
  String? uid;
  String? authId;
  String? name;
  String? profilepicture;

  User({this.uid, this.authId, this.name, this.profilepicture});

  User.fromJson(Map<String, dynamic> json) {
    authId = json['authid'];
    name = json['name'];
    profilepicture = json['profilepicture'];
  }

  Map<String, dynamic> toFirestore() {
    return {
      "authid": authId,
      "name": name,
      "profilepicture": profilepicture,
    };
  }
}
