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

      if (role == "USER") {
        Navigator.pushReplacement(
          currentContext,
          MaterialPageRoute(builder: (context) => UserScreen(token: token)),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade300, Colors.brown.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Marana's library <3",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.brown.shade900,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                _buildTextField(emailController, "Email", Icons.email),
                SizedBox(height: 15),
                _buildTextField(passwordController, "Password", Icons.lock,
                    isPassword: true),
                SizedBox(height: 25),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          backgroundColor: Colors.brown.shade700,
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(
                      color: Colors.brown.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.brown.shade900),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.brown.shade700),
        labelText: label,
        labelStyle: TextStyle(color: Colors.brown.shade700),
        filled: true,
        fillColor: Colors.brown.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }
}
