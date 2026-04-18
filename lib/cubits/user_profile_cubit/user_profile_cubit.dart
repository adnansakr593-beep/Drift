import 'dart:io';
import 'package:drift_app/cubits/user_profile_cubit/user_profile_state.dart';
import 'package:drift_app/services/image_upload_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(UserProfileInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  /// Update Profile Picture (Using ImgBB CDN)
  Future<void> updateProfilePicture() async {
    try {
      emit(UserProfilePhotoUpdating());

      final user = _auth.currentUser;
      if (user == null) {
        emit(UserProfileError('No user logged in'));
        return;
      }

      // ✅ Validate ImgBB is configured
      if (!ImageUploadService.isConfigured()) {
        emit(
          UserProfileError(
            'Image upload service not configured. Please add your ImgBB API key.',
          ),
        );
        return;
      }

      // Pick image
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image == null) {
        // User cancelled
        emit(UserProfileInitial());
        return;
      }

      final File imageFile = File(image.path);

      print('📤 Uploading profile picture to CDN...');

      // ✅ Upload to ImgBB instead of Firebase Storage
      final String downloadUrl = await ImageUploadService.uploadImage(
        imageFile,
      );

      // Update Firebase Auth
      await user.updatePhotoURL(downloadUrl);
      await user.reload();

      // Update Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'photoURL': downloadUrl,
        'photo': downloadUrl, // Also update 'photo' field for consistency
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Profile picture updated successfully!');
      final updatedUser = _auth.currentUser;

      emit(UserProfilePhotoUpdateSuccess(downloadUrl, updatedUser));
    } catch (e) {
      print('❌ Error updating profile picture: $e');

      String errorMessage = 'Failed to update profile picture';

      if (e.toString().contains('timeout')) {
        errorMessage = 'Upload timeout - please check your connection';
      } else if (e.toString().contains('SocketException')) {
        errorMessage = 'No internet connection';
      }

      emit(UserProfileError(errorMessage));
    }
  }

  /// Update Display Name
  Future<void> updateDisplayName(String newName) async {
    final trimmedName = newName.trim();

    // Validation
    if (trimmedName.isEmpty) {
      emit(UserProfileError('Name cannot be empty'));
      return;
    }

    if (trimmedName.length < 2) {
      emit(UserProfileError('Name must be at least 2 characters'));
      return;
    }

    if (trimmedName.length > 50) {
      emit(UserProfileError('Name must be less than 50 characters'));
      return;
    }

    try {
      emit(UserProfileNameUpdating());

      final user = _auth.currentUser;
      if (user == null) {
        emit(UserProfileError('No user logged in'));
        return;
      }

      // Check if name actually changed
      if (user.displayName == trimmedName) {
        emit(UserProfileError('Name is the same'));
        return;
      }

      // Update Firebase Auth
      await user.updateDisplayName(trimmedName);

      // Update Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'name': trimmedName,
        'displayName': trimmedName,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await user.reload();
      final updatedUser = _auth.currentUser;

      emit(UserProfileNameUpdateSuccess(trimmedName, updatedUser));
    } catch (e) {
      emit(UserProfileError('Failed to update name: ${e.toString()}'));
    }
  }

  /// Reset to initial state
  void resetState() {
    emit(UserProfileInitial());
  }
}
