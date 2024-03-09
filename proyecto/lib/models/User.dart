class User {
  final int id;
  final String Nombre;
  final String Apellido;
  final String Telefono;
  final String Email;
  final String Password;

  const User({
    required this.id,
    required this.Nombre,
    required this.Apellido,
    required this.Telefono,
    required this.Email,
    required this.Password,


  });

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'Nombre': String Nombre,
        'Apellido': String Apellido,
        'Telefono': String Telefono,
        'Email': String Email,
        'Password': String Password,


      } =>
          User(
            id: id,
            Nombre: Nombre,
            Apellido: Apellido,
            Telefono: Telefono,
            Email: Email,
            Password: Password,

          ),
      _ => throw const FormatException('Failed to load User.'),
    };
  }
}
