enum Direccion { a2b, b2a }

class Mensaje {
  final String id;
  final String link;
  final String? titulo;
  final String? imagen;
  final String fecha;
  final Direccion direccion;

  const Mensaje({
    required this.id,
    required this.link,
    this.titulo,
    this.imagen,
    required this.fecha,
    required this.direccion,
  });

  factory Mensaje.fromMap(Map<String, dynamic> map) {
    return Mensaje(
      id: map['id'],
      link: map['link'],
      titulo: map.containsKey('titulo') ? map['titulo'] : null,
      imagen: map.containsKey('imagen') ? map['imagen'] : null,
      fecha: map['fecha'],
      direccion: (map['fecha'] as int) == 0 ? Direccion.a2b : Direccion.b2a,
    );
  }
}
