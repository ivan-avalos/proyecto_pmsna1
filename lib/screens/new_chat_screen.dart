import 'package:flutter/material.dart';
import 'package:linkchat/firebase/database.dart';
import 'package:linkchat/models/group.dart';
import 'package:linkchat/widgets/cached_avatar.dart';

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
  final ValueNotifier<List<FsUser>> _usersNotifier =
      ValueNotifier<List<FsUser>>([]);
  final ValueNotifier<List<FsUser>> _filteredUsersNotifier =
      ValueNotifier<List<FsUser>>([]);

  @override
  void initState() {
    super.initState();
    _db.getAllUsers().first.then((u) {
      _usersNotifier.value = u;
      _filteredUsersNotifier.value = u;
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
                if (value.isNotEmpty) {
                  _filteredUsersNotifier.value = _usersNotifier.value
                      .where((user) => user.displayName.contains(value))
                      .toList();
                } else {
                  _filteredUsersNotifier.value = _usersNotifier.value;
                }
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _filteredUsersNotifier,
              builder: (context, value, child) => ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  FsUser user = value[index];
                  return ListTile(
                    leading: CachedAvatar(user.photoUrl),
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
          ),
        ],
      ),
    );
  }
}
