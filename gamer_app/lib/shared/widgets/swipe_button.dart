import 'package:flutter/material.dart';

class SwipeButton extends StatefulWidget {
  final VoidCallback onCompleted;

  const SwipeButton({
    super.key,
    required this.onCompleted,
  });

  @override
  State<SwipeButton> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<SwipeButton> {
  double position = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final max = constraints.maxWidth - 70;

        return Container(
          height: 68,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(.08),
                Colors.white.withOpacity(.03),
              ],
            ),
            border: Border.all(
              color: const Color.fromARGB(255, 151, 3, 3).withOpacity(.4),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 151, 3, 3).withOpacity(.25),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),

          child: Stack(
            children: [

              Center(
                child: Text(
                  "Swipe To Start",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.95),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),

              AnimatedPositioned(
                duration: const Duration(milliseconds: 0),
                left: position,
                top: 4,
                bottom: 4,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      position += details.delta.dx;

                      if (position < 0) {
                        position = 0;
                      }

                      if (position > max) {
                        position = max;
                      }
                    });
                  },

                  onHorizontalDragEnd: (_) {
                    if (position > max * .85) {
                      setState(() {
                        position = max;
                      });

                      Future.delayed(
                        const Duration(milliseconds: 300),
                        widget.onCompleted,
                      );
                    } else {
                      setState(() {
                        position = 0;
                      });
                    }
                  },

                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 151, 3, 3),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color.fromARGB(255, 151, 3, 3).withOpacity(.7),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}