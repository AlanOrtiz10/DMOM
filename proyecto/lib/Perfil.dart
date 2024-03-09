import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
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
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue[600], // Fondo azul para la pantalla
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60.0), // Border radius de 60 arriba
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white, // Fondo blanco solo para la sección "Hola"
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
                          color: Colors.grey[700], // Texto gris oscuro
                        ),
                      ),
                      Text(
                        'Alan Ortiz',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.black, // Texto gris oscuro
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20.0), // Añadido padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFeatureContainer(Icons.person, 'Información personal'),
                  _buildFeatureContainer(Icons.settings, 'Mis pedidos'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureContainer(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 5), // Añadido margen horizontal mínimo
        decoration: BoxDecoration(
          color: Colors.white, // Fondo blanco
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.blue,
            ),
            SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black, // Texto negro
              ),
            ),
          ],
        ),
      ),
    );
  }
}
