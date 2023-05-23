import 'package:flutter/material.dart';
import 'package:linkchat/firebase/database.dart';
import 'package:linkchat/models/group.dart';

import '../firebase/auth.dart';
import '../models/user.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final Auth _auth = Auth();
  final Database _db = Database();
  final TextEditingController _controller = TextEditingController();
  List<FsUser> users = [];
  List<FsUser> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _db.getAllUsers().first.then((u) {
      setState(() {
        users = u;
        filteredUsers = u;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo chat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre del contacto',
              ),
              onChanged: (value) {
                setState(() {
                  if (value.isNotEmpty) {
                    filteredUsers = users
                        .where((user) => user.displayName.contains(value))
                        .toList();
                  } else {
                    filteredUsers = users;
                  }
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                FsUser user = filteredUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  title: Text(user.displayName),
                  trailing: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      _db
                          .saveGroup(Group(
                        createdBy: _auth.currentUser!.uid,
                        createdAt: DateTime.now(),
                        members: [
                          _auth.currentUser!.uid,
                          user.uid,
                        ],
                      ))
                          .whenComplete(() {
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
