import 'package:flutter/material.dart';
import 'maps.dart';
import 'db.dart';
import 'maps.dart';


class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bienvenido@", style: TextStyle(fontFamily: 'Clouts'),),
        backgroundColor: const Color.fromARGB(255, 140, 68, 255),
      ),

      body: Center(
        child: Container(
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapsScreen()));
            }, child: Text("Mapa",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'McLaren',
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),),

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              elevation: 5,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(double.infinity,50)
            ),
            ),
        ),
      )
        
    );
  }
}