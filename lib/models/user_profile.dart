class UserProfile {
  String? firestoreID;
  String userID;
  String email;

  String userName;
  int petID;
  String userPhotoURL;

  UserProfile({
    this.firestoreID,
    required this.userID,
    required this.email,
    required this.userName,
    required this.petID,
    required this.userPhotoURL,
  });

  static UserProfile fromJson(Map<String, dynamic> json) {
    return UserProfile(
      email: json['email'],
      firestoreID: json['firestoreID'],
      userID: json['userID'],
      userName: json['userName'],
      petID: json['petID'],
      userPhotoURL: json['userPhotoURL'],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': this.email,
        'firestoreID': this.firestoreID,
        'userID': this.userID,
        'userName': this.userName,
        'petID': this.petID,
        'userPhotoURL': this.userPhotoURL,
      };
}
