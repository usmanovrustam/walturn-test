import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/blocs/user/user_bloc.dart';
import 'package:test_app/models/user.dart';
import 'package:test_app/screens/login.dart';
import 'package:test_app/theme/style.dart';
import 'package:test_app/utils/preferences.dart';

class HomeController extends StatefulWidget {
  const HomeController({Key? key}) : super(key: key);

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  @override
  void initState() {
    _fetchUser();
    super.initState();
  }

  void _fetchUser() {
    context.read<UserBloc>().add(LoadUserEvent());
  }

  void _logOut() async {
    final loggedOut = await Preferences.removeToken();

    if (loggedOut) _openLoginScreen(context);
  }

  void _userListener(BuildContext context, UserState state) {
    // User checking
    if (state is LoadingUserState) return;

    if (state is FailedtoUserState) {
      if (state.isRepositoryException &&
          state.repositoryException.unauthorized()) {
        _openLoginScreen(context);
      }
    }
  }

  void _openLoginScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (_) => LoginController()),
      (_) => false,
    );
  }

  Widget get logoutButton => CupertinoButton(
        onPressed: _logOut,
        child: Text(
          "Log Out",
          style: Style.body1.copyWith(color: Style.colors.error),
        ),
      );

  Widget userInfo(UserModel user) => Padding(
        padding: Style.padding16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Hello, ${user.name}", style: Style.headline6),
            const SizedBox(height: 10),
            Text("Your email: ${user.email}", style: Style.body1),
            const SizedBox(height: 10),
            Text("Your age: ${user.age}", style: Style.body1),
            const Spacer(),
            logoutButton
          ],
        ),
      );

  Widget get view => BlocConsumer<UserBloc, UserState>(
        listener: _userListener,
        buildWhen: (_, state) =>
            state is LoadingUserState || state is LoadedUserState,
        builder: (context, state) {
          return state is! LoadedUserState
              ? Center(child: CupertinoActivityIndicator())
              : userInfo(state.user!);
        },
      );

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(child: view),
    );
  }
}
