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
  List<Field> _allFields = [];
  List<Field> _filteredFields = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadFields();
    _searchController.addListener(_filterFields); // Arama işlemi için listener ekliyoruz
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void loadFields() {
    setState(() {
      _fieldsFuture = fetchFields();
    });
    _fieldsFuture.then((fields) {
      setState(() {
        _allFields = fields;
        _filteredFields = fields;
      });
    });
  }

  void _filterFields() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFields = _allFields.where((field) {
        final fieldName = field.name.toLowerCase();
        return fieldName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sahalar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Saha Ara',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Field>>(
              future: _fieldsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  if (_filteredFields.isEmpty) {
                    return Center(child: Text('Saha bulunamadı'));
                  }
                  return ListView.builder(
                    itemCount: _filteredFields.length,
                    itemBuilder: (context, index) {
                      final field = _filteredFields[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            field.name,
                            style: TextStyle(
                              fontFamily: 'CustomFont',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
          ),
        ],
      ),
    );
  }
}
