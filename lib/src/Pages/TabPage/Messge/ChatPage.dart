import 'package:flutter/material.dart';
import 'package:video_share/src/Extension/Style.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({
    Key key,
    @required this.chatRoomId,
  }) : super(key: key);

  final String chatRoomId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: globalPink,
        ),
        body: Center(
          child: Text(chatRoomId),
        ));
  }
}
