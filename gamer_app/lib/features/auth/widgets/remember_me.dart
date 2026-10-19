import 'package:flutter/material.dart';

class RememberMe extends StatefulWidget {
  const RememberMe({super.key});

  @override
  State<RememberMe> createState() => _RememberMeState();
}

class _RememberMeState extends State<RememberMe> {
  bool remember = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: remember,
          activeColor: const Color(0xffA50101),
          onChanged: (value) {
            setState(() {
              remember = value ?? false;
            });
          },
        ),

        const Text(
          "Remember Me",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),

        const Spacer(),

        TextButton(
          onPressed: () {},
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
              color: Color(0xffFF2D55),
            ),
          ),
        ),
      ],
    );
  }
}