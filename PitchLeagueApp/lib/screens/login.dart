import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pitch_league/screens/register.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://localhost:3002/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    // print('Response body: ${response.body}'); test için kullandım

    if (response.statusCode == 200) {
      try {
        final responseBody = jsonDecode(response.body);
        final accessToken = responseBody['data']['access_token'];
        final refreshToken = responseBody['data']['refresh_token'];

        if (accessToken != null) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('access_token', accessToken);
          prefs.setString('refresh_token', refreshToken);
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Token bulunamadı.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Yanıt işlenemedi: ${response.body}')),
        );
      }
    }else {
      // Hata mesajını düz metin olarak işle
      String errorMessage = response.body;

      // JSON parse işlemi yapılabilir, ancak eğer hata metni JSON formatında değilse, bu aşamada doğrudan metin kullanılacak
      try {
        final errorJson = jsonDecode(response.body);
        errorMessage = errorJson['message'] ?? 'Giriş başarısız';
      } catch (e) {
        // JSON parse başarısızsa, metin olarak kullan
        errorMessage = response.body;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş başarısız: $errorMessage')),
      );
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen(),
      ),
    ).then((value) {
      if (value == true) {
        // Kullanıcı başarılı bir şekilde kaydolduysa login ekranına geri dön
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Başarıyla kaydolundu! Lütfen giriş yapın.')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Giriş Yap'),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _navigateToRegister,
              child: Text(
                'Hesabınız yoksa kaydolun',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}