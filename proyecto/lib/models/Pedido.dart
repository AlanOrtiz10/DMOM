class Pedido {
  final int id;
  final Usuario user;
  final Especialista specialist;
  final Servicio service;
  final String name;
  final String phone;
  final String email;
  final String additionalDetails;
  final String orderStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pedido({
    required this.id,
    required this.user,
    required this.specialist,
    required this.service,
    required this.name,
    required this.phone,
    required this.email,
    required this.additionalDetails,
    required this.orderStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      user: Usuario.fromJson(json['user']),
      specialist: Especialista.fromJson(json['specialist']),
      service: Servicio.fromJson(json['service']),
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      additionalDetails: json['additional_details'],
      orderStatus: json['order_status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Usuario {
  final int id;
  final String name;
  final String surname;

  Usuario({
    required this.id,
    required this.name,
    required this.surname,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
    );
  }
}

class Especialista {
  final int id;
  final String name;
  final String surname;

  Especialista({
    required this.id,
    required this.name,
    required this.surname,
  });

  factory Especialista.fromJson(Map<String, dynamic> json) {
    return Especialista(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
    );
  }
}

class Servicio {
  final int id;
  final String name;

  Servicio({
    required this.id,
    required this.name,
  });

  factory Servicio.fromJson(Map<String, dynamic> json) {
    return Servicio(
      id: json['id'],
      name: json['name'],
    );
  }
}
