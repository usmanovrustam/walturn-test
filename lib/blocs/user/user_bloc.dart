import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:test_app/models/user.dart';
import 'package:test_app/repositories/user.dart';
import 'package:test_app/repositories/utils/exception.dart';
import 'package:http/http.dart' as http;

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final client = http.Client();
  UserBloc() : super(UserInitial()) {
    on<LoadUserEvent>(_fetchUser);
  }

  void _fetchUser(LoadUserEvent event, Emitter<UserState> emit) async {
    emit(LoadingUserState());
    try {
      final user = await UserRepository.fetchUser(client);
      emit(LoadedUserState(user: user));
    } on Exception catch (e) {
      emit(FailedtoUserState(exception: e));
    }
  }

  @override
  Future<void> close() {
    client.close();
    return super.close();
  }
}
