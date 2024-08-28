class Message {
  final String FromUsername;
  final String ToUsername;
  final String Content;
  final String Status;

  Message({
    required this.FromUsername,
    required this.ToUsername,
    required this.Content,
    required this.Status,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      FromUsername: json['from_username'],
      ToUsername: json['to_username'],
      Content: json['content'],
      Status: json['status'],
    );
  }
}