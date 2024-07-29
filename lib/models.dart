class Student {
  final String id;
  final String firstName;
  final String lastName;
  final List<Skill> skills;
  final List<Address> addresses;

  Student(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.skills,
      required this.addresses});

  factory Student.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        '_id': String id,
        'firstName': String firstName,
        'lastName': String lastName,
        'skills': List<dynamic> skills,
        'addresses': List<dynamic> addresses
      } =>
        Student(
            id: id,
            firstName: firstName,
            lastName: lastName,
            skills: skills.map((skill) => Skill.fromJson(skill)).toList(),
            addresses: addresses.map((address) => Address.fromJson(address)).toList()),
      _ => throw const FormatException('Failed to load student.'),
    };
  }
}

class Skill {
  final String id;
  final String name;

  Skill({
    required this.id,
    required this.name,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        '_id': String id,
        'name': String name,
      } =>
        Skill(
          id: id,
          name: name,
        ),
      _ => throw const FormatException('Failed to load skill.'),
    };
  }
}

class Address {
  String? id;
  String country;
  String city;
  String street1;
  String? street2;

  Address({
    this.id,
    required this.country,
    required this.city,
    required this.street1,
    this.street2,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        '_id': String id,
        'country': String country,
        'city': String city,
        'street1': String street1,
      } =>
        Address(
          id: id,
          country: country,
          city: city,
          street1: street1,
          street2: json['street2'] as String?,
        ),
      _ => throw const FormatException('Failed to load address.'),
    };
  }

  @override
  String toString() {
    return '{ $country, $city, $street1, $street2 }';
  }
}
