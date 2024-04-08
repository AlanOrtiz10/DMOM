import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'Login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Future<void> _register() async {
    try {
      final response = await http.post(
        Uri.parse('https://conectapro.madiffy.com/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameController.text,
          'surname': surnameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
       if (responseData['message'] == 'success') {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('accessToken', responseData['access_token']);
  prefs.setString('profile', jsonEncode(responseData['profile'])); // Guardar datos del perfil del usuario
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Registro exitoso'),
      backgroundColor: Colors.green,
    ),
  );
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const HomePage(title: "ConectaPro"),
    ),
  );
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error en el registro. Por favor, intenta de nuevo.'),
      backgroundColor: Colors.red,
    ),
  );
}

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en el registro. Por favor, intenta de nuevo.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error en el registro. Por favor, intenta de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF003785),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Crea una cuenta',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                ),
              ),
              TextFormField(
                controller: surnameController,
                decoration: InputDecoration(
                  labelText: 'Apellido',
                ),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                ),
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                ),
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Número de Celular',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _register,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF003785)),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )),
                ),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Registrarme',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(title: 'Login'),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Regresar a inicio de sesión',
                    style: TextStyle(color: Color(0xFF003785)),
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
