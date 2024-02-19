import 'package:flutter/material.dart';


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
      home: const SpecialitiesPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class SpecialitiesPage extends StatefulWidget {
  const SpecialitiesPage({super.key, required this.title});
  final String title;

  @override
  State<SpecialitiesPage> createState() => _SpecialitiesPageState();
}

class _SpecialitiesPageState extends State<SpecialitiesPage> {
 

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
         Container(
              margin: EdgeInsets.all(16),
              child: Text(
                'Specialities',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

