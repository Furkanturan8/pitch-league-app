import 'package:flutter/material.dart';

import '../services/api.dart';
import '../types/user.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = fetchUserMe(); // API'den kullanıcıyı al
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı Bilgileri'),
      ),
      body: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfo('Email', user.email),
                  _buildUserInfo('Telefon', user.phone),
                  _buildUserInfo('Adınız', user.name),
                  _buildUserInfo('Soyadınız', user.surname),
                  _buildUserInfo('Kullanıcı adınız', user.username),
                  _buildUserInfo('Rol', user.role),
                ],
              ),
            );
          } else {
            return Center(child: Text('Veri bulunamadı'));
          }
        },
      ),
    );
  }

  Widget _buildUserInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 9),
        Divider(thickness: 1, color: Colors.grey[300]),
        SizedBox(height: 9),
      ],
    );
  }
}

