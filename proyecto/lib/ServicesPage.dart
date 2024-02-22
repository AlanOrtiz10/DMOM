import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:proyecto/models/Service.dart';
import 'package:proyecto/models/User.dart';
import 'package:proyecto/models/Specialist.dart'; // Importa el modelo Specialist

class ServicesPage extends StatelessWidget {
  final int serviceId;

  const ServicesPage({Key? key, required this.serviceId}) : super(key: key);

  Future<Service> fetchService(int id) async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/services/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> serviceData = jsonDecode(response.body);
      return Service.fromJson(serviceData);
    } else {
      throw Exception('Failed to load Service');
    }
  }

  Future<User> fetchUser(int userId) async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/users/$userId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> userData = jsonDecode(response.body);
      return User.fromJson(userData);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<Specialist> fetchSpecialist(int specialistId) async {
    final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/specialists/$specialistId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> specialistData = jsonDecode(response.body);
      return Specialist.fromJson(specialistData);
    } else {
      throw Exception('Failed to load specialist');
    }
  }

  void _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la aplicación de llamadas.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    backgroundColor: Colors.blue[900],

        title: Text(
            'Detalles del Servicio',
            style: TextStyle(color: Colors.white),
            ),
      ),
      body: FutureBuilder<Service>(
        future: fetchService(serviceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No hay datos disponibles'));
          }

          Service selectedService = snapshot.data!;
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  child: Image.asset(
                    'servicios.jpg',
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        ' ${selectedService.Disponibilidad}',
                        style: TextStyle(
                          color: selectedService.Disponibilidad ==
                                  'Fuera de servicio'
                              ? Colors.red[400]
                              : Colors.green[300],
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${selectedService.Nombre}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${selectedService.Descripcion}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 15),
                      FutureBuilder<User>(
                        future: fetchUser(selectedService.ID_Usuario),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (userSnapshot.hasError) {
                            return Text('${userSnapshot.error}');
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _launchPhone(
                                        userSnapshot.data!.Telefono);
                                  },
                                  icon: Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    'Contratar ahora: ${userSnapshot.data!.Telefono}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 40),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          AssetImage('userplaceholder.jpg'),
                                      radius: 30,
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${userSnapshot.data!.Nombre} ${userSnapshot.data!.Apellido}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                FutureBuilder<Specialist>(
                                  future: fetchSpecialist(
                                      userSnapshot.data!.id),
                                  builder: (context, specialistSnapshot) {
                                    if (specialistSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (specialistSnapshot.hasError) {
                                      return Text(
                                          '${specialistSnapshot.error}');
                                    } else {
                                      return Wrap(
                                        children: [
                                          Text(
                                            '${specialistSnapshot.data!.Descripcion}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                                      ],
                                    ),
                                  ],
                                ),
                                
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
