import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/chat_data.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatData> dummyData = [
    ChatData(
      image: 'assets/images/img.png',
      lastMessageSent: 'Hey, how are you?',
      name: 'Ryan',
    ),
    ChatData(
      image: 'assets/images/img_1.png',
      lastMessageSent: 'See you tomorrow!',
      name: 'John',
    ),
    ChatData(
      image: 'assets/images/img_2.png',
      lastMessageSent: 'Let\'s meet at 5pm.',
      name: 'Lucy',
    ),
    ChatData(
      image: 'assets/images/img_3.png',
      lastMessageSent: 'It\'s a sunny day!',
      name: 'Amy',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Messages",
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Circular Std',
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: ListView.builder(
              itemCount: dummyData.length,
              itemBuilder: (context, index) {
                return buildChatRow(dummyData[index]);
              },
            )),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(chatData:
                    ChatData(image: 'assets/images/img_4.png', lastMessageSent: '', name: 'Alex')
                ),
              ),
            );
          },
          backgroundColor: Color(0xFF686BFF),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget buildChatRow(ChatData chatData) {
    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(chatData: chatData),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.asset(
                      chatData.image,
                      height: 40,
                    )),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chatData.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                            color: Colors.black,
                            fontSize: 18),
                      ),
                      Text(
                        chatData.lastMessageSent,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            color: Colors.grey.shade600,
                            fontSize: 14),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Divider(
              indent: 4,
              endIndent: 4,
              color: Colors.grey.shade300,
            )
          ],
        ),
      ),
    );
  }
}
