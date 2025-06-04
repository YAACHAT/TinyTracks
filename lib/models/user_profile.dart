class UserProfile {
  final String firebaseUid;
  final String childName;
  final DateTime birthDate;
  final String gender;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.firebaseUid,
    required this.childName,
    required this.birthDate,
    required this.gender,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromSupabase(Map<String, dynamic> data) {
    return UserProfile(
      firebaseUid: data['uid'],
      childName: data['child_name'],
      birthDate: DateTime.parse(data['birth_date']),
      gender: data['gender'],
      imageUrl: data['image_url'],
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'uid': firebaseUid,
      'child_name': childName,
      'birth_date': birthDate.toIso8601String(),
      'gender': gender,
      'image_url': imageUrl,
    };
  }
}
