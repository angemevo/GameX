class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String number;
  final int age;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.number,
    required this.age
  });

  // Convertir un Json en objet UserModel avec gestion des valeurs null
  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      return UserModel(
        id: json['id'] ?? 0,
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        username: json['username'] ?? '',
        email: json['email'] ?? '',
        number: json['number'] ?? '',
        age: json['age'] ?? 0,
      );
    } catch (e) {
      print("Erreur parsing UserModel: $e");
      print("JSON reçu: $json");
      // Retourner un utilisateur par défaut en cas d'erreur
      return UserModel(
        id: 0,
        firstName: 'Unknown',
        lastName: 'User',
        username: 'unknown',
        email: '',
        number: '',
        age: 0,
      );
    }
  }

  // Version alternative plus robuste avec validation des types
  factory UserModel.fromJsonSafe(Map<String, dynamic> json) {
    return UserModel(
      id: _parseToInt(json['id']),
      firstName: _parseToString(json['first_name']),
      lastName: _parseToString(json['last_name']),
      username: _parseToString(json['username']),
      email: _parseToString(json['email']),
      number: _parseToString(json['number']),
      age: _parseToInt(json['age']),
    );
  }

  // Méthodes utilitaires pour le parsing sécurisé
  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _parseToString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  // Convertir un objet en Json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'number': number,
      'age': age
    };
  }

  // Méthode pour vérifier si l'utilisateur est valide
  bool get isValid {
    return id > 0 &&
        firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        username.isNotEmpty &&
        email.isNotEmpty;
  }

  // Nom complet
  String get fullName => '$firstName $lastName';

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email)';
  }
}