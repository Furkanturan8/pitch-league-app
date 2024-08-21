import 'package:flutter/material.dart';
import '../services/api.dart';
import '../types/field.dart';

class ExploreScreen extends StatefulWidget {
  final VoidCallback onPageSelected;

  const ExploreScreen({Key? key, required this.onPageSelected}) : super(key: key);

  @override
  ExploreScreenState createState() => ExploreScreenState();
}

class ExploreScreenState extends State<ExploreScreen> {
  late Future<List<Field>> _fieldsFuture;

  @override
  void initState() {
    super.initState();
    loadFields(); // API'den alanları al
  }

  void loadFields() {
    setState(() {
      _fieldsFuture = fetchFields(); // API'den alanları al
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sahalar'),
      ),
      body: FutureBuilder<List<Field>>(
        future: _fieldsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final fields = snapshot.data!;
            if (fields.isEmpty) {
              return Center(child: Text('Saha bulunamadı'));
            }
            return ListView.builder(
              itemCount: fields.length,
              itemBuilder: (context, index) {
                final field = fields[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      field.name,
                      style: TextStyle(fontFamily: 'CustomFont', fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${field.location} - ${field.price_per_hour}₺/saat',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Veri bulunamadı'));
          }
        },
      ),
    );
  }
}
