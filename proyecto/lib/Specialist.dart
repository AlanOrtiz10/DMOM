import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto/models/Specialist.dart';
import 'package:proyecto/models/Category.dart';
import 'package:proyecto/models/User.dart';
import 'dart:convert';

Future<List<Specialist>> fetchSpecialists() async {
  final response =
      await http.get(Uri.parse('https://ortiza.terrabyteco.com/api/specialists'));

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
      await http.get(Uri.parse('https://ortiza.terrabyteco.com/api/users/$userId'));

  if (response.statusCode == 200) {
    Map<String, dynamic> userData = jsonDecode(response.body);
    return User.fromJson(userData);
  } else {
    throw Exception('Failed to load user');
  }
}

Future<Category> fetchCategory(int categoryId) async {
  final response = await http.get(
      Uri.parse('https://ortiza.terrabyteco.com/api/categories/$categoryId'));

  if (response.statusCode == 200) {
    Map<String, dynamic> categoryData = jsonDecode(response.body);
    return Category.fromJson(categoryData);
  } else {
    throw Exception('Failed to load category');
  }
}

class SpecialistPage extends StatefulWidget {
  const SpecialistPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SpecialistPage> createState() => _SpecialistPageState();
}

class _SpecialistPageState extends State<SpecialistPage> {
  late Future<List<Specialist>> futureSpecialists;

  @override
  void initState() {
    super.initState();
    futureSpecialists = fetchSpecialists();
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
      body: FutureBuilder<List<Specialist>>(
        future: futureSpecialists,
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
              Specialist specialist = snapshot.data![index];
              return InkWell(
                onTap: () {
                  // Lógica cuando se toque la tarjeta
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
                            FutureBuilder<User>(
                              future: fetchUser(specialist.ID_Usuario),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (userSnapshot.hasError) {
                                  return Text('${userSnapshot.error}');
                                } else {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${userSnapshot.data!.Nombre} ${userSnapshot.data!.Apellido}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      FutureBuilder<Category>(
                                        future: fetchCategory(
                                            specialist.ID_Categoria),
                                        builder: (context, categorySnapshot) {
                                          if (categorySnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (categorySnapshot.hasError) {
                                            return Text(
                                                '${categorySnapshot.error}');
                                          } else {
                                            return Text(
                                              '${categorySnapshot.data!.Nombre}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 4),
                            Text(
                              specialist.Descripcion,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Disponible',
                              style: TextStyle(
                                color: Colors.green[300],
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
