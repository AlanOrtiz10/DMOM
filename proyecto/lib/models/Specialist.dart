class Specialist {
  final int id;
  final String Descripcion;
  final String Imagen;
  final int ID_Usuario;
  final String ID_Categoria;
  final String ID_Especialidades;



  Specialist({
    required this.id,
    required this.Descripcion,
    required this.Imagen,
    required this.ID_Usuario,
    required this.ID_Categoria,
    required this.ID_Especialidades,


  });

  factory Specialist.fromJson(Map<String, dynamic> json) {
  return Specialist(
    id: json['id'],
    Descripcion: json['Descripcion'],
    Imagen: json['Imagen'],
    ID_Usuario: json['ID_Usuario']['id'],
    ID_Categoria: json['ID_Categoria'],
    ID_Especialidades: json['ID_Especialidades'],
  );
}

}


