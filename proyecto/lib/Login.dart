import 'package:flutter/material.dart';
import 'Register.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF003785), // Color del fondo (azul)
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white), // Color del texto (blanco)
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
                '¡Bienvenido!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Color del texto (blanco)
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  labelStyle: TextStyle(color: Colors.grey[400]), // Color del texto del label (gris claro)
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Colors.grey[400]), // Color del texto del label (gris claro)
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Validar que los campos no estén vacíos
                  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                    // Mostrar un mensaje de error si los campos están vacíos
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Por favor, completa todos los campos.'),
                        backgroundColor: Colors.red, // Color del fondo del SnackBar (rojo)
                      ),
                    );
                  } else {
                    // Verificar si los datos ingresados son correctos
                    if (emailController.text == 'alan@gmail.com' && passwordController.text == '123') {
                      // Lógica de inicio de sesión exitosa
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(title: 'Inicio'),
                        ),
                      );
                    } else {
                      // Mostrar un mensaje de datos incorrectos
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Correo o contraseña incorrectos. Inténtalo de nuevo.'),
                          backgroundColor: Colors.red, // Color del fondo del SnackBar (rojo)
                        ),
                      );
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF003785)), // Color del fondo del botón (azul)
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 20)), // Padding horizontal de 10px
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Establecer el border radius a 30px
                  )),
                ),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Iniciar sesión',
                    style: TextStyle(color: Colors.white), // Color del texto del botón (blanco)
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Navegar a la página de registro
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(title: 'Registro'),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10), // Padding horizontal de 10px
                ),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    '¿No tienes una cuenta? Regístrate',
                    style: TextStyle(color: Color(0xFF003785)), // Color azul
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
