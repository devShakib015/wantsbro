import 'dart:convert';

class AddressModel {
  String id;
  String addressType;
  String name;
  String phone;
  String address;
  String postCode;
  String area;
  String district;
  AddressModel({
    this.id,
    this.addressType,
    this.name,
    this.phone,
    this.address,
    this.postCode,
    this.area,
    this.district,
  });

  AddressModel copyWith({
    String id,
    String addressType,
    String name,
    String phone,
    String address,
    String postCode,
    String area,
    String district,
  }) {
    return AddressModel(
      id: id ?? this.id,
      addressType: addressType ?? this.addressType,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      postCode: postCode ?? this.postCode,
      area: area ?? this.area,
      district: district ?? this.district,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'addressType': addressType,
      'name': name,
      'phone': phone,
      'address': address,
      'postCode': postCode,
      'area': area,
      'district': district,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AddressModel(
      id: map['id'],
      addressType: map['addressType'],
      name: map['name'],
      phone: map['phone'],
      address: map['address'],
      postCode: map['postCode'],
      area: map['area'],
      district: map['district'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddressModel(id: $id, addressType: $addressType, name: $name, phone: $phone, address: $address, postCode: $postCode, area: $area, district: $district)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AddressModel &&
        o.id == id &&
        o.addressType == addressType &&
        o.name == name &&
        o.phone == phone &&
        o.address == address &&
        o.postCode == postCode &&
        o.area == area &&
        o.district == district;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        addressType.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        postCode.hashCode ^
        area.hashCode ^
        district.hashCode;
  }
}
