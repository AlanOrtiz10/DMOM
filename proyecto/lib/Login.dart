import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'Prueba.dart';
import 'Register.dart';
import 'package:proyecto/models/Login.dart';
import 'HomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isHovered = false;

  Future<void> loginUser(Login loginData) async {
    final String apiUrl = 'https://ortiza.terrabyteco.com/api/login';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginData.toJson()),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['message'] == 'success') {
        // Guardar datos de sesión en SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('accessToken', responseData['access_token']);
        prefs.setString('profile', jsonEncode(responseData['profile']));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(title: "ConectaPro"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Correo o contraseña incorrectos. Inténtalo de nuevo.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión. Inténtalo de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _login() async {
    try {
      await loginUser(Login(
        email: emailController.text,
        password: passwordController.text,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _guestLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('accessToken'); // Eliminar cualquier token de acceso existente
    prefs.remove('profile'); // Eliminar cualquier perfil existente
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(title: "ConectaPro", isGuest: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Wrap your Scaffold with SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 80.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 32),
              Text(
                '¡Bienvenido de nuevo!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Poppins-Bold',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Nos alegra verte de nuevo en ConectaPro. Ingresa tus datos para continuar.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontFamily: 'Poppins-Regular',
                ),
              ),
              SizedBox(height: 32),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail_outline, size: 20),
                  labelText: 'Correo electrónico',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline, size: 20),
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _login,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 30, vertical: 30)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
                ),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Iniciar sesión',
                    style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'Poppins-Bold'),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _guestLogin,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 30, vertical: 30)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
                ),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Iniciar sesión como invitado',
                    style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'Poppins-Bold'),
                  ),
                ),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(title: 'Registro'),
                    ),
                  );
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(8),
                    color: isHovered ? Colors.black : Colors.transparent,
                  ),
                  child: Text(
                    '¿No tienes una cuenta? Registrate',
                    style: TextStyle(fontSize: 15, color: isHovered ? Colors.white : Colors.grey[600], fontFamily: 'Poppins-Regular'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
