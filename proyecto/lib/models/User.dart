class User {
  final int id;
  final String Nombre;
  final String Apellido;
  final String Telefono;
  final String Email;


  const User({
    required this.id,
    required this.Nombre,
    required this.Apellido,
    required this.Telefono,
    required this.Email,
  


  });

  factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'],
    Nombre: json['Nombre'],
    Apellido: json['Apellido'],
    Telefono: json['Telefono'],
    Email: json['Email'],
  );
}

}
