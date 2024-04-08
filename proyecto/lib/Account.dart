import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'Perfil.dart';
import 'package:proyecto/models/Login.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late SharedPreferences _prefs;
  late Map<String, dynamic> _profileData;
  late String _accessToken;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController(); // New controller for surname
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _accessToken = _prefs.getString('accessToken') ?? '';
      _profileData =
          Map<String, dynamic>.from(jsonDecode(_prefs.getString('profile') ?? '{}'));
      _nameController.text = _profileData['name'];
      _surnameController.text = _profileData['surname'] ?? ''; // Set surname controller value
      _phoneController.text = _profileData['phone'];
      _emailController.text = _profileData['email'];
    });
  }

  Future<void> _updateUserData() async {
    if (_nameController.text.isEmpty ||
        _surnameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, completa todos los campos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String apiUrl = 'https://ortiza.terrabyteco.com/api/users/update';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'id': _profileData['id'].toString(),
        'name': _nameController.text,
        'surname': _surnameController.text, // Updated surname value
        'email': _emailController.text,
        'phone': _phoneController.text,
        'status': _profileData['status'].toString(),
        'level_id': _profileData['level_id'].toString(),
        'image': _profileData['image'] ?? '',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Perfil modificado exitosamente!'),
          backgroundColor: Colors.green,
        ),
      );

      // Llama a la función para actualizar los datos del perfil en SharedPreferences
      _updateProfileData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar los datos. Inténtalo de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Función para actualizar los datos del perfil en SharedPreferences
  Future<void> _updateProfileData() async {
    _prefs = await SharedPreferences.getInstance();
    _profileData['name'] = _nameController.text;
    _profileData['surname'] = _surnameController.text;
    _profileData['phone'] = _phoneController.text;
    _profileData['email'] = _emailController.text;
    _prefs.setString('profile', jsonEncode(_profileData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(
          'Editar cuenta',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView( // Agregar SingleChildScrollView para desplazamiento hacia abajo
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información de la cuenta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ClipOval(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('perfil-placeholder.jpg'),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Información básica',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Nombre',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _nameController,
              ),
              SizedBox(height: 10),
              Text(
                'Apellido', // New field for surname
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _surnameController,
              ),
              SizedBox(height: 10),
              Text(
                'Número de teléfono',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _phoneController,
              ),
              SizedBox(height: 10),
              Text(
                'Correo electrónico',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _emailController,
              ),
              SizedBox(height: 20),
              ElevatedButton(
  onPressed: () async {
    await _updateUserData();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PerfilPage()),
    );
  },
  child: Text('Guardar cambios'),
),

            ],
          ),
        ),
      ),
    );
  }
}
