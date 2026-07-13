class User {
  final int? id;
  final String fullName;
  final String email;
  final String avatar;

  User({
    this.id,
    required this.fullName,
    required this.email,
    required this.avatar,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'fullName': fullName,
      'email': email,
      'avatar': avatar,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String,
    );
  }

  User copyWith({int? id, String? fullName, String? email, String? avatar}) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }
}
