// ignore_for_file: deprecated_member_use
import 'package:drift_app/helper/const.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final Icon? prefixIcon;
  final bool isPassword;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final TextEditingController? controller;
  final double? width;
  final Widget? suffixIcon;
  final void Function(String)? onSubmitted;
  final double? hintSize;

  const CustomTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.onChanged,
    this.validator,
    this.fillColor,
    this.controller,
    this.width,
    this.suffixIcon,
    this.onSubmitted,
    this.hintSize,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 56,
      width: widget.width ?? 290,
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        style: TextStyle(
          color: colors.onSurface,
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),

        obscureText: _obscureText,
        cursorColor: colors.onBackground,
        onSubmitted: widget.onSubmitted,

        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor ?? colors.background,
          hintText: widget.hintText,
          suffixIconColor: colors.primary,
          hintStyle: TextStyle(
            color: colors.onSurface,
            fontFamily: fontFamily,
            letterSpacing: 1.2,
            fontSize: widget.hintSize ?? 18,
          ),
          prefixIcon: widget.prefixIcon,
          prefixIconColor: colors.onSurface,

          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: colors.onSurface,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : widget.suffixIcon,

          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colors.onSurface.withOpacity(0.5),
              width: 2,
            ),

            borderRadius: BorderRadius.circular(28),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.primary, width: 2),
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
    );
  }
}
