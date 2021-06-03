class HoardUser {
  final String uid;
  final String firstName;
  final String lastName;
  final String photoUrl;
  final Map portfolio;

  HoardUser(
      {this.uid, this.firstName, this.lastName, this.photoUrl, this.portfolio});

  HoardUser.fromMap(Map map)
      : this.uid = map['uid'],
        this.firstName = map['fName'],
        this.lastName = map['lName'],
        this.photoUrl = map['photoUrl'],
        this.portfolio = map['portfolio'];

  Map toMap() {
    return {
      'uid': this.uid,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'photoUrl': this.photoUrl,
      'portfolio': this.portfolio,
    };
  }
}
