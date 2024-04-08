import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'Orders.dart';
import 'Account.dart';
import 'Contrataciones.dart';
import 'FormularioEspe.dart';
import 'HomePage.dart';
import 'Service.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key, this.isGuest = false, this.profileData}) : super(key: key);

  final bool isGuest;
  final Map<String, dynamic>? profileData;

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late SharedPreferences _prefs;
  Map<String, dynamic>? _profileData;
  late String _accessToken;
  int _selectedIndex = 2; // Agregar _selectedIndex como un campo de la clase

  @override
  void initState() {
    super.initState();
    if (!widget.isGuest) {
      _loadUserData();
    } else {
      // Inicializar datos de perfil y token para invitados
      _profileData = widget.profileData;
      _accessToken = '';
    }
  }

  Future<void> _loadUserData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _accessToken = _prefs.getString('accessToken') ?? '';
      _profileData =
          Map<String, dynamic>.from(jsonDecode(_prefs.getString('profile') ?? '{}'));
      _prefs.setString('name', _profileData?['name'] ?? '');
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('accessToken');
    prefs.remove('profile');
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
        backgroundColor: Colors.blue[800],
        title: Text(
          'Mi cuenta',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView( // Envuelve el contenido en SingleChildScrollView
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue[600],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
                child: Row(
                  children: [
                    ClipOval(
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage('perfil-placeholder.jpg'),
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hola,',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          widget.isGuest ? 'Invitado' : (_profileData != null ? '${_profileData?['name']} ${_profileData?['surname'] ?? ''}' : 'Invitado'),
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: widget.isGuest ? _showLoginNotification : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AccountPage()),
                        );
                      },
                      child: _buildFeatureContainer(Icons.person, 'Información personal', () {
                        widget.isGuest ? _showLoginNotification() : Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AccountPage()),
                        );
                      }),
                    ),
                    GestureDetector(
                      onTap: widget.isGuest ? _showLoginNotification : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OrdersPage()),
                        );
                      },
                      child: _buildFeatureContainer(Icons.settings, 'Mis pedidos', () {
                        widget.isGuest ? _showLoginNotification() : Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OrdersPage()),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              if (_profileData?['level_id'] == 3 && !widget.isGuest) _buildAdvancedOptions(),
              SizedBox(height: 30),
              if ((_profileData?['level_id'] == 1 || _profileData?['level_id'] == 2) && !widget.isGuest) _buildSpecialistBanner(),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: widget.isGuest ? _goToLogin : _logout,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      child: Text(
                        widget.isGuest ? 'Inicia sesión' : 'Cerrar sesión',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureContainer(IconData icon, String text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.blue,
            ),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeatureContainer(Icons.business, 'Administrar contrataciones', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContratacionesPage()),
            );
          }),
        ],
      ),
    );
  }

 Widget _buildSpecialistBanner() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column( // Utilizar Column para colocar el texto y el botón en vertical
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star,
                size: 40,
                color: Colors.white,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conviértete en Especialista',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '¡Ofrece tus servicios y aumenta tus ingresos!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormularioPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.orange,
            ),
            child: Text(
              'Convertirse',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(title: 'ConectaPro'),
      ),
    );
  }

  void _showLoginNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Necesitas iniciar sesión para acceder a esta función.'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
