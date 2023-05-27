import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linkchat/firebase/auth.dart';
import 'package:linkchat/firebase/database.dart';
import 'package:linkchat/models/group.dart';
import 'package:linkchat/widgets/cached_avatar.dart';

import '../models/favorite.dart';
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

  final ScrollController _scroll = ScrollController();

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
                CachedAvatar(user?.photoUrl),
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
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scroll.hasClients) {
                _scroll.animateTo(_scroll.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn);
              }
            });

            List<Message> msgs = snapshot.data!;
            User? user = _auth.currentUser;
            return ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.only(bottom: 80.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => StreamBuilder(
                  stream: _db.hasFavoriteForMessage(
                      _auth.currentUser!.uid, msgs[index].id),
                  builder: (context, snapshot) {
                    return ChatBubble(
                      msgs[index],
                      alignment: msgs[index].sentBy == user?.uid
                          ? ChatBubbleAlignment.end
                          : ChatBubbleAlignment.start,
                      favorited: snapshot.hasData
                          ? snapshot.data == true
                          : (snapshot.hasError ? false : false),
                      onFavorite: (String id, bool value) {
                        if (value) {
                          _db.saveFavorite(
                              Favorite(
                                groupId: group!.id!,
                                messageId: msgs[index].id!,
                                savedAt: DateTime.now(),
                                messageText: msgs[index].messageText,
                                linkTitle: msgs[index].linkTitle,
                                linkDescription: msgs[index].linkDescription,
                                linkPhotoURL: msgs[index].linkPhotoURL,
                                sentAt: msgs[index].sentAt,
                                sentBy: msgs[index].sentBy,
                              ),
                              user!.uid);
                        } else {
                          _db.removeFavorite(user!.uid, msgs[index].id);
                        }
                      },
                    );
                  }),
            );
          } else if (snapshot.hasError) {
            if (kDebugMode) print('Error: ${snapshot.error}');
            return const Center(child: Text('Hubo un error'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomSheet: ChatBottomSheet(
        onPressed: (value) {
          if (value.startsWith('https://') && Uri.tryParse(value) != null) {
            _db.saveMessage(
                Message(
                  messageText: value,
                  sentBy: _auth.currentUser!.uid,
                  sentAt: DateTime.now(),
                ),
                group!.id!);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                // behavior: SnackBarBehavior.floating,
                dismissDirection: DismissDirection.none,
                content: Text('El mensaje debe ser un link.'),
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
      ),
    );
  }
}
