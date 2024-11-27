import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:developer' as dev;

import '../model/user_model.dart';

class AuthRepository {
  AuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  Future<void> signInWithGoogle() async {
    try {
      dev.log('Logging in with google', name: 'User');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      dev.log('User authenticated!', name: 'User');
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // dev.log('Got details from google', name: 'User');
      await _firebaseAuth.signInWithCredential(credential);
      // dev.log('Successfully signed in from repository', name: 'User');
    } on FirebaseAuthException catch (e) {
      dev.log('Got firebase error: ${e.code}', name: 'User');
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (e) {
      dev.log('Got error: $e', name: 'User');
      throw const LogInWithGoogleFailure();
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      dev.log('Got sign out error: $e', name: 'User');
      rethrow;
    }
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<Stream<UserModel?>> getUserStream(String email) async {
    final adminData = await _firestore.collection('admin').doc('admin').get();
    final coreMembersEmails = adminData['core-members-emails'] as List<dynamic>;

    String docRef = '';
    String collectionRef = '';
    String userType = '';

    if (email == adminData['email']) {
      docRef = 'admin';
      collectionRef = 'admin';
      userType = 'admin';
    } else if (coreMembersEmails.contains(email)) {
      collectionRef = 'core-members';
      docRef = email;
      userType = 'core-member';
    } else {
      collectionRef = 'club-members';
      docRef = email;
      userType = 'club-member';
    }

    return _firestore
        .collection(collectionRef)
        .doc(docRef)
        .snapshots()
        .map((event) {
      final data = event.data();
      if (data != null) {
        if (userType == 'core-member') {
          var user = CoreUserModel.fromMap(data);

          user = user.copyWith(email: email);
          user = user.copyWith(userType: userType);

          return user;
        } else if (userType == 'club-member') {
          var user = UserModel.fromMap(data);

          user = user.copyWith(email: email);
          user = user.copyWith(userType: userType);

          return user;
        } else {
          var user = UserModel(
            email: adminData['email'] as String,
            name: 'Admin ',
            userType: 'admin',
            contactNumber: '--',
            areasOfInterest: const ['In All Areas'],
            semester: 8,
            department: '--',
            registrationNumber: '--',
            description: "Admin don't need Description",
          );

          return user;
        }
      }
      return null;
    });
  }

  Future<UserModel?> registerClubMember(UserModel user, File? imageFile) async {
    try {
      // First upload user profile image and get download url
      if (imageFile != null) {
        try {
          final photoUrl = await uploadUserProfilePhoto(imageFile, user.email);
          if (photoUrl == null) {
            return null;
          } else {
            user = user.copyWith(photoUrl: photoUrl);
          }
        } catch (e) {
          dev.log('Got error: $e', name: 'Register');
          return null;
        }
      }

      // Now entry user in firestore
      await _firestore
          .collection('club-members')
          .doc(user.email)
          .set(user.toMap());
      return user;
    } catch (e) {
      dev.log('Got registration error: $e', name: 'Register');
      return null;
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

  String? getCurrentEmail() {
    return _firebaseAuth.currentUser?.email;
  }
}

class LogInWithGoogleFailure implements Exception {
  /// {@macro log_in_with_google_failure}
  const LogInWithGoogleFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithGoogleFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const LogInWithGoogleFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const LogInWithGoogleFailure(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const LogInWithGoogleFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return const LogInWithGoogleFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithGoogleFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithGoogleFailure(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const LogInWithGoogleFailure(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const LogInWithGoogleFailure(
          'The credential verification ID received is invalid.',
        );
      default:
        return const LogInWithGoogleFailure();
    }
  }

  /// The associated error message.
  final String message;
}
