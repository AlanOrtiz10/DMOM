import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Order {
  final int id;
  final Map<String, dynamic> user;
  final Map<String, dynamic> specialist;
  final Map<String, dynamic> service;
  final String name;
  final String phone;
  final String email;
  final String additionalDetails;
  String orderStatus; // Cambiado a no final para actualizar dinámicamente
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.user,
    required this.specialist,
    required this.service,
    required this.name,
    required this.phone,
    required this.email,
    required this.additionalDetails,
    required this.orderStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
  return Order(
    id: json['id'],
    user: json['user'],
    specialist: json['specialist'],
    service: json['service'],
    name: json['name'] ?? '',
    phone: json['phone'] ?? '',
    email: json['email'] ?? '',
    additionalDetails: json['additional_details'] ?? '',
    orderStatus: json['order_status'] ?? '',
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
  );
}

}

class ContratacionesPage extends StatefulWidget {
  @override
  _ContratacionesPageState createState() => _ContratacionesPageState();
}

class _ContratacionesPageState extends State<ContratacionesPage> {
  late SharedPreferences _prefs;
  late String _accessToken;
  late Map<String, dynamic>? _profileData;
  bool _isLoading = true;
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _accessToken = _prefs.getString('accessToken') ?? '';
      _profileData = jsonDecode(_prefs.getString('profile') ?? '{}');
    });
  }

 
  Future<void> _fetchOrders() async {
  final url = Uri.parse('https://conectapro.madiffy.com/api/orders');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    final int userId = _profileData?['id'] ?? -1;
    final List<Order> filteredOrders = jsonData
        .map((item) => Order.fromJson(item))
        .where((order) => order.specialist['ID_Usuario'] == userId)
        .toList();
    setState(() {
      _orders = filteredOrders;
      _isLoading = false;
    });
  } else {
    throw Exception('Failed to load orders');
  }
}


  void _showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Detalles de la contratación',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          contentPadding: EdgeInsets.all(24),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detalles del servicio:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 4),
                Text(
                  order.additionalDetails,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                Text(
                  'Detalles de contacto:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 4),
                Text(
                  'Nombre: ${order.name}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Teléfono: ${order.phone}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Email: ${order.email}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar', style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }

Future<void> _updateOrderStatus(int orderId, String newStatus) async {
  final url = Uri.parse('https://conectapro.madiffy.com/api/orders/update');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'id': orderId,
      'order_status': newStatus,
    }),
  );

  if (response.statusCode == 200) {
    setState(() {
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index].orderStatus = newStatus;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Estado del pedido actualizado correctamente'),
    ));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error al actualizar el estado del pedido'),
    ));
  }
}




 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color(0xFF003785),
      title: Text('Mis contrataciones', style: TextStyle(color: Colors.white)),
    ),
    body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : _orders.isEmpty
            ? Center(
                child: Text(
                  'Aún no cuentas con ninguna contratación creada.',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  final userName = order.user['name'];
                  final userSurname = order.user['surname'];
                  final orderStatus = order.orderStatus;
                  Color statusColor;
                  switch (orderStatus) {
                    case 'pending':
                      statusColor = Colors.orange;
                      break;
                    case 'Aceptado':
                      statusColor = Colors.green;
                      break;
                    case 'Completado':
                      statusColor = Colors.red;
                      break;
                    default:
                      statusColor = Colors.black;
                  }
                  final displayedStatus =
                      orderStatus == 'pending' ? 'Pendiente de aceptación' : orderStatus;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pedido #${order.id}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Servicio: ${order.service['name']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Cliente: $userName $userSurname',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Estado del pedido: ',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            displayedStatus,
                            style: TextStyle(fontSize: 16, color: statusColor),
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {
                              _showOrderDetails(order);
                            },
                            child: Text('Ver detalles del pedido'),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _updateOrderStatus(order.id, 'Aceptado');
                                },
                                child: Text('Aceptar pedido'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _updateOrderStatus(order.id, 'Completado');
                                },
                                child: Text('Marcar como completado'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
  );
}
}
