import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Service.dart';
import 'ServicesPage.dart';
import 'package:proyecto/models/Service.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key}) : super(key: key);

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  late Future<List<Service>> futureServices;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    futureServices = _fetchServices();
    _searchController = TextEditingController();
  }

  Future<List<Service>> _fetchServices() async {
    final response = await http.get(Uri.parse('https://ortiza.terrabyteco.com/api/services'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      List<Service> services = jsonResponse.map((data) => Service.fromJson(data)).toList();
      return services;
    } else {
      throw Exception('Failed to load Services');
    }
  }

  List<Service> _filterServices(List<Service> services, String query) {
    return services.where((service) => service.Nombre.toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF003785),
        title: Text('Todos los servicios', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar servicio...',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Service>>(
              future: futureServices,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay datos disponibles'));
                }

                List<Service> filteredServices = _filterServices(snapshot.data!, _searchController.text);

                return ListView.builder(
                  itemCount: filteredServices.length,
                  itemBuilder: (context, index) {
                    Service service = filteredServices[index];
                    return InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServicesPage(
                              serviceId: service.id,
                            ),
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
                              child: Image.network(
                                service.imageUrl,
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
                                  const SizedBox(height: 4),
                                  Text(
                                    '${service.Descripcion}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
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
          ),
        ],
      ),
    );
  }
}
