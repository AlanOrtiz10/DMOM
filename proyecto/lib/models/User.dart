class User {
  final int id;
  final String Nombre;
  final String Apellido;
  final String Telefono;

  const User({
    required this.id,
    required this.Nombre,
    required this.Apellido,
    required this.Telefono,

  });

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'Nombre': String Nombre,
        'Apellido': String Apellido,
        'Telefono': String Telefono,

      } =>
          User(
            id: id,
            Nombre: Nombre,
            Apellido: Apellido,
            Telefono: Telefono,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
