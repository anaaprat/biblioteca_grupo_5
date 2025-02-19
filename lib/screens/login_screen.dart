import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/services/auth_service.dart';
import 'user_screen.dart';
import 'admin_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoading = false;

  void _login() async {
    final BuildContext currentContext = context;
    setState(() {
      isLoading = true;
    });

    final result = await authService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (result.containsKey("token") && result.containsKey("role")) {
      String token = result["token"];
      String role = result["role"];

      ScaffoldMessenger.of(currentContext).showSnackBar(
        const SnackBar(
          content: Text("Login successful"),
          backgroundColor: Colors.green,
        ),
      );

      // Redirigir según el rol
      if (role == "USER") {
        Navigator.pushReplacement(
          currentContext,
          MaterialPageRoute(builder: (context) => UserScreen()),
        );
      } else if (role == "ADMIN") {
        Navigator.pushReplacement(
          currentContext,
          MaterialPageRoute(
            builder: (context) => AdminScreen(token: token),
          ),
        );
      } else {
        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(
            content: Text("Unknown role"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(currentContext).showSnackBar(
        const SnackBar(
          content: Text("Invalid credentials"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6D4C41), // Dark brown background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Sign In",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.brown[700],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.brown[700],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xFF8D6E63), // Light brown button
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Login",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text("Don't have an account? Sign up",
                    style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
