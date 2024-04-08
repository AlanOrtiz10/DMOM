class Category {
  final int id;
  final String Nombre;
  final String Descripcion;
  final String Imagen;

  const Category({
    required this.id,
    required this.Nombre,
    required this.Descripcion,
    required this.Imagen,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      Nombre: json['Nombre'],
      Descripcion: json['Descripcion'],
      Imagen: json['Imagen'],
    );
  }

  String get imageUrl => 'https://conectapro.madiffy.com/assets/categories/$Imagen';
}
