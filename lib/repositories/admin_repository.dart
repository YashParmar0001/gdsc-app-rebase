import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRepository {
  AdminRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<Map<String, String>> getAdminDetails() async {
    final adminData = await _firestore.collection('admin').doc('admin').get();
    final data = adminData.data();

    return {
      'linkedinUrl': data!['linkedinUrl'] as String,
      'instagramUrl' :data['instagramUrl'] as String,
      'githubUrl': data['githubUrl'] as String,
      'youtubeUrl': data['youtubeUrl'] as String,
      'discordUrl': data['discordUrl'] as String,
      'communityUrl' :data['communityUrl'] as String,
      'email' : data['email'] as String,
    };
  }
}
