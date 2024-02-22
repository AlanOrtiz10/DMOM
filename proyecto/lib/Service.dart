import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto/models/Specialist.dart';
import 'package:proyecto/models/Category.dart';
import 'package:proyecto/models/Service.dart';
import 'ServicesPage.dart';
import 'package:proyecto/models/User.dart';
import 'dart:convert';

Future<List<Service>> fetchServices() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/services'));

  if (response.statusCode == 200) {
    Iterable jsonResponse = jsonDecode(response.body);
    List<Service> services = jsonResponse
        .map((data) => Service.fromJson(data))
        .toList();
    return services;
  } else {
    throw Exception('Failed to load Services');
  }
}

Future<Category> fetchCategory(int categoryId) async {
  final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/categories/$categoryId'));

  if (response.statusCode == 200) {
    Map<String, dynamic> categoryData = jsonDecode(response.body);
    return Category.fromJson(categoryData);
  } else {
    throw Exception('Failed to load category');
  }
}

Future<List<Specialist>> fetchSpecialists() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/specialists'));

  if (response.statusCode == 200) {
    Iterable jsonResponse = jsonDecode(response.body);
    List<Specialist> Specialists =
        jsonResponse.map((data) => Specialist.fromJson(data)).toList();
    return Specialists;
  } else {
    throw Exception('Failed to load Specialists');
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

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  late Future<List<Service>> futureServices;

  @override
  void initState() {
    super.initState();
    futureServices = fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<Service>>(
        future: futureServices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No hay datos disponibles');
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Service service = snapshot.data![index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServicesPage(serviceId: service.ID),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Image.asset(
                          'servicios.jpg',
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${service.Nombre}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                FutureBuilder<User>(
                                  future: fetchUser(service.ID_Usuario),
                                  builder: (context, userSnapshot) {
                                    if (userSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (userSnapshot.hasError) {
                                      return Text('${userSnapshot.error}');
                                    } else {
                                      return Text(
                                        '${userSnapshot.data!.Nombre} ${userSnapshot.data!.Apellido}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${service.Descripcion}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${service.Disponibilidad}',
                              style: TextStyle(
                                color: service.Disponibilidad == 'Fuera de servicio'
                                    ? Colors.red[400]
                                    : Colors.green[300],
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ServicesPage extends StatelessWidget {
  final int serviceId;

  const ServicesPage({Key? key, required this.serviceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Aquí puedes implementar la lógica para cargar los detalles del servicio usando serviceId.
    // Puedes usar FutureBuilder o cualquier otro método según tus necesidades.
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Servicio'),
      ),
      body: Center(
        child: Text('Detalles del Servicio ID: $serviceId'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Service Page',
    home: ServicePage(title: 'Service Page'),
  ));
}
