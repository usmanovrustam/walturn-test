import 'package:flutter/cupertino.dart';
import 'package:test_app/theme/style.dart';

class TextInputField extends StatefulWidget {
  /// This TextField is a reuasble widget, to create custom
  /// fields for obscured and simple text fields
  final String? placeholder;
  final TextEditingController controller;
  final ValueChanged<String>? onChange;
  final bool obscured;

  const TextInputField.obscured({
    Key? key,
    required this.controller,
    this.placeholder,
    this.onChange,
  })  : obscured = true,
        super(key: key);

  const TextInputField({
    Key? key,
    required this.controller,
    this.placeholder,
    this.onChange,
  })  : obscured = false,
        super(key: key);

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: widget.controller,
      placeholder: widget.placeholder,
      onChanged: widget.onChange,
      obscureText: widget.obscured,
      style: Style.caption,
      padding: Style.padding12,
      decoration: BoxDecoration(
        borderRadius: Style.border8,
        color: Style.colors.transparent,
        border: Border.all(color: Style.colors.primary),
      ),
    );
  }
}
