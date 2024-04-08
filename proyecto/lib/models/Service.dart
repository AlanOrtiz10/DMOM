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
  return Service(
    id: json['id'],
    Nombre: json['Nombre'],
    Descripcion: json['Descripcion'],
    ID_Categoria: json['ID_Categoria']['id'], // Accede al campo 'id' dentro del objeto 'ID_Categoria'
    Imagen: json['Imagen'],
    Disponibilidad: json['Disponibilidad'],
    ID_Especialista: json['ID_Especialista']['id'], // Accede al campo 'id' dentro del objeto 'ID_Especialista'
    ID_Usuario: json['ID_Usuario'], // Esto es un valor entero
  );
}


  String get imageUrl => 'https://conectapro.madiffy.com/assets/services/$Imagen';
}
