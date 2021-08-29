final String tableUser = "user";

class UserFields {
  static final List<String> values = [id, name, email, domain, type];
  static final String id = "_id";
  static final String name = "name";
  static final String email = "email";
  static final String domain = "domain";
  static final String type = "type";
  static final String picture = "picture";
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? domain;
  final String? type;
  final String? picture;

  const User({
    this.id,
    required this.name,
    required this.email,
    required this.domain,
    required this.type,
    this.picture,
  });

  Map<String, Object?> toJson() => {
        UserFields.id: id,
        UserFields.name: name,
        UserFields.email: email,
        UserFields.domain: domain,
        UserFields.type: type,
        UserFields.picture: picture,
      };

  User copy({
    int? id,
    String? name,
    String? email,
    String? domain,
    String? type,
    String? picture,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        domain: domain ?? this.domain,
        type: type ?? this.type,
        picture: picture ?? this.picture,
      );

  static User fromJson(Map<String, Object?> json) => User(
        id: json[UserFields.id] as int?,
        name: json[UserFields.name] as String?,
        email: json[UserFields.email] as String?,
        domain: json[UserFields.domain] as String?,
        type: json[UserFields.type] as String?,
        picture: json[UserFields.picture] as String?,
      );
}
