part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class LoadingUserState extends UserState {}

class LoadedUserState extends UserState {
  final UserModel? user;
  LoadedUserState({this.user});
}

class FailedtoUserState extends UserState {
  final Exception? exception;
  FailedtoUserState({this.exception});

  bool get isRepositoryException => exception is RepositoryException;

  RepositoryException get repositoryException =>
      exception as RepositoryException;

  bool get hasException => exception != null;
}
