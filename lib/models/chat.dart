import 'package:linkchat/models/mensaje.dart';

class Chat {
  final String id;
  final String idUsuario1;
  final String idUsuario2;
  final List<Mensaje> mensajes;

  const Chat({
    required this.id,
    required this.idUsuario1,
    required this.idUsuario2,
    required this.mensajes,
  });

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'],
      idUsuario1: map['usuario1_id'],
      idUsuario2: map['usuario2_id'],
      mensajes: (map['mensajes'] as List<Map<String, dynamic>>)
          .map((msj) => Mensaje.fromMap(msj))
          .toList(),
    );
  }
}
