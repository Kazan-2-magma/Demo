class Userapp {
  String id_user;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String photoUrl;
  String idProjet;
  String role;
  String password;

  Userapp({
    required this.id_user,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.photoUrl,
    required this.idProjet,
    required this.role,
    required this.password
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber':phoneNumber,
      'email': email,
      'photoUrl': photoUrl,
      'idProjet': idProjet,
      'role':role,
      'password' :password
    };
  }
  factory Userapp.fromJson(Map<String, dynamic> json) {
    return Userapp(
        id_user: json['id_user'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        phoneNumber: json['phoneNumber'],
        email: json['email'],
        photoUrl: json['photoUrl'],
        idProjet: json['idProjet'],
        role:json['role'],
        password: json['password'],
    );
  }

}