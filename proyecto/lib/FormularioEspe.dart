import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Category {
  final int id;
  final String name;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['Nombre'],
      description: json['Descripcion'],
    );
  }
}

class Speciality {
  final int id;
  final String name;
  final String description;

  Speciality({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(
      id: json['id'],
      name: json['Nombre'],
      description: json['Descripcion'],
    );
  }
}

class FormularioPage extends StatefulWidget {
  const FormularioPage({Key? key}) : super(key: key);

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  late SharedPreferences _prefs;
  late Map<String, dynamic> _profileData;
  late String _accessToken;

  List<Category> _categories = [];
  List<Speciality> _specialities = [];

  TextEditingController _descriptionController = TextEditingController(); // Controlador para el campo de descripción
  Category? _selectedCategory; // Variable para almacenar la categoría seleccionada
  Speciality? _selectedSpeciality; // Variable para almacenar la especialidad seleccionada

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchCategories();
    _fetchSpecialities();
  }

  Future<void> _loadUserData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _accessToken = _prefs.getString('accessToken') ?? '';
      _profileData =
          Map<String, dynamic>.from(jsonDecode(_prefs.getString('profile') ?? '{}'));
      _prefs.setString('name', _profileData['name']); // Guarda el nombre del usuario en SharedPreferences
    });
  }

Future<void> _registerAsSpecialist() async {
  final url = Uri.parse('https://conectapro.madiffy.com/api/specialists/create');

  // Obtener los valores del formulario
  final String description = _descriptionController.text;
  final int userId = _profileData?['id'] ?? 0;
  final int categoryId = _selectedCategory?.id ?? 0;
  final int specialityId = _selectedSpeciality?.id ?? 0;

  // Realizar la solicitud POST para registrar al especialista
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'description': description,
      'user_id': userId,
      'category_id': categoryId,
      'specialities_id': specialityId,
    }),
  );

  if (response.statusCode == 200) {
    // Éxito al registrar como especialista

    // Actualizar el nivel del usuario a 3
    final updateUrl = Uri.parse('https://conectapro.madiffy.com/api/users/update');
    final updateResponse = await http.post(
      updateUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id': userId,
        'level_id': 3,
        // Puedes incluir otros campos del perfil del usuario aquí si es necesario
        'name': _profileData?['name'] ?? '',
        'surname': _profileData?['surname'] ?? '',
        'email': _profileData?['email'] ?? '',
        'phone': _profileData?['phone'] ?? '',
        'status': _profileData?['status'] ?? 0,
        'image': _profileData?['image'] ?? '',
      }),
    );

  

    if (updateResponse.statusCode == 200) {
      // El nivel del usuario se actualizó correctamente
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Registrado como especialista correctamente'),
      ));
    } else {
      // Error al actualizar el nivel del usuario
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al actualizar el nivel del usuario'),
      ));
    }
  } else {
    // Error al registrar como especialista
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error al registrar como especialista'),
    ));
  }
}


  Future<void> _fetchCategories() async {
    final url = Uri.parse('https://conectapro.madiffy.com/api/categories');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _categories = jsonData.map((item) => Category.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> _fetchSpecialities() async {
    final url = Uri.parse('https://conectapro.madiffy.com/api/specialities');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _specialities = jsonData.map((item) => Speciality.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load specialities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text(
          'Formulario de Especialista',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Text(
              'Descripción personal:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _descriptionController, // Usa el controlador para este campo
              decoration: InputDecoration(hintText: 'Ingrese su descripción personal'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Categoría:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<Category>(
              value: _selectedCategory,
              items: _categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      ))
                  .toList(),
              onChanged: (Category? value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Seleccione una categoría',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Especialidad:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<Speciality>(
              value: _selectedSpeciality,
              items: _specialities
                  .map((speciality) => DropdownMenuItem(
                        value: speciality,
                        child: Text(speciality.description),
                      ))
                  .toList(),
              onChanged: (Speciality? value) {
                setState(() {
                  _selectedSpeciality = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Seleccione una especialidad',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _registerAsSpecialist();
              },
              child: Text('Registrarse como Especialista'),
            ),
          ],
        ),
      ),
    );
  }
}
