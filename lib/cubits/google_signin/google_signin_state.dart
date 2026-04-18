import 'package:firebase_auth/firebase_auth.dart';

abstract class GoogleSigninState {}

class  GoogleSigninInitial extends GoogleSigninState{}
class  GoogleSigninSuccess extends GoogleSigninState
{
  final User? user;
  GoogleSigninSuccess({this.user}) ;
}
class  GoogleSigninFailure extends GoogleSigninState
{
  final String error;
  GoogleSigninFailure({required this.error});
}
class  GoogleSigninLoading extends GoogleSigninState{}
class  GoogleSignOutLoading extends GoogleSigninState{}
class  GoogleSignOutFaill extends GoogleSigninState
{
  final String errorMess;
  GoogleSignOutFaill({required this.errorMess});
}
class  GoogleSignOutSuccs extends GoogleSigninState{}