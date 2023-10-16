import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview_task/home_screen.dart';

import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController _loginController = Get.put(LoginController());

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: (){
                _loginController.login(_emailController.text, _passwordController.text);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
