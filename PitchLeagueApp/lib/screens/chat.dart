import 'package:flutter/material.dart';
import '../services/api.dart';
import '../types/user.dart';

class ChatScreen extends StatefulWidget {
  final VoidCallback onPageSelected;

  const ChatScreen({Key? key, required this.onPageSelected}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  late Future<List<ListUser>> _usersFuture;
  late Future<User> _me;
  List<User> _pendingInvites = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() {
    setState(() {
      _usersFuture = fetchAllUsers();
      _me = fetchUserMe();
    });
  }

  void inviteToChat(String toUsername, String myUsername) {
    inviteUser(myUsername, toUsername);
    print('Kullanıcıya davet gönderildi: $toUsername');
  }

  void acceptInvite(User invite) {
    // Daveti kabul etme işlemi
  //  acceptInviteApi(invite.username); // API çağrısını güncelle
    setState(() {
      _pendingInvites.remove(invite);
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomScreen(user: invite),
      ),
    );
  }

  void showInvitesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Gelen Davetler'),
          content: _pendingInvites.isEmpty
              ? Text('Yeni davet yok.')
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: _pendingInvites.map((invite) {
              return ListTile(
                title: Text('${invite.username}'),
                trailing: ElevatedButton(
                  onPressed: () => acceptInvite(invite),
                  child: Text('Kabul Et'),
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcılar'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: showInvitesDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Kullanıcı Ara',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Arama fonksiyonu buraya eklenecek
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<User>(
              future: _me,
              builder: (context, meSnapshot) {
                if (meSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (meSnapshot.hasError) {
                  return Center(child: Text('Hata: ${meSnapshot.error}'));
                } else if (meSnapshot.hasData) {
                  final myUser = meSnapshot.data!;

                  return FutureBuilder<List<ListUser>>(
                    future: _usersFuture,
                    builder: (context, usersSnapshot) {
                      if (usersSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (usersSnapshot.hasError) {
                        return Center(child: Text('Hata: ${usersSnapshot.error}'));
                      } else if (usersSnapshot.hasData) {
                        final users = usersSnapshot.data!;

                        if (users.isEmpty) {
                          return Center(child: Text('Kullanıcı bulunamadı'));
                        }

                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                title: Text(
                                  '${user.username}',
                                  style: TextStyle(fontFamily: 'CustomFont', fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () => inviteToChat(user.username, myUser.username),
                                  child: Text('Konuşmaya Davet Et'),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(child: Text('Kullanıcı verisi bulunamadı'));
                      }
                    },
                  );
                } else {
                  return Center(child: Text('Kullanıcı verisi bulunamadı'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatRoomScreen extends StatelessWidget {
  final User user;

  const ChatRoomScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${user.username}'),
      ),
      body: Center(
        child: Text('Chat room for ${user.username}'),
      ),
    );
  }
}
