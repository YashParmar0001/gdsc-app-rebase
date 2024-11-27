import 'dart:io';
import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gdsc_atmiya/model/user_model.dart';

class UserRepository {
  UserRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  Future<String?> updateUserProfile(
    UserModel user,
    Map<String, dynamic> userData,
    File? imageFile,
    bool removeProfilePhoto,
  ) async {
    try {
      if (imageFile != null) {
        try {
          final photoUrl = await uploadUserProfilePhoto(imageFile, user.email);
          if (photoUrl == null) {
            return 'Some error occurred!';
          } else {
            userData['photoUrl'] = photoUrl;
            // return null;
          }
        } catch (e) {
          dev.log('Got error: $e', name: 'Register');
          return null;
        }
      } else if (removeProfilePhoto) {
        userData['photoUrl'] = '';
      }

      if (user.userType == 'core-member') {
        await _firestore
            .collection('core-members')
            .doc(user.email)
            .update(userData);
        return null;
      } else {
        await _firestore
            .collection('club-members')
            .doc(user.email)
            .update(userData);
        return null;
      }
    } catch (e) {
      dev.log('Got update error: $e', name: 'Update');
      return 'Some error occurred!';
    }
  }

  Future<String?> uploadUserProfilePhoto(File imageFile, String email) async {
    try {
      await _storage.ref('profile_photos/$email').putFile(imageFile);
      dev.log('Successfully uploaded user profile', name: 'Register');
      return await _storage.ref('profile_photos/$email').getDownloadURL();
    } catch (e) {
      dev.log('Error occurred while uploading user profile', name: 'Register');
      return null;
    }
  }

  Future<List<UserModel>> getClubMemberList() async {
    List<UserModel> clubMembers = [];
    try {
      final snapshots = await _firestore.collection('club-members').get();
      for (var element in snapshots.docs) {
        clubMembers.add(UserModel.fromMap(element.data()));
      }
      return clubMembers;
    } catch (e) {
      dev.log(e.toString(), name: "Club Members");
      return clubMembers;
    }
  }
}
