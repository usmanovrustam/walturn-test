import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:test_app/repositories/auth.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/repositories/utils/exception.dart';
import 'package:test_app/utils/preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final client = http.Client();
  LoginBloc() : super(LoginInitialState()) {
    on<LoginUserEvent>(_login);
  }

  void _login(LoginUserEvent event, Emitter<LoginState> emit) async {
    emit(LoadingLoginState());
    try {
      final token = await AuthRepository.login(client, event.data);

      if (await Preferences.setToken(token)) {
        emit(LoadedLoginState(token: token));
      } else {
        emit(FailedtoLoginState(exception: Exception("Cannot save token")));
      }
    } on Exception catch (exception) {
      emit(FailedtoLoginState(exception: exception));
    }
  }

  @override
  Future<void> close() {
    client.close();
    return super.close();
  }
}
