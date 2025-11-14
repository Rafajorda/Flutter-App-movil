class Category {
  final int id;
  final String name;
  final String? uuid; // UUID del backend (opcional)
  final String? status; // Estado de la categoría (opcional)

  const Category({
    required this.id,
    required this.name,
    this.uuid,
    this.status,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    // Parsear ID - puede ser int, String numérico, o UUID
    int parseId(dynamic idValue) {
      if (idValue == null) return 0;
      if (idValue is int) return idValue;
      if (idValue is String) {
        // Si es un número como string, parsearlo
        final parsed = int.tryParse(idValue);
        if (parsed != null) return parsed;
        // Si es un UUID, usar su hashCode
        return idValue.hashCode;
      }
      return 0;
    }

    return Category(
      id: parseId(json['id']),
      name: json['name']?.toString() ?? '',
      uuid: json['id']?.toString(), 
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (uuid != null) 'uuid': uuid,
    if (status != null) 'status': status,
  };
}
