class Recommendation {
  final int id;
  final int ID_Usuario;
  final int ID_Especialista;
  final String Comentario;
  final int ID_Servicio;
  final dynamic Calificacion; // Cambié el tipo a dynamic

  Recommendation({
    required this.id,
    required this.ID_Usuario,
    required this.ID_Especialista,
    required this.Comentario,
    required this.Calificacion,
    required this.ID_Servicio,

  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'],
      ID_Usuario: json['ID_Usuario'],
      ID_Especialista: json['ID_Especialista'],
      Comentario: json['Comentario'],
      Calificacion: json['Calificacion'], // Mantén la calificación como está en el JSON
      ID_Servicio: json['ID_Servicio'],

    );
  }
}
