import 'package:flutter/material.dart';
import 'db.dart';

class Adminpan extends StatefulWidget {
  const Adminpan({super.key});

  @override
  State<Adminpan> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<Adminpan> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    final usuarios = await _dbHelper.obtenerUsuarios();
    setState(() {
      _usuarios = usuarios;
    });
  }

  Future<void> _eliminarUsuario(int id) async {
    await _dbHelper.eliminarUsuario(id);
    _cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin. de usuarios', style: TextStyle(fontFamily: 'Clouts', 
        color: Color.fromARGB(255, 255, 255, 255), fontSize: 22),),
        backgroundColor: const Color.fromARGB(255, 140, 68, 255),
        elevation: 0,
      ),
      body:
          _usuarios.isEmpty
              ? const Center(
                child: Text(
                  'No existen usuarios aqui',
                  style: TextStyle( fontFamily: 'Clouts', fontSize:  16, color: Color.fromARGB(255, 0, 0, 0)),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _usuarios.length,
                itemBuilder: (context, index) {
                  final usuario = _usuarios[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(
                        '${usuario[DatabaseHelper().columnaNombre]} ${usuario[DatabaseHelper().columnaApellido]}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        usuario[DatabaseHelper().columnaCorreo],
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Color.fromARGB(255, 175, 41, 31)),
                        onPressed: () async {
                          final confirmar = await showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Eliminar Usuario'),
                                  content: const Text(
                                    '¿Estas seguro?'
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text(
                                        'Eliminar',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                          );

                          if (confirmar == true) {
                            await _eliminarUsuario(
                              usuario[DatabaseHelper().columnaId],
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}