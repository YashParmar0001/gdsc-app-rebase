import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.email,
    required this.name,
    required this.userType,
    required this.registrationNumber,
    required this.department,
    required this.semester,
    required this.areasOfInterest,
    this.photoUrl,
    this.description,
    required this.contactNumber,
    this.linkedInUrl,
    this.githubUrl,
    this.discordUserName,
  });

  final String email;
  final String name;
  final String userType;
  final String registrationNumber;
  final String department;
  final int semester;
  final List<String> areasOfInterest;
  final String? photoUrl;
  final String? description;
  final String contactNumber;
  final String? linkedInUrl;
  final String? githubUrl;
  final String? discordUserName;

  // static const empty = UserModel(email: '');
  //
  // bool get isEmpty => this == UserModel.empty;
  //
  // bool get isNotEmpty => this != UserModel.empty;

  @override
  List<Object?> get props => [
        email,
        name,
        userType,
        registrationNumber,
        department,
        semester,
        areasOfInterest,
        photoUrl,
        description,
        contactNumber,
        linkedInUrl,
        githubUrl,
        discordUserName,
      ];

//<editor-fold desc="Data Methods">

  @override
  String toString() {
    return 'UserModel{ email: $email, name: $name, userType: $userType, regNumber: $registrationNumber, department: $department, semester: $semester, areasOfInterest: $areasOfInterest, photoUrl: $photoUrl, description: $description, contactNumber: $contactNumber, linkedInUrl: $linkedInUrl, githubUrl: $githubUrl, discordUrl: $discordUserName}';
  }

  UserModel copyWith({
    String? email,
    String? name,
    String? userType,
    String? registrationNumber,
    String? department,
    int? semester,
    List<String>? areasOfInterest,
    String? photoUrl,
    String? description,
    String? contactNumber,
    String? linkedInUrl,
    String? githubUrl,
    String? discordUserName,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      userType: userType ?? this.userType,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      areasOfInterest: areasOfInterest ?? this.areasOfInterest,
      photoUrl: photoUrl ?? this.photoUrl,
      description: description ?? this.description,
      contactNumber: contactNumber ?? this.contactNumber,
      linkedInUrl: linkedInUrl ?? this.linkedInUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      discordUserName: discordUserName ?? this.discordUserName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email' : email,
      'registrationNumber': registrationNumber,
      'department': department,
      'semester': semester.toString(),
      'areasOfInterest': areasOfInterest,
      'photoUrl': photoUrl ?? '',
      'description': description ?? '',
      'contactNumber': contactNumber,
      'linkedInUrl': linkedInUrl ?? '',
      'githubUrl': githubUrl ?? '',
      'discordUserName': discordUserName ?? '',
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      name: map['name'] as String,
      userType: '',
      registrationNumber: map['registrationNumber'] as String,
      department: map['department'] as String,
      semester: int.parse(map['semester'] as String),
      areasOfInterest: (map['areasOfInterest'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      photoUrl:
          (map['photoUrl'] as String) == '' ? null : map['photoUrl'] as String,
      description: (map['description'] as String) == ''
          ? null
          : map['description'] as String,
      contactNumber: map['registrationNumber'] as String,
      linkedInUrl: (map['linkedInUrl'] as String) == ''
          ? null
          : map['linkedInUrl'] as String,
      githubUrl: (map['githubUrl'] as String) == ''
          ? null
          : map['githubUrl'] as String,
      discordUserName: (map['discordUserName'] as String) == ''
          ? null
          : map['discordUserName'] as String,
    );
  }

//</editor-fold>
}

class CoreUserModel extends UserModel {
  const CoreUserModel({
    required super.email,
    required super.name,
    required super.userType,
    required super.registrationNumber,
    required super.department,
    required super.semester,
    required super.areasOfInterest,
    required super.photoUrl,
    super.description,
    required super.contactNumber,
    super.linkedInUrl,
    super.githubUrl,
    super.discordUserName,
    required this.lead,
    required this.thumbnailUrl,
  });

  final String lead;
  final String thumbnailUrl;

  @override
  CoreUserModel copyWith({
    String? email,
    String? name,
    String? userType,
    String? registrationNumber,
    String? department,
    int? semester,
    List<String>? areasOfInterest,
    String? photoUrl,
    String? description,
    String? contactNumber,
    String? linkedInUrl,
    String? githubUrl,
    String? discordUserName,
    String? lead,
    String? thumbnailUrl,
  }) {
    return CoreUserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      userType: userType ?? this.userType,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      areasOfInterest: areasOfInterest ?? this.areasOfInterest,
      photoUrl: photoUrl ?? this.photoUrl,
      description: description ?? this.description,
      contactNumber: contactNumber ?? this.contactNumber,
      linkedInUrl: linkedInUrl ?? this.linkedInUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      discordUserName: discordUserName ?? this.discordUserName,
      lead: lead ?? this.lead,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  factory CoreUserModel.fromMap(Map<String, dynamic> map) {
    return CoreUserModel(
      email: '',
      name: map['name'] as String,
      userType: '',
      registrationNumber: map['registrationNumber'] as String,
      department: map['department'] as String,
      semester: int.parse(map['semester'] as String),
      areasOfInterest: (map['areasOfInterest'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      photoUrl: map['photoUrl'] as String,
      description: (map['description'] as String) == ''
          ? null
          : map['description'] as String,
      contactNumber: map['contactNumber'] as String,
      linkedInUrl: (map['linkedInUrl'] as String) == ''
          ? null
          : map['linkedInUrl'] as String,
      githubUrl: (map['githubUrl'] as String) == ''
          ? null
          : map['githubUrl'] as String,
      discordUserName: (map['discordUserName'] as String) == ''
          ? null
          : map['discordUserName'] as String,
      lead: map['lead'] as String,
      thumbnailUrl: map['thumbnailUrl'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['lead'] = lead;
    map['thumbnailUrl'] = thumbnailUrl;
    return map;
  }

  @override
  List<Object?> get props => super.props..add(lead);
}
