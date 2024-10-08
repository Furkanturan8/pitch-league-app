import 'package:flutter/material.dart';
import '../services/api.dart';
import '../types/match.dart';
import '../types/user.dart';

class GamesScreen extends StatefulWidget {
  final VoidCallback? onPageSelected;

  const GamesScreen({Key? key, this.onPageSelected}) : super(key: key);

  @override
  GamesScreenState createState() => GamesScreenState();
}

class GamesScreenState extends State<GamesScreen> {
  late Future<List<Match>> _gamesFuture;
  int? _userID; // Kullanıcı ID'sini saklayacak değişken

  @override
  void initState() {
    super.initState();
    _gamesFuture = Future.value([]); // Başlangıçta boş bir liste döndür
    loadUser(); // Kullanıcı ID'sini al
  }

  Future<void> loadUser() async {
    try {
      final userID = await getMyUserID(); // API'den kullanıcıyı al

      if (!mounted) return; // Eğer widget artık ağacın bir parçası değilse çık
      setState(() {
        _userID = userID;
        loadGames(); // Kullanıcı ID'si alındıktan sonra oyunları yükle
      });
    } catch (e) {
      print('Kullanıcı yüklenemedi: $e');
    }
  }

  void loadGames() {
    if (_userID != null) {
      setState(() {
        _gamesFuture = fetchMatches(_userID!); // Kullanıcı ID'si mevcutsa oyunları yükle
      });
    } else {
      setState(() {
        _gamesFuture = Future.value([]); // Kullanıcı ID'si yoksa boş liste döndür
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halısaha Maçları'),
      ),
      body: FutureBuilder<List<Match>>(
        future: _gamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final match = snapshot.data!;
            if (match.isEmpty) {
              return Center(child: Text('Henüz maçınız yok'));
            }
            return ListView.builder(
              itemCount: match.length,
              itemBuilder: (context, index) {
                final data = match[index];
                Color statusColor;
                String statusText;

                // Durum ve renklere göre eşleştirme
                switch (data.status) {
                  case 'scheduled':
                    statusColor = Colors.blue;
                    statusText = 'Henüz başlamadı';
                    break;
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
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${data.homeTeam.name} ',
                                style: TextStyle(
                                  fontFamily: 'CustomFont',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue, // Ev sahibi takım mavi
                                ),
                              ),
                              TextSpan(
                                text: 'vs ',
                                style: TextStyle(
                                  fontFamily: 'CustomFont',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Karşılaştırma "vs" siyah
                                ),
                              ),
                              TextSpan(
                                text: '${data.awayTeam.name}',
                                style: TextStyle(
                                  fontFamily: 'CustomFont',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red, // Misafir takım kırmızı
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Skor: ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '${data.homeScore} - ${data.awayScore}',
                                style: TextStyle(fontSize: 17, color: Colors.black),
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
                                text: '${data.homeTeam.captain.name} ${data.homeTeam.captain.surname}',
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
                                text: data.homeTeam.captain.phone,
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

  @override
  void dispose() {
    super.dispose();
  }
}
