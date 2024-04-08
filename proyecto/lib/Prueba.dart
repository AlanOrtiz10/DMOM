import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'Register.dart';
import 'Login.dart';
import 'package:proyecto/models/Login.dart';
import 'Prueba.dart'; // Importa Prueba.dart

class PruebaPage extends StatefulWidget {
  const PruebaPage({Key? key}) : super(key: key);

  @override
  State<PruebaPage> createState() => _PruebaPageState();
}

class _PruebaPageState extends State<PruebaPage> {
  late SharedPreferences _prefs;
  late Map<String, dynamic> _profileData;
  late String _accessToken;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
  _prefs = await SharedPreferences.getInstance();
  setState(() {
    _accessToken = _prefs.getString('accessToken') ?? '';
    _profileData = Map<String, dynamic>.from(jsonDecode(_prefs.getString('profile') ?? '{}'));
    _prefs.setString('name', _profileData['name']); // Guarda el nombre del usuario en SharedPreferences
  });
}


  Future<void> _logout() async {
    // Eliminar los datos de sesión de SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('accessToken');
    prefs.remove('profile');
    // Redirigir a LoginPage después de cerrar sesión
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(title: 'ConectaPro'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Token de Acceso:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _accessToken,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Datos de Perfil:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Nombre: ${_profileData['name']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Apellido: ${_profileData['surname']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Correo Electrónico: ${_profileData['email']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Teléfono: ${_profileData['phone']}',
              style: TextStyle(fontSize: 16),
            ),
            // Agrega más campos según sea necesario
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(title: 'Inicio'),
                  ),
                );
              },
              child: Text('Ir a HomePage'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _logout,
              child: Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
