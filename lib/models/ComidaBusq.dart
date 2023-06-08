class ComidaBusq {
  late String nombre;
  late String urlImage;
  late String descripcion;
  late String id;
  late String precio;

  ComidaBusq({
    required this.nombre,
    required this.urlImage,
    required this.descripcion,
    required this.id,
    required this.precio,
  });

  factory ComidaBusq.fromJson(Map<String, dynamic> json) {
    return ComidaBusq(
      nombre: json['nombre']['S'],
      urlImage: json['urlImage']['S'],
      descripcion: json['descripcion']['S'],
      id: json['id']['S'],
      precio: json['precio']['S'],
    );
  }
}
