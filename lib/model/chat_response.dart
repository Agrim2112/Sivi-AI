import 'chat_message.dart';

class ChatResponse {
  final List<ChatMessage> restaurant;

  ChatResponse({
    required this.restaurant,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      restaurant: (json['restaurant'] as List)
          .map((i) => ChatMessage.fromJson(i))
          .toList(),
    );
  }
}