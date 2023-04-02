
// ignore_for_file: curly_braces_in_flow_control_structures

class User {
  final int? id;
  final String name;
  final Role role;
  final String password;
  final String? firstName;
  final String? lastName;
  final int? phone;
  final String? address;
  final String? selection;

  static const idC = 'id',
    nameC = 'name',
    roleC = 'role',
    passwordC = 'password',
    firstNameC = 'firstName',
    lastNameC = 'lastName',
    phoneC = 'phone',
    addressC = 'address',
    selectionC = 'selection';

  const User({
    this.id,
    required this.name,
    required this.role,
    required this.password,
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
    this.selection
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json[idC],
      name: json[nameC],
      role: Role.create(json[roleC])!,
      password: json[passwordC],
      firstName: json[firstNameC],
      lastName: json[lastNameC],
      phone: json[phoneC],
      address: json[addressC],
      selection: json[selectionC]
  );

  @override
  bool operator ==(Object other) => identical(this, other) || other is User &&
    runtimeType == other.runtimeType &&
    id == other.id &&
    name == other.name &&
    role == other.role &&
    password == other.password &&
    firstName == other.firstName &&
    lastName == other.lastName &&
    phone == other.phone &&
    address == other.address &&
    selection == other.selection;

  @override
  int get hashCode =>
    id.hashCode ^
    name.hashCode ^
    role.hashCode ^
    password.hashCode ^
    firstName.hashCode ^
    lastName.hashCode ^
    phone.hashCode ^
    address.hashCode ^
    selection.hashCode;
}

enum Role {
  user(0, 'USER'), admin(1, 'ADMIN');

  const Role(this.value, this.role);
  final int value;
  final String role;

  static Role? create(String which) {
    for (final i in Role.values)
      if (i.role == which) return i;
    return null;
  }
}
