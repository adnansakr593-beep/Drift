import 'package:firebase_auth/firebase_auth.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfilePhotoUpdating extends UserProfileState {}

class UserProfileNameUpdating extends UserProfileState {}

class UserProfilePhotoUpdateSuccess extends UserProfileState {
  final String photoUrl;
  final User? updatedUser;
  
  UserProfilePhotoUpdateSuccess(this.photoUrl, this.updatedUser);
}

class UserProfileNameUpdateSuccess extends UserProfileState {
  final String displayName;
  final User? updatedUser;
  
  UserProfileNameUpdateSuccess(this.displayName, this.updatedUser);
}

class UserProfileError extends UserProfileState {
  final String message;
  UserProfileError(this.message);
}