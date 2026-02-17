/// Full matrimony profile model
class ProfileModel {
  final String id;
  final String userId;
  final String name;
  final int age;
  final String gender;
  final String height;
  final String maritalStatus;
  final String religion;
  final String caste;
  final String subCaste;
  final String motherTongue;
  final String education;
  final String occupation;
  final String employedIn;
  final String annualIncome;
  final String aboutMe;

  // Family
  final String fatherName;
  final String fatherOccupation;
  final String motherName;
  final String motherOccupation;
  final int brothers;
  final int sisters;
  final String familyType;
  final String familyStatus;

  // Location
  final String city;
  final String state;
  final String country;

  // Horoscope
  final String? dob;
  final String? birthTime;
  final String? birthPlace;
  final String? star;
  final String? rasi;
  final String? dosham;

  // Lifestyle
  final String diet;
  final String smoking;
  final String drinking;

  // Photos
  final List<String> photos;
  final String profileImage;

  // Flags
  final bool isVerified;
  final bool isPhotoVerified;
  final bool isPremium;
  final bool isApproved;
  final int profileCompletion;
  final String membershipId;

  // Partner Preferences (simplified)
  final String partnerAgeRange;
  final String partnerHeightRange;
  final String partnerEducation;
  final String partnerOccupation;
  final String partnerLocation;

  final DateTime lastActive;

  ProfileModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    this.maritalStatus = 'Never Married',
    this.religion = 'Hindu',
    this.caste = '',
    this.subCaste = '',
    this.motherTongue = 'Tamil',
    this.education = '',
    this.occupation = '',
    this.employedIn = 'Private Sector',
    this.annualIncome = '',
    this.aboutMe = '',
    this.fatherName = '',
    this.fatherOccupation = '',
    this.motherName = '',
    this.motherOccupation = '',
    this.brothers = 0,
    this.sisters = 0,
    this.familyType = 'Nuclear',
    this.familyStatus = 'Middle Class',
    this.city = '',
    this.state = 'Tamil Nadu',
    this.country = 'India',
    this.dob,
    this.birthTime,
    this.birthPlace,
    this.star,
    this.rasi,
    this.dosham,
    this.diet = 'Vegetarian',
    this.smoking = 'No',
    this.drinking = 'No',
    this.photos = const [],
    this.profileImage = '',
    this.isVerified = false,
    this.isPhotoVerified = false,
    this.isPremium = false,
    this.isApproved = true,
    this.profileCompletion = 65,
    this.membershipId = '',
    this.partnerAgeRange = '25-30',
    this.partnerHeightRange = "5'4\" - 5'8\"",
    this.partnerEducation = 'Any',
    this.partnerOccupation = 'Any',
    this.partnerLocation = 'Tamil Nadu',
    DateTime? lastActive,
  }) : lastActive = lastActive ?? DateTime.now();

  // TODO: Replace with real API JSON parsing
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 25,
      gender: json['gender'] ?? 'Male',
      height: json['height'] ?? "5'6\"",
      maritalStatus: json['maritalStatus'] ?? 'Never Married',
      religion: json['religion'] ?? 'Hindu',
      caste: json['caste'] ?? '',
      education: json['education'] ?? '',
      occupation: json['occupation'] ?? '',
      employedIn: json['employedIn'] ?? 'Private Sector',
      annualIncome: json['annualIncome'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? 'Tamil Nadu',
      profileImage: json['profileImage'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
      isVerified: json['isVerified'] ?? false,
      isPhotoVerified: json['isPhotoVerified'] ?? false,
      isPremium: json['isPremium'] ?? false,
      isApproved: json['isApproved'] ?? true,
      profileCompletion: json['profileCompletion'] ?? 65,
      membershipId: json['membershipId'] ?? '',
      star: json['star'],
      rasi: json['rasi'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'name': name,
        'age': age,
        'gender': gender,
        'height': height,
        'maritalStatus': maritalStatus,
        'religion': religion,
        'caste': caste,
        'education': education,
        'occupation': occupation,
        'city': city,
        'state': state,
        'isVerified': isVerified,
        'isPremium': isPremium,
        'profileImage': profileImage,
        'membershipId': membershipId,
      };
}
