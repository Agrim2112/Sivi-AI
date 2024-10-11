import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sivy/model/chat_data.dart';
import 'package:sivy/model/chat_message.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../components/chat_bubble.dart';
import '../model/chat_response.dart';

class ChatScreen extends StatefulWidget {
  final ChatData chatData;

  ChatScreen({super.key, required this.chatData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _chatInputCtrl = TextEditingController();
  bool isInputNotEmpty = false;
  List<ChatMessage> chatMessages = [];
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  int currentIndex=0;
  int incorrectAttempts=0;

  List<ChatMessage> dummyChat=[
    ChatMessage(bot: 'Would you like some water?', human: 'Yes, please'),
    ChatMessage(bot: 'Anything else?', human: 'Yes, with grilled vegetables'),
    ChatMessage(bot: 'Would you like some food?', human: 'A fish please'),
    ChatMessage(bot: 'What would you like?', human: 'I would like a tea'),
    ChatMessage(bot: 'Welcome to the restaurant', human: 'Thank you'),
    ChatMessage(bot: 'Hello', human: 'Good afternoon'),
  ];



  @override
  void initState() {
    super.initState();
    _initSpeech();
    setState(() {
    });
    _fetchChatData();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _chatInputCtrl.text = result.recognizedWords;
    });
  }

  Future<void> _fetchChatData() async {
    try {
      final response = await http.get(Uri.parse('https://my-json-server.typicode.com/tryninjastudy/dummyapi/db'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final chatResponse = ChatResponse.fromJson(data);
        setState(() {
          chatMessages = chatResponse.restaurant;
        });
      } else {
        throw Exception('Failed to load chat data');
      }
    } catch (e) {
      if (e is SocketException) {
        print('No internet connection');
      } else {
        print('Failed to load chat data: $e');
      }
    }
  }

  void sendMessage(){
    dummyChat.insert(0, ChatMessage(bot: '', human: _chatInputCtrl.text));
    String userText = _chatInputCtrl.text;
    String correctText = chatMessages[currentIndex].human;

    String userTextClean = userText.replaceAll(RegExp(r'[^\w\s]+'),'').toLowerCase();
    String correctTextClean = correctText.replaceAll(RegExp(r'[^\w\s]+'),'').toLowerCase();

    if(currentIndex<chatMessages.length-1) {
      if (userTextClean == correctTextClean) {
        currentIndex++;
        setState(() {
          dummyChat.insert(
              0, ChatMessage(bot: chatMessages[currentIndex].bot, human: ''));
        });
        incorrectAttempts = 0;
      } else {
        incorrectAttempts++;

        if (incorrectAttempts < 2) {
          setState(() {
            dummyChat.insert(0, ChatMessage(bot: "The correct sentence was '${chatMessages[currentIndex].bot}'", human: ''));
          });
        } else {
          currentIndex++;
          setState(() {
            dummyChat.insert(
                0, ChatMessage(bot: chatMessages[currentIndex].bot, human: ''));
          });
          incorrectAttempts = 0;
        }
      }
    }
    _chatInputCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: false,
        leading: Navigator.canPop(context) ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            }
        ) : null,
        title: InkWell(
          onTap: () {
          },
          child: Row(
            children: [
              CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey.shade800,
                  backgroundImage: AssetImage(widget.chatData.image)),
              const SizedBox(
                width: 12,
              ),
              Text(
                widget.chatData.name,
                style: const TextStyle(
                    fontFamily: 'AirbnbCereal_W_Bd',
                    fontSize: 19,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: const Icon(
              Icons.more_vert,
              size: 26,
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  controller: _controller,
                  reverse: true,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: dummyChat.length * 2,
                  itemBuilder: (context, index) {
                    bool isBotMessage = index % 2 == 0;
                    ChatMessage message = dummyChat[index ~/ 2];

                    if((isBotMessage && message.bot.isNotEmpty) || (!isBotMessage && message.human.isNotEmpty)) {
                      return ChatBubble(
                        text: isBotMessage ? message.bot : message.human,
                        isSentByMe: !isBotMessage,
                      );
                    }
                    else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin:
                      const EdgeInsets.symmetric(horizontal: 16.0,vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: _chatInputCtrl,
                        autofocus: false,
                        maxLines: null,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintText: 'Type here',
                            hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontFamily: 'AirbnbCereal_W_Md',
                                fontWeight: FontWeight.w500),
                            border: InputBorder.none,
                            suffixIcon: Container(
                              width: 100,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        _speechToText.isNotListening ? _startListening : _stopListening;
                                      },
                                      icon: Icon(
                                        Icons.mic,
                                        color: Color(0xFF9095A0),
                                        size: 30,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        sendMessage();
                                      },
                                      icon: Image.asset(
                                        'assets/images/send.png',
                                        scale: 2,
                                      )),
                                ],
                              ),
                            )),
                        onChanged: (value) {
                          setState(() {
                            isInputNotEmpty = value.isNotEmpty;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget chatBubble(String text, String direction) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.all(4.0),
        margin: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.grey,
        ),
        child: Text(
          text,
          textDirection:
          direction == 'left' ? TextDirection.ltr : TextDirection.rtl,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }
}
