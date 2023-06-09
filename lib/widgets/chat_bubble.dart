import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:linkchat/models/message.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

enum ChatBubbleAlignment { start, end }

class ChatBubble extends StatelessWidget {
  final Message message;
  final ChatBubbleAlignment alignment;
  final bool favorited;
  final Function(String id, bool value) onFavorite;

  const ChatBubble(
    this.message, {
    super.key,
    required this.alignment,
    this.favorited = false,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        alignment == ChatBubbleAlignment.start
            ? BubbleLeft(
                message,
                favorited: favorited,
                onFavorite: onFavorite,
              )
            : BubbleRight(
                message,
                favorited: favorited,
                onFavorite: onFavorite,
              ),
      ],
    );
  }
}

class BubbleLeft extends StatelessWidget {
  final Message message;
  final bool favorited;
  final Function(String id, bool value) onFavorite;

  const BubbleLeft(
    this.message, {
    super.key,
    this.favorited = false,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    Color background = Theme.of(context).colorScheme.tertiaryContainer;
    Color foreground = Theme.of(context).colorScheme.onTertiaryContainer;
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 77),
      child: ClipPath(
        clipper: UpperNipMessageClipper(MessageType.receive),
        child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: background),
            child: BubbleContent(
              message,
              favorited: favorited,
              foregroundColor: foreground,
              onFavorited: () => onFavorite(message.id!, !favorited),
            )),
      ),
    );
  }
}

class BubbleRight extends StatelessWidget {
  final Message message;
  final bool favorited;
  final Function(String id, bool value) onFavorite;

  const BubbleRight(
    this.message, {
    super.key,
    this.favorited = false,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    Color background = Theme.of(context).colorScheme.primaryContainer;
    Color foreground = Theme.of(context).colorScheme.onPrimaryContainer;
    return Container(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 77),
        child: ClipPath(
          clipper: LowerNipMessageClipper(MessageType.send),
          child: Container(
              padding: const EdgeInsets.only(
                  left: 20, top: 10, bottom: 20, right: 20),
              decoration: BoxDecoration(color: background),
              child: BubbleContent(
                message,
                favorited: favorited,
                foregroundColor: foreground,
                onFavorited: () => onFavorite(message.id!, !favorited),
              )),
        ),
      ),
    );
  }
}

class BubbleContent extends StatelessWidget {
  final bool favorited;
  final Message message;
  final Color foregroundColor;
  final Function() onFavorited;

  const BubbleContent(
    this.message, {
    super.key,
    required this.favorited,
    required this.foregroundColor,
    required this.onFavorited,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinkPreview(message),
        Row(
          children: [
            Expanded(
              child: Link(
                uri: Uri.parse(message.messageText),
                builder: (context, followLink) => TextButton(
                  onPressed: followLink,
                  child: Text(
                    message.messageText,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: foregroundColor,
                      decoration: TextDecoration.underline,
                      decorationColor: foregroundColor,
                    ),
                  ),
                ),
              ),
            ),
            Favorited(
              favorited,
              color: foregroundColor,
              onPressed: () => onFavorited(),
            ),
          ],
        ),
      ],
    );
  }
}

class Favorited extends StatelessWidget {
  final bool favorited;
  final Color color;
  final Function() onPressed;

  const Favorited(
    this.favorited, {
    super.key,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: favorited
          ? Icon(Icons.favorite, color: color)
          : Icon(Icons.favorite_outline, color: color),
      onPressed: onPressed,
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
              semanticContainer: true,
              child: InkWell(
                onTap: () {
                  launchUrl(
                    Uri.parse(message.messageText),
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    message.linkPhotoURL != null
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
            ),
          )
        : const SizedBox.shrink();
  }
}
