part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoadingLoginState extends LoginState {}

class LoadedLoginState extends LoginState {
  final String? token;
  LoadedLoginState({this.token});
}

class FailedtoLoginState extends LoginState {
  final Exception? exception;

  FailedtoLoginState({this.exception});

  bool get isRepositoryException => exception is RepositoryException;

  RepositoryException get repositoryException =>
      exception as RepositoryException;

  bool get hasException => exception != null;
}
