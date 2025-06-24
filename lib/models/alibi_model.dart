// Bu sınıf, bir karakterin mazeretini, yerini ve doğrulanıp doğrulanmadığını tutar.
class AlibiModel {
  final String description;
  final String location;
  // is_verified alanı JSON'da null gelebilir (henüz kontrol edilmemişse),
  // bu yüzden bool? (nullable boolean) olarak tanımlıyoruz.
  final bool? isVerified;

  AlibiModel({
    required this.description,
    required this.location,
    required this.isVerified,
  });

  // Gelen JSON verisinden bir AlibiModel nesnesi oluşturur.
  factory AlibiModel.fromJson(Map<String, dynamic> json) {
    return AlibiModel(
      description: json['description'] ?? 'Mazeret belirtilmemiş.',
      location: json['location'] ?? 'Bilinmiyor',
      isVerified: json['is_verified'],
    );
  }
}