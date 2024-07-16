class UserModel {
  var uid;
  var displayName;
  var email;
  var photoURL;
  var phoneNumber;

  UserModel(
      this.uid, this.displayName, this.email, this.photoURL, this.phoneNumber);

  factory UserModel.froMap(Map data) => UserModel(
        data['uid'],
        data['displayName'],
        data['email'],
        data['photoURL'],
        data['phoneNumber'],
      );

  Map<String, dynamic> get toMap => {
        'uid': uid,
        'displayName': displayName ?? "DEMO USER",
        'email': email ?? "demo_mail",
        'phoneNumber': phoneNumber ?? "NO DATA",
        'photoURL': photoURL ??
            "https://static.vecteezy.com/system/resources/previews/002/318/271/non_2x/user-profile-icon-free-vector.jpg",
      };
}
