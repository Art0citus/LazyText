import 'package:flutter/material.dart';
import 'dart:async';
import '../../common/color_extension.dart';
import '../../services/api_service.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/message_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/socket_service.dart';

class ChatScreen extends StatefulWidget {
  final String username;
  final String receiverId;

  const ChatScreen({
    super.key,
    required this.username,
    required this.receiverId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ApiService api = ApiService();

  final TextEditingController messageController =
      TextEditingController();

  List<dynamic> messages = [];
  String myId = "";
  bool isLoading = true;
  Timer? refreshTimer;

  @override
void initState() {
  super.initState();

  initializeChat();

  SocketService.socket.on(
    "newMessage",
    (data) {
      print("NEW MESSAGE:");
      print(data);

      setState(() {
        messages.add(data);
      });
    },
  );
}

Future<void> loadMyId() async {
  final prefs =
      await SharedPreferences.getInstance();

  myId =
      prefs.getString("userId") ?? "";

  print("MY ID:");
  print(myId);
}

Future<void> initializeChat() async {
  await loadMyId();
  await loadMessages();
}
  Future<void> loadMessages() async {
    try {
      print("RECEIVER ID:");
      print(widget.receiverId);

      final response = await api.getMessages(
        widget.receiverId,
      );

      print("MESSAGES:");
      print(response.data);

      setState(() {
        messages = response.data;
        isLoading = false;
      });
    } catch (e) {
      print("LOAD MESSAGE ERROR:");
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) {
      return;
    }

    try {
      await api.sendMessage(
        receiverId: widget.receiverId,
        text: messageController.text.trim(),
      );

      messageController.clear();

      await loadMessages();
    } catch (e) {
      print("SEND MESSAGE ERROR:");
      print(e);
    }
  }

  @override
  void dispose() {
    SocketService.socket.off(
  "newMessage",
);
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,
      appBar: AppBar(
        backgroundColor: TColor.gray,
        title: Text(widget.username),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )
                : messages.isEmpty
                    ? const Center(
                        child: Text(
                          "No messages yet",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding:
                            const EdgeInsets.all(12),
                        itemCount: messages.length,
                        itemBuilder:
                            (context, index) {
                          return MessageBubble(
                            message:
                                messages[index]
                                        ["text"] ??
                                    "",
                            isMe:
    messages[index]["senderId"] ==
    myId,
                          );
                        },
                      ),
          ),
          MessageInput(
            controller: messageController,
            onSend: sendMessage,
          ),
        ],
      ),
    );
  }
}