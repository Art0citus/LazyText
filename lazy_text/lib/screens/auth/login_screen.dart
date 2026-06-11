import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/round_textfield.dart';
import 'signup_screen.dart';
import 'package:dio/dio.dart';
import '../../services/api_service.dart';
import '../home/users_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/socket_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiService api = ApiService();
bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
  if (emailController.text.trim().isEmpty ||
      passwordController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please fill all fields"),
      ),
    );
    return;
  }

  try {
    setState(() {
      isLoading = true;
    });

    final response = await api.login(
  email: emailController.text.trim(),
  password: passwordController.text.trim(),
);
print("LOGIN RESPONSE:");
print(response.data);

final prefs = await SharedPreferences.getInstance();

await prefs.setString(
  "token",
  response.data["token"],
);
await prefs.setString(
  "userId",
  response.data["_id"],
);
SocketService.connect(
  response.data["_id"],
);

print("TOKEN SAVED");
print(response.data["token"]);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Login Successful"),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const UsersScreen(),
      ),
    );
  } on DioException catch (e) {
    print("STATUS: ${e.response?.statusCode}");
    print("DATA: ${e.response?.data}");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.response?.data["message"] ??
              "Login failed",
        ),
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,
      appBar: AppBar(
        backgroundColor: TColor.gray,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back",
                style: TextStyle(
                  color: TColor.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Login to continue chatting",
                style: TextStyle(
                  color: TColor.gray30,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 40),

              RoundTextField(
                title: "Email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              RoundTextField(
                title: "Password",
                controller: passwordController,
                obscureText: true,
              ),

              isLoading
    ? const Center(
        child: CircularProgressIndicator(),
      )
    : CustomButton(
        title: "Login",
        onPressed: login,
      ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: TColor.gray30,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignupScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: TColor.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}