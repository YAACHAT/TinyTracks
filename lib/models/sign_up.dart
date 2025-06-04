class SignUpData {
  String email;
  String password;
  String childName;
  String birthDate; // Stored as a string, ideally in ISO format (yyyy-MM-dd)
  String gender;
  String weight;
  String height;
  String hc; // Head circumference
  String bloodG; // Blood group
  String genotype;

  SignUpData({
    required this.email,
    required this.password,
    this.childName = '',
    this.birthDate = '',
    this.gender = '',
    this.weight = '',
    this.height = '',
    this.hc = '',
    this.bloodG = '',
    this.genotype = '',
  });


  Map<String, dynamic> toMap() => {
        'email': email,
        'childName': childName,
        'birthDate': birthDate,
        'gender': gender,
        'weight': weight,
        'height': height,
        'hc': hc,
        'bloodG': bloodG,
        'genotype': genotype,
      };

  /// Converts birthDate string to DateTime object (if possible).
  DateTime? get birthDateTime =>
      birthDate.isNotEmpty ? DateTime.tryParse(birthDate) : null;

  /// Calculates age in years and months from birthDate.
  String calculateAge() {
    final birth = birthDateTime;
    if (birth == null) return '';

    final now = DateTime.now();
    int years = now.year - birth.year;
    int months = now.month - birth.month;

    if (now.day < birth.day) months--; // Adjust if current day is before birth day
    if (months < 0) {
      years--;
      months += 12;
    }

    if (years < 1) {
      return '$months months';
    } else {
      return '$years years${months > 0 ? ', $months months' : ''}';
    }
  }

  /// Creates a copy of the object
  SignUpData copyWith({
    String? email,
    String? password,
    String? childName,
    String? birthDate,
    String? gender,
    String? weight,
    String? height,
    String? hc,
    String? bloodG,
    String? genotype,
  }) {
    return SignUpData(
      email: email ?? this.email,
      password: password ?? this.password,
      childName: childName ?? this.childName,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      hc: hc ?? this.hc,
      bloodG: bloodG ?? this.bloodG,
      genotype: genotype ?? this.genotype,
    );
  }
}
