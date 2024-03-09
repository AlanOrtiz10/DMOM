class Service {
  int get ID => id; 
  final int id;
  final String Nombre;
  final String Descripcion;
  final int ID_Categoria;
  final String Imagen;
  final String Disponibilidad;
  final int ID_Especialista;
  final int ID_Usuario;

  const Service({
    required this.id,
    required this.Nombre,
    required this.Descripcion,
    required this.ID_Categoria,
    required this.Imagen,
    required this.Disponibilidad,
    required this.ID_Especialista,
    required this.ID_Usuario,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'Nombre': String Nombre,
        'Descripcion': String Descripcion,
        'ID_Categoria': int ID_Categoria,
        'Imagen': String Imagen,
        'Disponibilidad': String Disponibilidad,
        'ID_Especialista': int ID_Especialista,
        'ID_Usuario': int ID_Usuario,
      } =>
        Service(
          id: id,
          Nombre: Nombre,
          Descripcion: Descripcion,
          ID_Categoria: ID_Categoria,
          Imagen: Imagen,
          Disponibilidad: Disponibilidad,
          ID_Especialista: ID_Especialista,
          ID_Usuario: ID_Usuario,
        ),
      _ => throw const FormatException('Failed to load service.'),
    };
  }
}
