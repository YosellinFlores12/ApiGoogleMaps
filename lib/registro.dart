import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'db.dart';

class registro extends StatefulWidget {
  const registro({super.key});

  @override
  State<registro> createState() => _registroState();
}

class _registroState extends State<registro> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final nombre = TextEditingController();
  final apellido = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  bool passwordVisible = false;
  Icon passwordIcon = const Icon(Icons.visibility_off);

  bool passwordConfVisible = false;
  Icon passwordConfIcon = const Icon(Icons.visibility_off);

  Future<void> _registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      if (password.text != confirmPassword.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No coinciden las contraseñas")),
        );
        return;
      }

      // Verificar si el correo ya está registrado
      Map<String, dynamic>? usuarioExistente =
          await DatabaseHelper().obtenerUsuarioPorCorreo(email.text);
      if (usuarioExistente != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Ya está registrado el correo")),
        );
        return;
      }

      // Crear un mapa con los datos del usuario
      Map<String, dynamic> usuario = {
        DatabaseHelper().columnaNombre: nombre.text,
        DatabaseHelper().columnaApellido: apellido.text,
        DatabaseHelper().columnaCorreo: email.text,
        DatabaseHelper().columnaContrasena:
            password.text, // Encriptar aquí si es necesario
      };

      try {
        // Insertar el usuario en la base de datos
        int resultado = await DatabaseHelper().insertarUsuario(usuario);
        if (resultado != 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Usuario registrado")),
          );

          // Limpiar el formulario después del registro
          nombre.clear();
          apellido.clear();
          email.clear();
          password.clear();
          confirmPassword.clear();

          // Regresar a la pantalla de inicio de sesión
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error al registrar")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de usuario", style: TextStyle(color: Colors.white, fontFamily: 'McLaren')),
        backgroundColor: const Color.fromARGB(255, 140, 68, 255),
      ),
      body: AnimatedBackground(
        behaviour: RacingLinesBehaviour(
          direction: LineDirection.Ltr,
          numLines: 20,
        ),
        vsync: this,
        child: ListView(
          children: [
            SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        "Registrate",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 50,
                          fontFamily: 'Clouts',
                          color: const Color.fromARGB(255, 140, 68, 255),
                        ),
                      ).animate().fadeIn(duration: 500.ms).scale(),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: nombre,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Ingresa tu nombre";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Nombre",
                                labelStyle: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'McLaren',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: const Color.fromARGB(255, 140, 68, 255),
                                    width: 2.0,
                                  ),
                                ),
                                prefixIcon: const Icon(Icons.person,
                                    color: const Color.fromARGB(255, 140, 68, 255)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                              ),
                              style: const TextStyle(fontSize: 14),
                            )
                                .animate()
                                .fadeIn(duration: 500.ms)
                                .slideX(begin: -0.1),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: apellido,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Ingresa tu apellido";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Apellido",
                                labelStyle: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'McLaren',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: const Color.fromARGB(255, 140, 68, 255),
                                    width: 2.0,
                                  ),
                                ),
                                prefixIcon: const Icon(Icons.person,
                                    color: const Color.fromARGB(255, 140, 68, 255)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                              ),
                              style: const TextStyle(fontSize: 14),
                            )
                                .animate()
                                .fadeIn(duration: 500.ms)
                                .slideX(begin: 0.1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: email,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Ingresa tu correo electrónico";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Correo Electronico",
                          labelStyle: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'McLaren',
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: const Color.fromARGB(255, 140, 68, 255),
                              width: 2.0,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: const Color.fromARGB(255, 140, 68, 255)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ).animate().fadeIn(duration: 500.ms).slideY(),
                      const SizedBox(height: 20),
                      TextFormField(
                        obscureText: passwordVisible ? false : true,
                        controller: password,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Ingresa tu contraseña";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          labelStyle: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'McLaren',
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color:  Color.fromARGB(255, 140, 68, 255),
                              width: 2.0,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.password_outlined,
                              color:  Color.fromARGB(255, 140, 68, 255)),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                                if (passwordVisible) {
                                  passwordIcon = const Icon(Icons.visibility,
                                      color:  Color.fromARGB(255, 140, 68, 255));
                                } else {
                                  passwordIcon = const Icon(
                                      Icons.visibility_off,
                                      color:  Color.fromARGB(255, 140, 68, 255));
                                }
                              });
                            },
                            icon: passwordIcon,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
                      const SizedBox(height: 20),
                      TextFormField(
                        obscureText: passwordConfVisible ? false : true,
                        controller: confirmPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Ingresa la confirmación de contraseña";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Confirmar contraseña",
                          labelStyle: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'McLaren',
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color:  Color.fromARGB(255, 140, 68, 255),
                              width: 2.0,
                            ),
                          ),
                          prefixIcon:
                              const Icon(Icons.looks, color: Color.fromARGB(255, 140, 68, 255)),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordConfVisible = !passwordConfVisible;
                                if (passwordConfVisible) {
                                  passwordConfIcon = const Icon(
                                      Icons.visibility,
                                     color: Color.fromARGB(255, 140, 68, 255));
                                } else {
                                  passwordConfIcon = const Icon(
                                      Icons.visibility_off,
                                      color:  Color.fromARGB(255, 140, 68, 255));
                                }
                              });
                            },
                            icon: passwordConfIcon,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _registrarUsuario,
                        child: const Text(
                          "Registrarse",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'McLaren',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 140, 68, 255),
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ).animate().fadeIn(duration: 500.ms).scale(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'McLaren',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ).animate().fadeIn(duration: 500.ms).scale(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
