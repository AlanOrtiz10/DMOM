import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Service.dart';
import 'ServicesPage.dart';
import 'Perfil.dart';
import 'CategoriesPage.dart';
import 'package:proyecto/models/Specialist.dart';
import 'package:proyecto/models/Category.dart';
import 'package:proyecto/models/User.dart';
import 'package:proyecto/models/Service.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Índice de la página seleccionada
  List<Category> categories = [];
  late Future<List<Service>> futureServices;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    futureServices = _fetchServices();
  }

   Future<User> _fetchUser(int userId) async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/users/$userId'));

  if (response.statusCode == 200) {
    Map<String, dynamic> userData = jsonDecode(response.body);
    return User.fromJson(userData);
  } else {
    print('Error al cargar datos del usuario. Código de estado: ${response.statusCode}');
    print('Respuesta: ${response.body}');
    throw Exception('Failed to load user');
  }
}

  Future<void> _fetchCategories() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/categories'));

    if (response.statusCode == 200) {
      List<dynamic> categoryData = jsonDecode(response.body);
      List<Category> fetchedCategories = categoryData.map((data) => Category.fromJson(data)).toList();

      setState(() {
        categories = fetchedCategories;
      });
    } else {
      print('Error al cargar las categorías.');
    }
  }

  Future<List<Service>> _fetchServices() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/services'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      List<Service> services = jsonResponse.map((data) => Service.fromJson(data)).toList();
      return services;
    } else {
      throw Exception('Failed to load Services');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Hola, Alan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '20 Feb 2024',
                        style: TextStyle(
                          color: Colors.blue[200],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Busca el servicio que necesites...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  '¿Cómo te podemos ayudar hoy?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  height: 160.0,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: true,
                  viewportFraction: 0.33,
                  aspectRatio: 16 / 9,
                  onPageChanged: (index, reason) {},
                ),
                itemCount: categories.length,
                itemBuilder: (context, index, realIndex) {
                  Category category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      // Navegar a CategoriesPage y pasar el ID de la categoría
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoriesPage(categoryId: category.id),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 120.0, // Ajusta la altura deseada
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('servicios.jpg'), // Ajusta la ruta de la imagen
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              category.Nombre,
                              style: TextStyle(color: Colors.black, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Servicios Populares',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    FutureBuilder<List<Service>>(
                      future: futureServices,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Text('No hay datos disponibles');
                        }

                        return Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Service service = snapshot.data![index];
return InkWell(
  onTap: () async {
    // Navegar a la página de detalles del servicio
    // Puedes implementar esto según tus necesidades
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
                    future: _fetchUser(service.ID_Usuario),
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
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Agregar BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[600],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navegar a la página correspondiente según el índice seleccionado
    switch (_selectedIndex) {
      case 0:
        // Página de inicio
        break;
      case 1:
        // Página de búsqueda
        // Puedes implementar la navegación según tus necesidades
        break;
      case 2:
        // Página de perfil
         Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PerfilPage()),
      );
        break;
    }
  }

 

}
