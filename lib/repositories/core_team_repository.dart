import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdsc_atmiya/model/user_model.dart';

import 'dart:developer' as dev;

class CoreTeamRepository {
  CoreTeamRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<CoreUserModel>> getCoreTeamMembers() async {
    final documents = await _firestore.collection('core-members').get();
    return documents.docs.map((snapshot) {
      dev.log('Got data: ${snapshot.data()}', name: 'CoreTeam');
      var coreMember = CoreUserModel.fromMap(snapshot.data());
      coreMember = coreMember.copyWith(email: snapshot.id);
      coreMember = coreMember.copyWith(userType: 'core-member');

      return coreMember;
    }).toList();
  }
}
