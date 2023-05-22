import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:linkchat/models/message.dart';
import 'package:url_launcher/link.dart';

enum ChatBubbleAlignment { start, end }

class ChatBubble extends StatelessWidget {
  final Message message;
  final ChatBubbleAlignment alignment;

  const ChatBubble(
    this.message, {
    super.key,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        alignment == ChatBubbleAlignment.start
            ? BubbleLeft(message)
            : BubbleRight(message),
      ],
    );
  }
}

class BubbleLeft extends StatelessWidget {
  final Message message;

  const BubbleLeft(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 77),
      child: ClipPath(
        clipper: UpperNipMessageClipper(MessageType.receive),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFFE1E1E2),
          ),
          child: Column(
            children: [
              LinkPreview(message),
              Link(
                uri: Uri.parse(message.messageText),
                builder: (context, followLink) => TextButton(
                  onPressed: followLink,
                  child: Text(
                    message.messageText,
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BubbleRight extends StatelessWidget {
  final Message message;

  const BubbleRight(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 77),
        child: ClipPath(
          clipper: LowerNipMessageClipper(MessageType.send),
          child: Container(
            padding:
                const EdgeInsets.only(left: 20, top: 10, bottom: 20, right: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF113753),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinkPreview(message),
                Link(
                  uri: Uri.parse(message.messageText),
                  builder: (context, followLink) => TextButton(
                    onPressed: followLink,
                    child: Text(
                      message.messageText,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LinkPreview extends StatelessWidget {
  final Message message;
  const LinkPreview(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return (message.linkTitle != null ||
            message.linkDescription != null ||
            message.linkPhotoURL != null)
        ? Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  message.linkPhotoURL != null
                      // ? FadeInImage(
                      //         placeholder: const AssetImage('assets/loading.gif'),
                      //         image: NetworkImage(message.linkPhotoURL!),
                      //         imageErrorBuilder: (context, error, stackTrace) =>
                      //             const SizedBox.shrink(),
                      //         fit: BoxFit.fill,
                      //       )
                      ? CachedNetworkImage(
                          imageUrl: message.linkPhotoURL!,
                          placeholder: (context, url) =>
                              Image.asset('assets/loading.gif'),
                          errorWidget: (context, url, error) =>
                              const SizedBox.shrink(),
                        )
                      : const SizedBox.shrink(),
                  message.linkTitle != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            message.linkTitle!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        )
                      : const SizedBox.shrink(),
                  message.linkDescription != null
                      ? Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                          child: Text(message.linkDescription!),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
