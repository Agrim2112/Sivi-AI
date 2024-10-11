import 'package:flutter/material.dart';
import '../utils/size_utils.dart';

class ChatBubble extends StatefulWidget {
  final String text;
  final bool isSentByMe;

  ChatBubble(
      {super.key,
        required this.text,
        required this.isSentByMe,
      });

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  String removeLeadingNewlines(String input) {
    return input.replaceFirst(RegExp(r'^\n\n'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      margin: getMargin(
        bottom: 12,
      ),
      alignment: widget.isSentByMe ? Alignment.topRight : Alignment.topLeft,
      child: Column(
        crossAxisAlignment: widget.isSentByMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
              padding: getPadding(
                left: 16,
                top: 12,
                right: 16,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: widget.isSentByMe
                          ? [Color(0xFF686BFF), Color(0xFF9496FF)]
                          : [Colors.white, Colors.white]
                  ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(getVerticalSize(20)),
                  topRight: Radius.circular(getVerticalSize(20)),
                  bottomLeft: widget.isSentByMe
                      ? Radius.circular(getVerticalSize(20))
                      : const Radius.circular(0),
                  bottomRight: widget.isSentByMe
                      ? const Radius.circular(0)
                      : Radius.circular(getVerticalSize(20)),
                ),
              ),
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                  ),
                  child: Text(
                    removeLeadingNewlines(widget.text),
                    style: TextStyle(
                      color: widget.isSentByMe ? Colors.white : Colors.black,
                      fontFamily: 'AirbnbCereal_W_Md',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ))),
        ],
      ),
    );
  }
}
