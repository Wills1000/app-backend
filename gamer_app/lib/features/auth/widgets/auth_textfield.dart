import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;

  const AuthTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.isPassword = false,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.isPassword ? obscure : false,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(
          color: Colors.white54,
        ),

        prefixIcon: Icon(
          widget.icon,
          color: const Color(0xffFF2D55),
        ),

        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white54,
                ),
                onPressed: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
              )
            : null,

        filled: true,
        fillColor: const Color(0xff18131F),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xffFF2D55),
            width: 2,
          ),
        ),
      ),
    );
  }
}