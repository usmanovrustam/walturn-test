part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginUserEvent extends LoginEvent {
  final Map<String, dynamic> data;
  LoginUserEvent(this.data);
}
