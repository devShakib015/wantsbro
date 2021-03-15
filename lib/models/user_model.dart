import 'dart:convert';

class UserModel {
  String id;
  String email;
  String dpURL;
  String name;
  String phone;
  String gender;
  DateTime dateOfBirth;
  String occupation;
  String userRole;
  String customerId;
  UserModel({
    this.id,
    this.email,
    this.dpURL,
    this.name,
    this.phone,
    this.gender,
    this.dateOfBirth,
    this.occupation,
    this.userRole,
    this.customerId,
  });

  UserModel copyWith({
    String id,
    String email,
    String dpURL,
    String name,
    String phone,
    String gender,
    DateTime dateOfBirth,
    String occupation,
    String userRole,
    String customerId,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      dpURL: dpURL ?? this.dpURL,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      occupation: occupation ?? this.occupation,
      userRole: userRole ?? this.userRole,
      customerId: customerId ?? this.customerId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'dpURL': dpURL,
      'name': name,
      'phone': phone,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.millisecondsSinceEpoch,
      'occupation': occupation,
      'userRole': userRole,
      'customerId': customerId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserModel(
      id: map['id'],
      email: map['email'],
      dpURL: map['dpURL'],
      name: map['name'],
      phone: map['phone'],
      gender: map['gender'],
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth']),
      occupation: map['occupation'],
      userRole: map['userRole'],
      customerId: map['customerId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, dpURL: $dpURL, name: $name, phone: $phone, gender: $gender, dateOfBirth: $dateOfBirth, occupation: $occupation, userRole: $userRole, customerId: $customerId)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserModel &&
        o.id == id &&
        o.email == email &&
        o.dpURL == dpURL &&
        o.name == name &&
        o.phone == phone &&
        o.gender == gender &&
        o.dateOfBirth == dateOfBirth &&
        o.occupation == occupation &&
        o.userRole == userRole &&
        o.customerId == customerId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        dpURL.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        gender.hashCode ^
        dateOfBirth.hashCode ^
        occupation.hashCode ^
        userRole.hashCode ^
        customerId.hashCode;
  }
}
