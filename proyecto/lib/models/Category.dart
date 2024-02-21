class Category {
  final int id;
  final String Nombre;
  final String Descripcion;

  const Category({
    required this.id,
    required this.Nombre,
    required this.Descripcion,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'Nombre': String Nombre,
        'Descripcion': String Descripcion,


      } =>
        Category(
          id: id,
          Nombre: Nombre,
          Descripcion: Descripcion,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}