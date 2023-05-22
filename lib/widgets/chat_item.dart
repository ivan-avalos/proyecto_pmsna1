import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final int? unread;
  final String? avatarURL;
  final Function() onTap;

  const ChatItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.timestamp,
    this.unread = 0,
    this.avatarURL,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  backgroundImage:
                      avatarURL != null ? NetworkImage(avatarURL!) : null,
                  child: avatarURL == null
                      ? Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : null,
                )),
            Expanded(
              flex: 12,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('kk:mm').format(timestamp),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 10),
                  unread != null && unread != 0
                      ? Container(
                          height: 23,
                          width: 23,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF113753),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            unread!.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
