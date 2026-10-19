import 'package:flutter/material.dart';
import '../../../challenge/presentation/pages/challenge_creation_screen.dart';

class GamesLibrary extends StatelessWidget {
  const GamesLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> games = [
      {
        'title': 'Call of Duty: Mobile',
        'sub': 'FPS',
        'img': 'assets/images/games/codm.jpg',
      },
      {
        'title': 'Standoff 2',
        'sub': 'FPS',
        'img': 'assets/images/games/standoff2.jpg',
      },
      {
        'title': 'Critical Ops',
        'sub': 'FPS',
        'img': 'assets/images/games/critical_ops.jpg',
      },
      {
        'title': '1v1.LOL',
        'sub': 'FPS',
        'img': 'assets/images/games/1v1_lol.jpg',
      },
      {
        'title': 'Blood Strike',
        'sub': 'FPS',
        'img': 'assets/images/games/blood_strike.jpg',
      },
      {
        'title': 'Modern Combat 5',
        'sub': 'FPS',
        'img': 'assets/images/games/mc5.jpg',
      },
      {
        'title': 'Pixel Gun 3D',
        'sub': 'FPS',
        'img': 'assets/images/games/pixel_gun.jpg',
      },
      {
        'title': 'Forward Assault',
        'sub': 'FPS',
        'img': 'assets/images/games/forward_assault.jpg',
      },
      {
        'title': 'Special Forces Group 2',
        'sub': 'FPS',
        'img': 'assets/images/games/sfg2.jpg',
      },
      {
        'title': 'Bullet Force',
        'sub': 'FPS',
        'img': 'assets/images/games/bullet_force.jpg',
      },
      {
        'title': 'Combat Master',
        'sub': 'FPS',
        'img': 'assets/images/games/combat_master.jpg',
      },
      {
        'title': 'Shell Shockers',
        'sub': 'FPS',
        'img': 'assets/images/games/shell_shockers.jpg',
      },
      {
        'title': 'MilkChoco',
        'sub': 'FPS',
        'img': 'assets/images/games/milkchoco.jpg',
      },
      {
        'title': 'MaskGun',
        'sub': 'FPS',
        'img': 'assets/images/games/maskgun.jpg',
      },
      {
        'title': 'Special Forces Group 3',
        'sub': 'FPS',
        'img': 'assets/images/games/sfg3.jpg',
      },

      // --- Football ---
      {
        'title': 'eFootball',
        'sub': 'Football',
        'img': 'assets/images/games/efootball.jpg',
      },
      {
        'title': 'EA Sports FC Mobile',
        'sub': 'Football',
        'img': 'assets/images/games/fc_mobile.jpg',
      },
      {
        'title': 'Head Ball 2',
        'sub': 'Football',
        'img': 'assets/images/games/head_ball_2.jpg',
      },
      {
        'title': 'Dream League Soccer',
        'sub': 'Football',
        'img': 'assets/images/games/dls.jpg',
      },
      {
        'title': 'Score! Match',
        'sub': 'Football',
        'img': 'assets/images/games/score_match.jpg',
      },
      {
        'title': 'Football Strike',
        'sub': 'Football',
        'img': 'assets/images/games/football_strike.jpg',
      },
      {
        'title': 'Mini Football',
        'sub': 'Football',
        'img': 'assets/images/games/mini_football.jpg',
      },
      {
        'title': 'Ultimate Soccer',
        'sub': 'Football',
        'img': 'assets/images/games/ultimate_soccer.jpg',
      },
      {
        'title': 'Sociable Soccer',
        'sub': 'Football',
        'img': 'assets/images/games/sociable_soccer.jpg',
      },
      {
        'title': 'World Football League',
        'sub': 'Football',
        'img': 'assets/images/games/wfl.jpg',
      },
      {
        'title': 'Soccer Stars',
        'sub': 'Football',
        'img': 'assets/images/games/soccer_stars.jpg',
      },
      {
        'title': 'Extreme Football',
        'sub': 'Football',
        'img': 'assets/images/games/extreme_football.jpg',
      },
      {
        'title': 'Rumble Stars Football',
        'sub': 'Football',
        'img': 'assets/images/games/rumble_stars.jpg',
      },

      // --- Battle Royale ---
      {
        'title': 'Free Fire',
        'sub': 'Battle Royale',
        'img': 'assets/images/games/free_fire.jpg',
      },
      {
        'title': 'PUBG Mobile',
        'sub': 'Battle Royale',
        'img': 'assets/images/games/pubg.jpg',
      },
      {
        'title': 'Farlight 84',
        'sub': 'Battle Royale',
        'img': 'assets/images/games/farlight84.jpg',
      },
      {
        'title': 'Free Fire MAX',
        'sub': 'Battle Royale',
        'img': 'assets/images/games/free_fire_max.jpg',
      },
      {
        'title': 'PUBG Mobile Lite',
        'sub': 'Battle Royale',
        'img': 'assets/images/games/pubg_lite.jpg',
      },
      {
        'title': 'BGMI',
        'sub': 'Battle Royale',
        'img': 'assets/images/games/bgmi.jpg',
      },
      {
        'title': 'Zooba',
        'sub': 'Battle Royale',
        'img': 'assets/images/games/zooba.jpg',
      },
      {
        'title': 'Knives Out',
        'sub': 'Battle Royale',
        'img': 'assets/images/games/knives_out.jpg',
      },
      {
        'title': 'Rules of Survival 2.0',
        'sub': 'Battle Royale',
        'img': 'assets/images/games/ros2.jpg',
      },
      {
        'title': 'Cyber Hunter',
        'sub': 'Battle Royale',
        'img': 'assets/images/games/cyber_hunter.jpg',
      },
      {
        'title': 'Sausage Man',
        'sub': 'Battle Royale',
        'img': 'assets/images/games/sausage_man.jpg',
      },
      {
        'title': 'Omega Strikers',
        'sub': 'Battle Royale',
        'img': 'assets/images/games/omega_strikers.jpg',
      },
      {
        'title': 'ScarFall',
        'sub': 'Battle Royale',
        'img': 'assets/images/games/scarfall.jpg',
      },

      // --- Fighting ---
      {
        'title': 'Mortal Kombat',
        'sub': 'Fighting',
        'img': 'assets/images/games/mortal_kombat.jpg',
      },
      {
        'title': 'Shadow Fight Arena',
        'sub': 'Fighting',
        'img': 'assets/images/games/shadow_fight_arena.jpg',
      },
      {
        'title': 'Brawlhalla',
        'sub': 'Fighting',
        'img': 'assets/images/games/brawlhalla.jpg',
      },
      {
        'title': 'Shadow Fight 2',
        'sub': 'Fighting',
        'img': 'assets/images/games/shadow_fight_2.jpg',
      },
      {
        'title': 'Shadow Fight 3',
        'sub': 'Fighting',
        'img': 'assets/images/games/shadow_fight_3.jpg',
      },
      {
        'title': 'Injustice 2 Mobile',
        'sub': 'Fighting',
        'img': 'assets/images/games/injustice_2.jpg',
      },
      {
        'title': 'EA Sports UFC Mobile 2',
        'sub': 'Fighting',
        'img': 'assets/images/games/ufc_mobile_2.jpg',
      },
      {
        'title': 'Street Fighter IV CE',
        'sub': 'Fighting',
        'img': 'assets/images/games/street_fighter_4.jpg',
      },
      {
        'title': 'Real Steel World Robot Boxing',
        'sub': 'Fighting',
        'img': 'assets/images/games/real_steel.jpg',
      },
      {
        'title': 'Skullgirls: Fighting RPG',
        'sub': 'Fighting',
        'img': 'assets/images/games/skullgirls.jpg',
      },
      {
        'title': 'Flash Party',
        'sub': 'Fighting',
        'img': 'assets/images/games/flash_party.jpg',
      },
      {
        'title': 'WWE Mayhem',
        'sub': 'Fighting',
        'img': 'assets/images/games/wwe_mayhem.jpg',
      },
      {
        'title': 'Taichi Panda',
        'sub': 'Fighting',
        'img': 'assets/images/games/taichi_panda.jpg',
      },
      {
        'title': 'Smash Legends',
        'sub': 'Fighting',
        'img': 'assets/images/games/smash_legends.jpg',
      },
      {
        'title': 'Fighter Clubs',
        'sub': 'Fighting',
        'img': 'assets/images/games/fighter_clubs.jpg',
      },

      // --- Racing ---
      {
        'title': 'Asphalt 9: Legends',
        'sub': 'Racing',
        'img': 'assets/images/games/asphalt_9.jpg',
      },
      {
        'title': 'Asphalt 8: Airborne',
        'sub': 'Racing',
        'img': 'assets/images/games/asphalt_8.jpg',
      },
      {
        'title': 'Real Racing 3',
        'sub': 'Racing',
        'img': 'assets/images/games/real_racing_3.jpg',
      },
      {
        'title': 'NFS: No Limits',
        'sub': 'Racing',
        'img': 'assets/images/games/nfs_no_limits.jpg',
      },
      {
        'title': 'CSR Racing 2',
        'sub': 'Racing',
        'img': 'assets/images/games/csr_2.jpg',
      },
      {
        'title': 'Mario Kart Tour',
        'sub': 'Racing',
        'img': 'assets/images/games/mario_kart.jpg',
      },
      {
        'title': 'SUP Multiplayer Racing',
        'sub': 'Racing',
        'img': 'assets/images/games/sup_racing.jpg',
      },
      {
        'title': 'Drive Ahead!',
        'sub': 'Racing',
        'img': 'assets/images/games/drive_ahead.jpg',
      },
      {
        'title': 'F1 Mobile Racing',
        'sub': 'Racing',
        'img': 'assets/images/games/f1_mobile.jpg',
      },
      {
        'title': 'Rebel Racing',
        'sub': 'Racing',
        'img': 'assets/images/games/rebel_racing.jpg',
      },
      {
        'title': 'Speedstorm',
        'sub': 'Racing',
        'img': 'assets/images/games/speedstorm.jpg',
      },
      {
        'title': 'KartRider Rush+',
        'sub': 'Racing',
        'img': 'assets/images/games/kartrider.jpg',
      },
      {
        'title': 'Nitro Nation Drag & Drift',
        'sub': 'Racing',
        'img': 'assets/images/games/nitro_nation.jpg',
      },
      {
        'title': 'Top Drives',
        'sub': 'Racing',
        'img': 'assets/images/games/top_drives.jpg',
      },

      // --- Sports ---
      {
        'title': '8 Ball Pool',
        'sub': 'Sports',
        'img': 'assets/images/games/8_ball_pool.jpg',
      },
      {
        'title': 'Golf Clash',
        'sub': 'Sports',
        'img': 'assets/images/games/golf_clash.jpg',
      },
      {
        'title': 'Tennis Clash',
        'sub': 'Sports',
        'img': 'assets/images/games/tennis_clash.jpg',
      },
      {
        'title': 'Basketball Stars',
        'sub': 'Sports',
        'img': 'assets/images/games/basketball_stars.jpg',
      },
      {
        'title': 'NBA 2K Mobile',
        'sub': 'Sports',
        'img': 'assets/images/games/nba_2k_mobile.jpg',
      },
      {
        'title': 'Real Cricket 24',
        'sub': 'Sports',
        'img': 'assets/images/games/real_cricket_24.jpg',
      },
      {
        'title': 'Carrom Pool',
        'sub': 'Sports',
        'img': 'assets/images/games/carrom_pool.jpg',
      },
      {
        'title': 'Golf Blitz',
        'sub': 'Sports',
        'img': 'assets/images/games/golf_blitz.jpg',
      },
      {
        'title': 'Darts of Fury',
        'sub': 'Sports',
        'img': 'assets/images/games/darts_of_fury.jpg',
      },
      {
        'title': 'Bowmasters',
        'sub': 'Sports',
        'img': 'assets/images/games/bowmasters.jpg',
      },
      {
        'title': 'Table Tennis Touch',
        'sub': 'Sports',
        'img': 'assets/images/games/table_tennis_touch.jpg',
      },
      {
        'title': 'WCC3',
        'sub': 'Sports',
        'img': 'assets/images/games/wcc3.jpg',
      },
      {
        'title': 'Ultimate Tennis',
        'sub': 'Sports',
        'img': 'assets/images/games/ultimate_tennis.jpg',
      },
      {
        'title': 'PGA TOUR Golf Shootout',
        'sub': 'Sports',
        'img': 'assets/images/games/pga_tour.jpg',
      },
      {
        'title': 'World Bowling Championships',
        'sub': 'Sports',
        'img': 'assets/images/games/world_bowling.jpg',
      },

      // --- Strategy ---
      {
        'title': 'Clash Royale',
        'sub': 'Strategy',
        'img': 'assets/images/games/clash_royale.jpg',
      },
      {
        'title': 'Marvel Snap',
        'sub': 'Strategy',
        'img': 'assets/images/games/marvel_snap.jpg',
      },
      {
        'title': 'Hearthstone',
        'sub': 'Strategy',
        'img': 'assets/images/games/hearthstone.jpg',
      },
      {
        'title': 'Yu-Gi-Oh! Master Duel',
        'sub': 'Strategy',
        'img': 'assets/images/games/yugioh_master_duel.jpg',
      },
      {
        'title': 'Yu-Gi-Oh! Duel Links',
        'sub': 'Strategy',
        'img': 'assets/images/games/yugioh_duel_links.jpg',
      },
      {
        'title': 'Chess.com',
        'sub': 'Strategy',
        'img': 'assets/images/games/chess_com.jpg',
      },
      {
        'title': 'Lichess',
        'sub': 'Strategy',
        'img': 'assets/images/games/lichess.jpg',
      },
      {
        'title': 'Pokémon TCG Pocket',
        'sub': 'Strategy',
        'img': 'assets/images/games/pokemon_tcg_pocket.jpg',
      },
      {
        'title': 'Magic: The Gathering Arena',
        'sub': 'Strategy',
        'img': 'assets/images/games/mtg_arena.jpg',
      },
      {
        'title': 'Legends of Runeterra',
        'sub': 'Strategy',
        'img': 'assets/images/games/legends_of_runeterra.jpg',
      },
      {
        'title': 'Phobies',
        'sub': 'Strategy',
        'img': 'assets/images/games/phobies.jpg',
      },
      {
        'title': 'Stormbound',
        'sub': 'Strategy',
        'img': 'assets/images/games/stormbound.jpg',
      },
      {
        'title': 'Auto Chess',
        'sub': 'Strategy',
        'img': 'assets/images/games/auto_chess.jpg',
      },
      {
        'title': 'Card Monsters',
        'sub': 'Strategy',
        'img': 'assets/images/games/card_monsters.jpg',
      },
      {
        'title': 'Teamfight Tactics',
        'sub': 'Strategy',
        'img': 'assets/images/games/tft.jpg',
      },
    ];

    final filteredGames = games.where((game) {
      return game['title']!.toLowerCase().contains("");
    }).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.62,
        crossAxisSpacing: 10,
        mainAxisSpacing: 14,
      ),
      itemCount: filteredGames.length,
      itemBuilder: (context, index) {
        final game = filteredGames[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChallengeCreationScreen(
                    initialGame: game['title']!,
                    initialGameImage: game['img']!,
                    selectedMode: game['sub']!,
                  ),
                ),
              ); 
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                        width: 1,
                      ),
                      image: DecorationImage(
                        image: AssetImage(game['img']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  game['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  game['sub']!,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}