class ChatMessage {
  final String bot;
  final String human;

  ChatMessage({
    required this.bot,
    required this.human,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      bot: json['bot'],
      human: json['human'],
    );
  }
}