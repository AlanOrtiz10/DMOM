import 'package:flutter/material.dart';
import 'Categories.dart';
import 'Recommendations.dart';
import 'Services.dart';
import 'Specialist.dart';
import 'Specialities.dart';
import 'Users.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: 
      ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          // InkWell for 'Categorias' with navigation
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoriesPage(title: 'Categorias')),
              );
            },
            child: Container(
              height: 50,
              color: Colors.blue[500],
              child: const Center(child: Text('Categorias')),
            ),
          ),

          // InkWell for 'Recommendations'
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RecommendationsPage(title: 'Recommendations')),
              );
            },
            child: Container(
              height: 50,
              color: Colors.green[500],
              child: const Center(child: Text('Recommendations')),
            ),
          ),

          // InkWell for 'Services'
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ServicesPage(title: 'Services')),
              );
            },
            child: Container(
              height: 50,
              color: Colors.orange[500],
              child: const Center(child: Text('Services')),
            ),
          ),

          // InkWell for 'Specialist'
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SpecialistPage(title: 'Specialist')),
              );
            },
            child: Container(
              height: 50,
              color: Colors.purple[500],
              child: const Center(child: Text('Specialist')),
            ),
          ),

          // InkWell for 'Specialities'
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SpecialitiesPage(title: 'Specialities')),
              );
            },
            child: Container(
              height: 50,
              color: Colors.yellow[500],
              child: const Center(child: Text('Specialities')),
            ),
          ),

          // InkWell for 'Users'
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UsersPage(title: 'Users')),
              );
            },
            child: Container(
              height: 50,
              color: Colors.red[500],
              child: const Center(child: Text('Users')),
            ),
          ),
        ],
      ),
    );
  }
}
