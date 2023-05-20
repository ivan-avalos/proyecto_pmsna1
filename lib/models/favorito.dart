class Favorito {
  final String chatId;
  final String mensajeId;

  const Favorito({
    required this.chatId,
    required this.mensajeId,
  });

  factory Favorito.fromMap(Map<String, dynamic> map) {
    return Favorito(
      chatId: map['chat_id'],
      mensajeId: map['mensaje_id'],
    );
  }
}
