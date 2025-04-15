class Shop {
  final String shopName;
  final String address;
  final String email;
  final String logoUrl;
  final String phoneNumber;
  final Map<String, String> workingHours;
  final double latitude;
  final double longitude;

  Shop({
    required this.shopName,
    required this.address,
    required this.email,
    required this.logoUrl,
    required this.phoneNumber,
    required this.workingHours,
    required this.latitude,
    required this.longitude,
  });
}
