// Bu sınıf, JSON dosyasındaki tek bir "rooms" nesnesini temsil eder.
class RoomModel {
  final String id;
  final String name;
  final bool locked; // Bu mekan başlangıçta kilitli mi?
  final List<String> itemsFound; // Bu odada bulunan (veya bulunabilecek) eşyaların listesi.

  RoomModel({
    required this.id,
    required this.name,
    required this.locked,
    required this.itemsFound,
  });

  // Gelen JSON verisinden bir RoomModel nesnesi oluşturur.
  factory RoomModel.fromJson(Map<String, dynamic> json) {
    // 'items_found' alanı bir liste olduğu için onu List<String>'e çeviriyoruz.
    final items = json['items_found'] as List<dynamic>? ?? [];
    final List<String> itemsList = items.map((item) => item.toString()).toList();

    return RoomModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'İsimsiz Mekan',
      locked: json['locked'] ?? true, // Eğer belirtilmemişse, güvenli olması için kilitli kabul et.
      itemsFound: itemsList,
    );
  }
}