import 'package:flutter/material.dart';
import 'package:linkchat/firebase/database.dart';
import 'package:linkchat/widgets/chat_bubble.dart';

import '../firebase/auth.dart';
import '../models/favorite.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final Auth _auth = Auth();
  final Database _db = Database();
  final TextEditingController _controller = TextEditingController();
  List<Favorite> favorites = [];
  List<Favorite> filteredFavorites = [];

  @override
  void initState() {
    super.initState();
    _db.getFavoritesByUserID(_auth.currentUser!.uid).first.then((f) {
      setState(() {
        favorites = f;
        filteredFavorites = f;
      });
    }).onError((e, st) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
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
                labelText: 'Buscar',
              ),
              onChanged: (value) {
                setState(() {
                  if (value.isNotEmpty) {
                    filteredFavorites = favorites
                        .where((fav) =>
                            fav.messageText.contains(value) == true ||
                            fav.linkTitle?.contains(value) == true ||
                            fav.linkDescription?.contains(value) == true)
                        .toList();
                  } else {
                    filteredFavorites = favorites;
                  }
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFavorites.length,
              itemBuilder: (context, index) {
                Favorite fav = filteredFavorites[index];
                return LinkPreview(fav.getMessage());
              },
            ),
          ),
        ],
      ),
    );
  }
}
