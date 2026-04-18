abstract class ForgotPassState {}


class ForgotPassInitial extends ForgotPassState{}
class ForgotPassloading extends ForgotPassState{}

class ForgotPassSent extends ForgotPassState
{
  final String message;

  ForgotPassSent({
    required this.message
  });
}



class ForgotPassFail extends ForgotPassState
{
  final String errmessage;

  ForgotPassFail({
    required this.errmessage
  });
}
