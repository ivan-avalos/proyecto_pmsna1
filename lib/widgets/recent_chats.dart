import 'package:flutter/material.dart';
import 'package:linkchat/firebase/database.dart';

import '../firebase/auth.dart';
import '../models/group.dart';
import '../widgets/chat_item.dart';

class RecentChats extends StatelessWidget {
  RecentChats({super.key});

  final Auth _auth = Auth();
  final Database _db = Database();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ]),
      child: StreamBuilder(
          stream: _db.getGroupsByUserID(_auth.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 100.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Group group = snapshot.data![index];
                  return FutureBuilder(
                      future: _db.getUserById(group.members.firstWhere(
                          (m) => m != _auth.currentUser!.uid,
                          orElse: () => group.createdBy)),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ChatItem(
                            title: snapshot.data!.displayName,
                            subtitle: group.recentMessage?.messageText ?? "",
                            timestamp:
                                group.recentMessage?.sentAt ?? DateTime.now(),
                            avatarURL: snapshot.data!.photoUrl,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/chat',
                                arguments: [group, snapshot.data!],
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return ChatItem(
                            title: "Usuario desconocido",
                            subtitle: group.recentMessage?.messageText ?? "",
                            timestamp: DateTime.now(),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/chat',
                                arguments: [group, snapshot.data!],
                              );
                            },
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      });
                },
              );
            } else if (snapshot.hasError) {
              print("Error: ${snapshot.error}");
              return const Center(child: Text('Hubo un error'));
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
