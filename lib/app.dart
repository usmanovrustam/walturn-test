import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/auth/login/login_bloc.dart';
import 'package:test_app/blocs/user/user_bloc.dart';
import 'package:test_app/screens/home.dart';
import 'package:test_app/theme/theme.dart';

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc()),
        BlocProvider(create: (_) => UserBloc()),
      ],
      child: CupertinoApp(
        theme: theme,

        /// The reason why HomeController() is placed here is to check
        /// whether there is a user after entering the application.
        /// user is checked on code lines 33-42 in home.dart file
        home: const HomeController(),
      ),
    );
  }
}
