import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto/models/Service.dart';
import 'package:proyecto/models/User.dart';
import 'package:proyecto/models/Specialist.dart';
import 'package:proyecto/models/Recommendation.dart';
import 'pedido.dart'; // Importa tu archivo Pedido.dart

class ServicesPage extends StatelessWidget {
  final int serviceId;

  const ServicesPage({Key? key, required this.serviceId}) : super(key: key);

  Future<Service> fetchService(int id) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/services/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> serviceData = jsonDecode(response.body);
      return Service.fromJson(serviceData);
    } else {
      throw Exception('Failed to load Service');
    }
  }

  Future<User> fetchUser(int userId) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/users/$userId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> userData = jsonDecode(response.body);
      return User.fromJson(userData);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<Specialist> fetchSpecialist(int specialistId) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/specialists/$specialistId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> specialistData = jsonDecode(response.body);
      return Specialist.fromJson(specialistData);
    } else {
      throw Exception('Failed to load specialist');
    }
  }

  Future<List<Recommendation>> fetchRecommendations(int serviceId) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/recommendations'));

    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body);

      List<Recommendation> recommendations = [];

      for (var data in responseData) {
        Recommendation recommendation = Recommendation.fromJson(data);
        if (recommendation.ID_Servicio == serviceId) {
          recommendations.add(recommendation);
        }
      }

      return recommendations;
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  Widget _buildStarRating(double rating) {
    int starCount = rating.floor();
    double remainder = rating - starCount;

    return Row(
      children: List.generate(
        starCount,
        (index) => Icon(
          Icons.star,
          color: Colors.amber,
          size: 20,
        ),
      ) +
      [
        if (remainder > 0)
          Icon(
            Icons.star_half,
            color: Colors.amber,
            size: 20,
          ),
      ],
    );
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
          return SingleChildScrollView(
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
                          color: selectedService.Disponibilidad == 'Fuera de servicio'
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
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (userSnapshot.hasError) {
                            return Text('${userSnapshot.error}');
                          } else {
                            User user = userSnapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PedidoPage(
          serviceName: selectedService.Nombre,
          specialistName: '${user.Nombre} ${user.Apellido}',
        ),
      ),
    );
  },
  icon: Icon(
    Icons.phone,
    color: Colors.white,
  ),
  label: Text(
    'Contratar ahora',
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
      vertical: 20,
      horizontal: 40,
    ),
  ),
),
                                const SizedBox(height: 30),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage('userplaceholder.jpg'),
                                      radius: 30,
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Calificación: ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
                                              ),
                                            ),
                                            FutureBuilder<List<Recommendation>>(
                                              future: fetchRecommendations(serviceId),
                                              builder: (context, recommendationSnapshot) {
                                                if (recommendationSnapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return CircularProgressIndicator();
                                                } else if (recommendationSnapshot.hasError) {
                                                  return Text('${recommendationSnapshot.error}');
                                                } else if (!recommendationSnapshot.hasData ||
                                                    recommendationSnapshot.data!.isEmpty) {
                                                  return Text('Sin calificaciones aún');
                                                }

                                                double averageRating = 0.0;
                                                for (Recommendation recommendation
                                                    in recommendationSnapshot.data!) {
                                                  averageRating +=
                                                      double.parse(recommendation.Calificacion);
                                                }
                                                if (recommendationSnapshot.data!.isNotEmpty) {
                                                  averageRating /=
                                                      recommendationSnapshot.data!.length;
                                                }

                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        _buildStarRating(averageRating),
                                                        const SizedBox(width: 5),
                                                        Text(
                                                          averageRating.toStringAsFixed(1),
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        FutureBuilder<Specialist>(
                                          future: fetchSpecialist(selectedService.ID_Especialista),
                                          builder: (context, specialistSnapshot) {
                                            if (specialistSnapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else if (specialistSnapshot.hasError) {
                                              return Text('${specialistSnapshot.error}');
                                            } else if (!specialistSnapshot.hasData) {
                                              return Text('Especialista no encontrado');
                                            }

                                            Specialist specialist = specialistSnapshot.data!;
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${user.Nombre} ${user.Apellido}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  ' ${specialist.Descripcion}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Reseñas de clientes:',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                FutureBuilder<List<Recommendation>>(
                                  future: fetchRecommendations(serviceId),
                                  builder: (context, recommendationSnapshot) {
                                    if (recommendationSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (recommendationSnapshot.hasError) {
                                      return Text('${recommendationSnapshot.error}');
                                    } else if (!recommendationSnapshot.hasData ||
                                        recommendationSnapshot.data!.isEmpty) {
                                      return Text('Sin reseñas aún');
                                    }

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: recommendationSnapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            Recommendation recommendation =
                                                recommendationSnapshot.data![index];
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                padding: const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    FutureBuilder<User>(
                                                      future: fetchUser(recommendation.ID_Usuario),
                                                      builder: (context, reviewerSnapshot) {
                                                        if (reviewerSnapshot.connectionState ==
                                                            ConnectionState.waiting) {
                                                          return CircularProgressIndicator();
                                                        } else if (reviewerSnapshot.hasError) {
                                                          return Text('${reviewerSnapshot.error}');
                                                        } else if (!reviewerSnapshot.hasData) {
                                                          return Text('Usuario no encontrado');
                                                        }

                                                        User reviewer = reviewerSnapshot.data!;
                                                        return Text(
                                                          'Calificación: ${recommendation.Calificacion} ',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    const SizedBox(height: 4),
                                                    _buildStarRating(double.parse(recommendation.Calificacion)),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'Comentario: ${recommendation.Comentario}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
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
