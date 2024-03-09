import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ServicesPage.dart';
import 'package:proyecto/models/Service.dart';
import 'package:proyecto/models/User.dart';
import 'package:proyecto/models/Category.dart';

class CategoriesPage extends StatefulWidget {
  final int categoryId;

  const CategoriesPage({Key? key, required this.categoryId}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Future<Category> futureCategory;
  late Future<List<Service>> futureCategoryServices;

  @override
  void initState() {
    super.initState();
    futureCategory = fetchCategory(widget.categoryId);
    futureCategoryServices = fetchServices();
  }

  Future<Category> fetchCategory(int categoryId) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/categories/$categoryId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> categoryData = jsonDecode(response.body);
      return Category.fromJson(categoryData);
    } else {
      throw Exception('Failed to load category');
    }
  }

  Future<List<Service>> fetchServices() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/services/'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      List<Service> services = jsonResponse.map((data) => Service.fromJson(data)).toList();
      return services;
    } else {
      throw Exception('Failed to load services');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text('Servicios por categoria',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: Future.wait([futureCategory, futureCategoryServices]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('No hay datos disponibles');
          }

          Category category = snapshot.data![0];
          List<Service> allServices = snapshot.data![1];

          // Filtrar servicios por categoría seleccionada
          List<Service> services = allServices.where((service) => service.ID_Categoria == widget.categoryId).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
  'http://127.0.0.1:8000/assets/services/placeholder.jpg',
  width: double.infinity,
  height: 150,
  fit: BoxFit.cover,
),


              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categoría: ${category.Nombre}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    Service service = services[index];
                    return InkWell(
                      onTap: () async {
                        // Navegar a la página de detalles del servicio
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServicesPage(serviceId: service.ID),
                          ),
                        );
                      },
                      child: Container(
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
                                  Text(
                                    '${service.Nombre}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  FutureBuilder<User>(
                                    future: _fetchUser(service.ID_Usuario),
                                    builder: (context, userSnapshot) {
                                      if (userSnapshot.connectionState == ConnectionState.waiting) {
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<User> _fetchUser(int userId) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/users/$userId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> userData = jsonDecode(response.body);
      return User.fromJson(userData);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
