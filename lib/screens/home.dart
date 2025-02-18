import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../common/assets_config.dart';
import '../dummy_data.dart';
import '../routes/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Symphony', style: TextStyle(fontSize: 20)),
        actions: [
          IconButton(icon: const Icon(Icons.vertical_split), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 1,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatsCard(image: Assets.images.symphony),
                SupportSection(
                  onTap: () {
                    context.push(GoRoutes.getSupportRoute());
                  },
                ),
                const SizedBox(height: 16),
                ItemsSection(
                  title: 'Trending Items',
                  trendingList: trendingItems,
                  showMore: false,
                ),
                const SizedBox(height: 32),
                ItemsSection(
                  title: 'Games',
                  names: false,
                  trendingList: trendingGames,
                  showMore: true,
                ),
                const SizedBox(height: 32),
                StatsCard(
                  header: 'Entertainment',
                    image: Assets.images.entertainment),
                PromoCard(),
                StatsCard(
                  image: Assets.images.social,
                  title: 'JOIN SOCIAL COMMUNITY',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final String? header;
  final String? title;
  final String image;

  const StatsCard({super.key, required this.image, this.title, this.header});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              header!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Container(
          height: 180,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child:
          title != null
              ? Center(
            child: Text(
              title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          )
              : null,
        ),
      ],
    );
  }
}

class PromoCard extends StatelessWidget {
  const PromoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color:
        Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF181818)
            : const Color(0xFFF5F5F5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            VectorGraphic(
              loader: AssetBytesLoader(Assets.svg.mobile),
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 32),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Helio 5G',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Valid for: 460 Days', style: TextStyle(fontSize: 12)),
                  Text(
                    'Expiry Date: December 10, 2026',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(
              FontAwesomeIcons.chevronRight,
              color: Color(0xFFff002b),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class ItemsSection extends StatelessWidget {
  final String title;
  final bool names;
  final bool showMore;
  final List<Map<String, dynamic>> trendingList;

  const ItemsSection({
    super.key,
    required this.title,
    this.names = true,
    this.showMore = false,
    required this.trendingList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (showMore)
                GestureDetector(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Text(
                        'See More',
                        style: TextStyle(
                          color: Color(0xFFff002b),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        FontAwesomeIcons.chevronRight,
                        color: Color(0xFFff002b),
                        size: 16,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: trendingList.length,
            cacheExtent: 300,
            itemBuilder: (context, index) {
              final item = trendingList[index];
              return Container(
                width: 110,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    names
                        ? Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                        : SizedBox.shrink(),
                    names ? const SizedBox(height: 8) : SizedBox.shrink(),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          '${item['icon']}',
                          fit: BoxFit.cover,
                          cacheWidth: 220,
                          filterQuality: FilterQuality.medium,
                          gaplessPlayback: true,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SupportSection extends StatelessWidget {
  final Function onTap;

  const SupportSection({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFff002b),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onTap(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 100,
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(FontAwesomeIcons.headset, color: Colors.white, size: 24),
                  SizedBox(width: 16),
                  Text(
                    'Need Help?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Check Support',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
