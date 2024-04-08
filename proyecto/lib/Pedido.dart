import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'HomePage.dart';
import 'Orders.dart';

class PedidoPage extends StatefulWidget {
  final int serviceId;
  final int specialistId;
  final String serviceName;
  final String specialistName;

  PedidoPage({
    Key? key,
    required this.serviceId,
    required this.specialistId,
    required this.serviceName,
    required this.specialistName,
  }) : super(key: key);

  @override
  _PedidoPageState createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  late SharedPreferences _prefs;
  late String _accessToken;
  late Map<String, dynamic>? _profileData;
  TextEditingController nombreController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController correoController = TextEditingController();
  TextEditingController detallesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _accessToken = _prefs.getString('accessToken') ?? '';
      _profileData = jsonDecode(_prefs.getString('profile') ?? '{}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF003785),
        title: Text('Resumen de Pedido', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalles del Pedido',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Nombre del servicio: ${widget.serviceName}', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Nombre del especialista: ${widget.specialistName}', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Text('Datos de contacto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextFormField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre completo'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: telefonoController,
              decoration: InputDecoration(labelText: 'Número de teléfono'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: correoController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: detallesController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Detalles adicionales'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_camposCompletos()) {
                  _enviarPedido();
                } else {
                  _mostrarMensajeError(context);
                }
              },
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
                  'Enviar Pedido',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _enviarPedido() async {
    final url = Uri.parse('https://ortiza.terrabyteco.com/api/orders/create');
    final response = await http.post(
      url,
      body: {
        'name': nombreController.text,
        'phone': telefonoController.text,
        'email': correoController.text,
        'additional_details': detallesController.text,
        'service_id': widget.serviceId.toString(),
        'specialist_id': widget.specialistId.toString(),
        'user_id': _profileData?['id'].toString() ?? '',
        'order_status': 'pending',
      },
    );

    if (response.statusCode == 201) {
      _mostrarDialogo(context, 'Pedido recibido',
          'El pedido se envió con éxito. Pronto el especialista se pondrá en contacto para revisar tu solicitud.');
    } else {
      _mostrarDialogo(context, 'Error', 'Hubo un error al enviar el pedido. Por favor, inténtalo de nuevo.');
    }
  }

  Future<void> _mostrarDialogo(BuildContext context, String titulo, String mensaje) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
                const SizedBox(height: 20),
                Text(
                  titulo,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  mensaje,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                Navigator.of(context).pop(); // Cierra el AlertDialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersPage()), // Reemplaza 'HomePage()' con la clase que representa tu página de inicio
                );
              },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF003785)),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
                  ),
                  child: Text(
                    'Ver mis pedidos',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _mostrarMensajeError(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 20),
                Text(
                  'Error',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Por favor, completa todos los campos antes de enviar el pedido.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
                  ),
                  child: Text(
                    'Aceptar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _camposCompletos() {
    return nombreController.text.isNotEmpty &&
        telefonoController.text.isNotEmpty &&
        correoController.text.isNotEmpty &&
        detallesController.text.isNotEmpty;
  }
}
