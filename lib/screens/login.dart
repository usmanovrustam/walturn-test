import 'package:flutter/cupertino.dart';
import 'package:test_app/blocs/auth/login/login_bloc.dart';
import 'package:test_app/screens/home.dart';
import 'package:test_app/theme/style.dart';
import 'package:test_app/widgets/text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginController extends StatefulWidget {
  const LoginController({Key? key}) : super(key: key);

  @override
  State<LoginController> createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    context.read<LoginBloc>().add(
          LoginUserEvent({
            "email": _emailController.text.trim(),
            "password": _passwordController.text.trim(),
          }),
        );
  }

  void _loginListener(BuildContext context, LoginState state) {
    if (state is LoadedLoginState) {
      Navigator.of(context).push(
        CupertinoPageRoute(builder: (_) => const HomeController()),
      );
    }
  }

  Widget get button => BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return CupertinoButton.filled(
            disabledColor: Style.colors.grey,
            onPressed: state is! LoadingLoginState ? _login : null,
            child: state is LoadingLoginState
                ? CupertinoActivityIndicator(color: Style.colors.white)
                : const Text("Login"),
          );
        },
      );

  Widget get emailField => TextInputField(
        controller: _emailController,
        placeholder: "Enter your email address",
      );

  Widget get passwordField => TextInputField.obscured(
        controller: _passwordController,
        placeholder: "Enter your password",
      );

  Widget get view => BlocConsumer<LoginBloc, LoginState>(
        listener: _loginListener,
        builder: (context, state) {
          return ListView(
            padding: Style.padding16,
            children: [
              Text("Login", style: Style.headline6),
              const SizedBox(height: 48),
              emailField,
              const SizedBox(height: 16),
              passwordField,
              if (state is FailedtoLoginState) ...[
                const SizedBox(height: 16),
                Text(
                  state.exception.toString(),
                  style: Style.caption.copyWith(color: Style.colors.error),
                )
              ],
              const SizedBox(height: 24),
              button,
            ],
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(child: view),
    );
  }
}
