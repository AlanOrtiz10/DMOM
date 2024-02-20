import 'package:flutter/material.dart';
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
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    @override
    Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF003785), // Color del fondo (azul)
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
            children: <Widget>[
              // Campos de entrada para el registro
                TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: 'Nombre Completo',
                ),
                ),
                TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                    labelText: 'Usuario',
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
                onPressed: () {
                  // Validar que no haya campos vacíos
                    if (nameController.text.isEmpty ||
                        usernameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        passwordController.text.isEmpty ||
                        phoneController.text.isEmpty) {
                    // Mostrar un mensaje de error si hay campos vacíos
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Por favor, completa todos los campos.'),
                        backgroundColor: Colors.red,
                    ),
                    );
                    } else {
                    // Permitir la creación de la cuenta
                    // Aquí puedes agregar lógica adicional según tus necesidades
                    // En este ejemplo, simplemente navega a la página de inicio
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => const HomePage(title: 'Inicio'),
                        ),
                    );
                    }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Color del fondo del botón
                ),
                child: Text('Crear Cuenta', style: TextStyle(color: Colors.white), 
                ),
                ),
                SizedBox(height: 16),
                OutlinedButton(
                onPressed: () {
                  // Navegar de regreso a la página de inicio de sesión
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginPage(title: 'Login'),
                    ),
                    );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Color del fondo del botón
                ),
                child: Text('Regresar', style: TextStyle(color: Colors.white), 
                ),
                ),
            ],
            ),
        ),
        ),
    );
    }
}