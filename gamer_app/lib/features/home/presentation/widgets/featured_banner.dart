import 'package:flutter/material.dart';
import 'package:gamer_app/features/dummy/testing_screen.dart';

class FeaturedBanner extends StatelessWidget {
  const FeaturedBanner({
    super.key,
    required this.banners,
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
  });

  final List<Map<String, String>> banners;
  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: controller,
            itemCount: banners.length,
            onPageChanged: (index) {
  onPageChanged(index);
},
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
child: ClipRRect(
  borderRadius: BorderRadius.circular(10),
  child: Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage(banner['img']!),
      fit: BoxFit.cover,
    ),
  ),
  child: Stack(
    children: [

      Positioned.fill(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(0, 0, 0, 0.15),
                Color.fromRGBO(0, 0, 0, 0.55),
                Color.fromRGBO(0, 0, 0, 0.95),
              ],
            ),
          ),
        ),
      ),

      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xffE50914).withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xffE50914).withOpacity(0.6),
                            ),
                          ),
                          child: Text(
                            banner['tag']!,
                            style: const TextStyle(
                              color: Color(0xffFF4D4D),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          banner['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          banner['desc']!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Text(
                                'Play Now',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              label: const Icon(Icons.sports_esports_rounded, size: 16),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffE50914),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton(
                              onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TestingScreen(),
      ),
    );
  },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                              ),
                              child: const Text('Arena'),
                            ),
                          ],
                        ),
                      ],
                    ),
                   ),
                  ],
                ),
              ),
             ),
            );
          },
        ),
      ),
        const SizedBox(height: 10),

        // Carousel Page Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: currentIndex == index ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? const Color(0xffE50914)
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}