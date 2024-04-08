class Recommendation {
  final int id;
  final int ID_Usuario;
  final Map<String, dynamic> ID_Especialista;
  final String Comentario;
  final int ID_Servicio;
  final double Calificacion;

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
      ID_Usuario: json['ID_Usuario']['id'],
      ID_Especialista: json['ID_Especialista'],
      Comentario: json['Comentario'],
      Calificacion: double.parse(json['Calificacion']),
      ID_Servicio: json['ID_Servicio']['id'],
    );
  }
}
