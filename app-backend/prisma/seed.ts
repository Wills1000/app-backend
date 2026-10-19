import { PrismaClient, GameStatus } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('Seeding games...');

  const games = [
    {
      title: 'Call of Duty: Mobile',
      slug: 'codm',
      description: 'Fast-paced multiplayer action and battle royale on mobile.',
      status: GameStatus.ACTIVE,
      iconUrl: 'https://example.com/icons/codm.png',
      bannerUrl: 'https://example.com/banners/codm.png',
      modes: {
        create: [
          { name: 'Multiplayer - Search & Destroy' },
          { name: 'Battle Royale - Solo/Squad' },
        ],
      },
    },
    {
      title: 'PUBG Mobile',
      slug: 'pubg-mobile',
      description: 'The original battle royale mobile experience.',
      status: GameStatus.ACTIVE,
      iconUrl: 'https://example.com/icons/pubg.png',
      bannerUrl: 'https://example.com/banners/pubg.png',
      modes: {
        create: [
          { name: 'Classic Erangel' },
          { name: 'TDM Warehouse' },
        ],
      },
    },
    {
      title: 'EA Sports FC Mobile',
      slug: 'fc-mobile',
      description: 'Build your ultimate dream squad and compete head-to-head.',
      status: GameStatus.ACTIVE,
      iconUrl: 'https://example.com/icons/fcmobile.png',
      bannerUrl: 'https://example.com/banners/fcmobile.png',
      modes: {
        create: [
          { name: 'Head-to-Head Match' },
          { name: 'Manager Mode' },
        ],
      },
    },
  ];

  for (const game of games) {
    await prisma.game.upsert({
      where: { slug: game.slug },
      update: {},
      create: game,
    });
  }

  console.log('Games seeded successfully!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });