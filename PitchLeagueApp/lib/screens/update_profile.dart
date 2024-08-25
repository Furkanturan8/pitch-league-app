import 'package:flutter/material.dart';
import '../services/api.dart';
import '../types/user.dart';

class UpdateProfileScreen extends StatefulWidget {
  final VoidCallback onPageSelected;

  const UpdateProfileScreen({Key? key, required this.onPageSelected})
      : super(key: key);

  @override
  UpdateProfileScreenState createState() => UpdateProfileScreenState();
}

class UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late Future<User> _userFuture;
  late User _user; // Burada kullanıcıyı saklayacak değişken

  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Form için global key

  @override
  void initState() {
    super.initState();
    loadUser(); // Kullanıcı verilerini yükle
  }

  void loadUser() {
    _userFuture = fetchUserMe(); // API'den kullanıcıyı al

    _userFuture.then((user) {
      _user = user;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      _nameController.text = user.name;
      _surnameController.text = user.surname;
      _usernameController.text = user.username;
    }).catchError((error) {
      print('Kullanıcı verileri alınırken hata oluştu: $error');
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

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
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEmailField(),
                    _buildEditableField(
                        'Telefon', _phoneController, 'Telefon numarası'),
                    _buildEditableField('Adınız', _nameController, 'Ad'),
                    _buildEditableField(
                        'Soyadınız', _surnameController, 'Soyad'),
                    _buildEditableField(
                        'Kullanıcı adınız', _usernameController, 'Kullanıcı adı'),
                    _buildDisabledField('Rol', snapshot.data!.role),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Arka plan rengi
                          foregroundColor: Colors.white, // Metin rengi
                        ),
                        child: Text('Kaydet'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('Veri bulunamadı'));
          }
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Email adresinizi girin',
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email alanı boş bırakılamaz';
            }
            final emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Geçerli bir email adresi girin';
            }
            return null;
          },
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildEditableField(
      String label, TextEditingController controller, String fieldName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: '$fieldName girin',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$fieldName alanı boş bırakılamaz';
            }
            return null;
          },
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDisabledField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: TextEditingController(text: value),
          enabled: false,
          style: TextStyle(color: Colors.grey[700]),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            fillColor: Colors.grey[200],
            filled: true,
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedUser = User(
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        username: _usernameController.text.trim(),
        role: '',
        teamID: _user.teamID, // Eski teamID'yi koruyun
      );

      try {
        await updateProfile(updatedUser);
        widget.onPageSelected();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil başarıyla güncellendi'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil güncellenemedi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen tüm alanları doğru şekilde doldurun'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}
