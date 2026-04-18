abstract class SigninState {}

class SigninInitial extends SigninState{}

class SigninSucss extends SigninState{}
class SigninLoading extends SigninState{}
class SigninFaill extends SigninState
{
  final String errmassege;

  SigninFaill({required this.errmassege});
}
