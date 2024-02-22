class Specialist {
  final int ID_Usuario;
  final String Descripcion;
  final int ID_Categoria;
  final String Imagen;


  const Specialist({
    required this.ID_Usuario,
    required this.Descripcion,
    required this.ID_Categoria,
    required this.Imagen,

  });

  factory Specialist.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'ID_Usuario': int ID_Usuario,
        'Descripcion': String Descripcion,
        'ID_Categoria': int ID_Categoria,
        'Imagen': String Imagen,



      } =>
        Specialist(
          ID_Usuario: ID_Usuario,
          Descripcion: Descripcion,
          ID_Categoria: ID_Categoria,
          Imagen: Imagen,

        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}