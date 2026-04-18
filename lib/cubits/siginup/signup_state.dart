abstract class SignupState {}

class SignupInitial extends SignupState{}
class SignupSuccess extends SignupState{}
class SignupFaill extends SignupState
{
  final String errmassege;
  SignupFaill({required this.errmassege});
}
class SignupLoading extends SignupState{}