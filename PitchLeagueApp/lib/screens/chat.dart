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
  List<User> _chats = []; // Sohbetleri saklamak için bir liste ekleyin

  @override
  void initState() {
    super.initState();
    loadUsers();
    loadPendingInvites();
  }

  void loadUsers() {
    setState(() {
      _usersFuture = fetchAllUsers();
      _me = fetchUserMe();
    });
  }

  Future<void> loadPendingInvites() async {
    try {
      final invites = await fetchPendingInvites(); // Burada fetchPendingInvites çağırıyoruz
      final me = await _me;

      setState(() {
        _pendingInvites = invites
            .where((invite) => invite.ToUsername == me.username)
            .map((invite) => User(
            username: invite.FromUsername,
            name: 'Default Name',
            surname: 'Default Surname',
            email: 'Default Email',
            phone: 'Default Phone',
            role: 'User',
            teamID: 0))
            .toList();
      });
    } catch (e) {
      print('Davetler yüklenirken hata oluştu: $e');
    }
  }

  void inviteToChat(String toUsername, String myUsername) {
    inviteUser(myUsername, toUsername);
    print('Kullanıcıya davet gönderildi: $toUsername');
  }

  void acceptInvite(User invite) async {
    try {
      // Daveti kabul etme API isteğini yap
      fetchAcceptInvite(invite.username);

      setState(() {
        _pendingInvites.remove(invite);
        _chats.add(invite); // Sohbetler listesine ekleyin
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatRoomScreen(user: invite),
        ),
      );
    } catch (e) {
      print('Daveti kabul ederken hata oluştu: $e');
    }
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

  void showUsersList() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FutureBuilder<User>(
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
                        return ListTile(
                          title: Text('${user.username}'),
                          trailing: ElevatedButton(
                            onPressed: () => inviteToChat(user.username, myUser.username),
                            child: Text('Davetiye Gönder'),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sohbetlerim'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: showInvitesDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          final user = _chats[index];
          return ListTile(
            title: Text('${user.username} ile Sohbet Et'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoomScreen(user: user),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showUsersList,
        child: Icon(Icons.add),
      ),
    );
  }
}

class ChatRoomScreen extends StatefulWidget {
  final User user;

  const ChatRoomScreen({Key? key, required this.user}) : super(key: key);

  @override
  ChatRoomScreenState createState() => ChatRoomScreenState();
}

class ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = []; // Sohbet mesajlarını saklayacak liste

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(message);
        _messageController.clear(); // Mesaj gönderildikten sonra textfield'ı temizle
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.user.username}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Mesajınızı yazın...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text('Gönder'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
