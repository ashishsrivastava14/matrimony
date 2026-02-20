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

  ProfileModel copyWith({
    String? id,
    String? userId,
    String? name,
    int? age,
    String? gender,
    String? height,
    String? maritalStatus,
    String? religion,
    String? caste,
    String? education,
    String? occupation,
    String? city,
    String? state,
    bool? isVerified,
    bool? isPhotoVerified,
    bool? isPremium,
    bool? isApproved,
    int? profileCompletion,
    String? profileImage,
    List<String>? photos,
    DateTime? lastActive,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      religion: religion ?? this.religion,
      caste: caste ?? this.caste,
      education: education ?? this.education,
      occupation: occupation ?? this.occupation,
      city: city ?? this.city,
      state: state ?? this.state,
      country: this.country,
      subCaste: this.subCaste,
      motherTongue: this.motherTongue,
      employedIn: this.employedIn,
      annualIncome: this.annualIncome,
      aboutMe: this.aboutMe,
      fatherName: this.fatherName,
      fatherOccupation: this.fatherOccupation,
      motherName: this.motherName,
      motherOccupation: this.motherOccupation,
      brothers: this.brothers,
      sisters: this.sisters,
      familyType: this.familyType,
      familyStatus: this.familyStatus,
      dob: this.dob,
      birthTime: this.birthTime,
      birthPlace: this.birthPlace,
      star: this.star,
      rasi: this.rasi,
      dosham: this.dosham,
      diet: this.diet,
      smoking: this.smoking,
      drinking: this.drinking,
      photos: photos ?? this.photos,
      profileImage: profileImage ?? this.profileImage,
      isVerified: isVerified ?? this.isVerified,
      isPhotoVerified: isPhotoVerified ?? this.isPhotoVerified,
      isPremium: isPremium ?? this.isPremium,
      isApproved: isApproved ?? this.isApproved,
      profileCompletion: profileCompletion ?? this.profileCompletion,
      membershipId: this.membershipId,
      partnerAgeRange: this.partnerAgeRange,
      partnerHeightRange: this.partnerHeightRange,
      partnerEducation: this.partnerEducation,
      partnerOccupation: this.partnerOccupation,
      partnerLocation: this.partnerLocation,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}
