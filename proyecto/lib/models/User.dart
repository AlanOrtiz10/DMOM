class User {
  final int id;
  final String Nombre;
  final String Apellido;

  const User({
    required this.id,
    required this.Nombre,
    required this.Apellido,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'Nombre': String Nombre,
        'Apellido': String Apellido,
      } =>
          User(
            id: id,
            Nombre: Nombre,
            Apellido: Apellido,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
