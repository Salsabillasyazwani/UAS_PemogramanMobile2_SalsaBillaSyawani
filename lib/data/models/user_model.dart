class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String? password;
  final String? profileUrl;
  final String? street;
  final String? kecamatan;
  final String? kabupaten;
  final String? provinsi;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    this.password,
    this.profileUrl,
    this.street,
    this.kecamatan,
    this.kabupaten,
    this.provinsi,
  });
  UserModel copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? phone,
    String? profileUrl,
    String? street,
    String? kecamatan,
    String? kabupaten,
    String? provinsi,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileUrl: profileUrl ?? this.profileUrl,
      street: street ?? this.street,
      kecamatan: kecamatan ?? this.kecamatan,
      kabupaten: kabupaten ?? this.kabupaten,
      provinsi: provinsi ?? this.provinsi,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone_number'] ?? '',
      password: json['password'],
      profileUrl: json['profile_url'],
      street: json['street'],
      kecamatan: json['kecamatan'],
      kabupaten: json['kabupaten'],
      provinsi: json['provinsi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone_number': phone,
      if (password != null) 'password': password,
      'profile_url': profileUrl,
      'street': street,
      'kecamatan': kecamatan,
      'kabupaten': kabupaten,
      'provinsi': provinsi,
    };
  }
}
