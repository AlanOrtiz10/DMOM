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

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
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
    final url = Uri.parse('https://ortiza.terrabyteco.com/api/orders');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final int userId = _profileData?['id'] ?? -1;
      final List<Order> filteredOrders = jsonData
          .map((item) => Order.fromJson(item))
          .where((order) => order.user['id'] == userId)
          .toList();
      setState(() {
        _orders = filteredOrders;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load orders');
    }
  }

  void _showOrderDetails(String additionalDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles del pedido'),
          content: Text(additionalDetails),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

 Future<void> _deleteOrder(int orderId) async {
  final url = Uri.parse('https://ortiza.terrabyteco.com/api/orders/delete/$orderId');
  final response = await http.delete(url, body: {'id': orderId.toString()});

  if (response.statusCode == 200) {
    // Actualizar la lista de pedidos después de eliminar el pedido
    _fetchOrders();
    // Mostrar una alerta notificando que se eliminó correctamente la orden
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Orden eliminada'),
          content: Text('La orden ha sido eliminada correctamente.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  } else {
    throw Exception('Failed to delete order');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF003785),
        title: Text('Mis pedidos', style: TextStyle(color: Colors.white)),
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
                    final specialistName = order.specialist['name'];
                    final specialistSurname = order.specialist['surname'];
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
                              'Especialista: $specialistName $specialistSurname',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Estado del pedido: ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      displayedStatus,
                                      style: TextStyle(fontSize: 16, color: statusColor),
                                    ),
                                  ],
                                ),
                                
                              ],
                            ),
                          SizedBox(height: 15),

                            ElevatedButton(
                                  onPressed: () {
                                    _showOrderDetails(order.additionalDetails);
                                  },
                                  child: Text('Ver detalles del pedido'),
                                ),
                                 SizedBox(height: 15),
                                if (_profileData?['level_id'] != 3)
                                  ElevatedButton(
                                    onPressed: () {
                                      _deleteOrder(order.id);
                                    },
                                    child: Text('Eliminar pedido'),
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
