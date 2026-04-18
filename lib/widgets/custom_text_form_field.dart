// ignore_for_file: deprecated_member_use

import 'package:drift_app/helper/const.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String? hintText;
  final Icon? prefixIcon;
  final bool isPassword;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final TextEditingController? controller;
  final double? width;
  final Widget? suffixIcon;
  final void Function(String?)? onSaved;

  const CustomTextFormField({
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
    this.onSaved,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
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
      child: TextFormField(
        onSaved: widget.onSaved,
        controller: widget.controller,
        validator: widget.validator,
        onChanged: widget.onChanged,
        style: TextStyle(color: colors.onBackground),
        obscureText: _obscureText,
        cursorColor: colors.onBackground,

        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: colors.onBackground,
            fontFamily: fontFamily,
            letterSpacing: 1.2,
          ),
          prefixIcon: widget.prefixIcon,
          prefixIconColor: colors.onBackground,

          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: colors.onBackground,
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
              color: colors.onSurface.withOpacity(0.7),
              width: 2,
            ),

            borderRadius: BorderRadius.circular(28),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.primary, width: 2),
            borderRadius: BorderRadius.circular(28),
          ),

          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
    );
  }
}
