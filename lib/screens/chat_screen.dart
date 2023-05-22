import 'package:flutter/material.dart';
import 'package:linkchat/firebase/auth.dart';
import 'package:linkchat/firebase/database.dart';
import 'package:linkchat/models/group.dart';

import '../models/message.dart';
import '../models/user.dart';
import '../widgets/chat_bottom_sheet.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool init = false;
  Group? group;
  FsUser? user;
  final Auth _auth = Auth();
  final Database _db = Database();

  @override
  Widget build(BuildContext context) {
    List<dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    group = arguments[0] as Group;
    user = arguments[1] as FsUser;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: AppBar(
            leadingWidth: 30,
            title: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoUrl),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(user!.displayName),
                ),
              ],
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.more_vert,
                ),
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _db.getMessagesByGroupId(group!.id!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message> msgs = snapshot.data!;
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => ChatBubble(
                msgs[index].messageText,
                alignment: msgs[index].sentBy == _auth.currentUser?.uid
                    ? ChatBubbleAlignment.end
                    : ChatBubbleAlignment.start,
              ),
            );
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return const Center(child: Text('Hubo un error'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomSheet: ChatBottomSheet(
        onPressed: (value) {
          _db.saveMessage(
              Message(
                messageText: value,
                sentBy: _auth.currentUser!.uid,
                sentAt: DateTime.now(),
              ),
              group!.id!);
        },
      ),
    );
  }
}
