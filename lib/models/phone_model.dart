class PhoneModel {
  final String name;
  final String price;
  final String image;
  final Map<String, String> specifications;
  final String? youtube_link;
  final String? product_url;

  PhoneModel({
    required this.name,
    required this.price,
    required this.image,
    required this.specifications,
    this.youtube_link,
    this.product_url,
  });

  factory PhoneModel.fromJson(Map<String, dynamic> json) {
    return PhoneModel(
      name: json['name'],
      price: json['price'],
      image: json['image'],
      specifications: Map<String, String>.from(json['specifications']),
      youtube_link: json['youtube_link'],
      product_url: json['product_url'],
    );
  }
}