import 'package:flutter/material.dart';
import '../services/api.dart';
import '../types/games.dart';

class GamesScreen extends StatefulWidget {
  final VoidCallback? onPageSelected;

  const GamesScreen({Key? key, this.onPageSelected}) : super(key: key);

  @override
  GamesScreenState createState() => GamesScreenState();
}

class GamesScreenState extends State<GamesScreen> {
  late Future<List<Games>> _gamesFuture;

  @override
  void initState() {
    super.initState();
    loadGames(); // API'den alanları al
  }

  void loadGames() {
    setState(() {
      _gamesFuture = fetchGames(); // API'den alanları al
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halısaha Maçları'),
      ),
      body: FutureBuilder<List<Games>>(
        future: _gamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final games = snapshot.data!;
            if (games.isEmpty) {
              return Center(child: Text('Maçlar bulunamadı'));
            }
            return ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final data = games[index];
                Color statusColor;
                String statusText;

                // Durum ve renklere göre eşleştirme
                switch (data.game.status) {
                  case 'open':
                    statusColor = Colors.blue;
                    statusText = 'Henüz başlamadı';
                    break;
                  case 'full':
                    statusColor = Colors.orange;
                    statusText = 'Takım doldu';
                    break;
                  case 'completed':
                    statusColor = Colors.red;
                    statusText = 'Maç bitti';
                    break;
                  default:
                    statusColor = Colors.grey;
                    statusText = 'Bilinmeyen durum';
                    break;
                }

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Maç Detayları',
                          style: TextStyle(
                            fontFamily: 'CustomFont',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Takım: ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: data.team.name,
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Halısaha: ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: data.game.field.name,
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Halısahanın Konumu: ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: data.game.field.location,
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Maç Saati: ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '${data.game.startTime}',
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Maç Bitiş Saati: ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '${data.game.endTime}',
                                style: TextStyle(fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Maç Durumu: ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: statusText,
                                style: TextStyle(fontSize: 15, color: statusColor),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Takım Kaptanı: ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '${data.game.host.name} ${data.game.host.surname}',
                                style: TextStyle(fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Kaptanın Telefonu: ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: data.game.host.phone,
                                style: TextStyle(fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Saha Ücreti (saatlik): ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '${data.game.field.pricePerHour} TL',
                                style: TextStyle(fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
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
