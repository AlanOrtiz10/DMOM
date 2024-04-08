import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'Prueba.dart';
import 'HomePage.dart';
import 'Perfil.dart'; // Importa la página de perfil
import 'Service.dart'; // Importa la página de servicios
import 'CategoriesPage.dart'; // Importa la página de categorías

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');
  runApp(MyApp(accessToken: accessToken));
}

class MyApp extends StatelessWidget {
  final String? accessToken;

  const MyApp({Key? key, this.accessToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ConectaPro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/', // Ruta inicial de la aplicación
      routes: {
        '/': (context) => accessToken != null ? HomePage(title: 'ConectaPro') : LoginPage(title: 'ConectaPro'),
        '/perfil': (context) => PerfilPage(), // Ruta de la página de perfil
        '/services': (context) => ServicePage(), // Ruta de la página de servicios
        // Agrega más rutas según sea necesario
      },
    );
  }
}
