import 'package:flutter/material.dart';

class StakeCard extends StatelessWidget {
  final String game;
  final String host;
  final String mode;
  final String prize;
  final String stake;

  const StakeCard({
    super.key,
    required this.game,
    required this.host,
    required this.mode,
    required this.prize,
    required this.stake,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: const Color(0xff151515),
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {

        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [

                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.grey.shade800,
                    ),
                    child: const Icon(
                      Icons.sports_esports,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          game,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          mode,
                          style: const TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      const Text(
                        "Prize",
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),

                      Text(
                        prize,
                        style: const TextStyle(
                          color: Color(0xff00D26A),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  )
                ],
              ),

              const SizedBox(height: 20),

              const Divider(color: Colors.white12),

              const SizedBox(height: 20),

              Row(
                children: [

                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xff970303),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      host,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Text(
                    stake,
                    style: const TextStyle(
                      color: Color(0xff970303),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff970303),
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {

                  },
                  child: const Text(
                    "View Challenge",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}