import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'widgets.dart';

const navigationItems = [
  ('Home', '/', Icons.home_outlined),
  ('Find Jobs', '/jobs', Icons.work_outline),
  ('Browse Startups', '/startups', Icons.business_outlined),
  ('Seek Funding', '/funding', Icons.bolt_outlined),
  ('For Investors', '/for-investor', Icons.trending_up),
  ('For Startups', '/for-startups', Icons.rocket_launch_outlined),
  ('Company', '/company', Icons.people_outline),
  ('Journal', '/blogs', Icons.auto_stories_outlined),
  ('Contact Us', '/contact', Icons.chat_bubble_outline),
  ('My Jobs', '/my-jobs', Icons.bookmark_border),
];

class AppFrame extends StatelessWidget {
  final String route;
  final Widget child;
  const AppFrame({super.key, required this.route, required this.child});
  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width > 900;
    final bottomRoutes = ['/', '/jobs', '/startups', '/my-jobs'];
    final index = bottomRoutes.indexOf(route);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        title: InkWell(
          onTap: () =>
              Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: HoobColors.ink,
                child: Text(
                  'H',
                  style: TextStyle(
                    color: HoobColors.lime,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Hoob',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        actions: [
          if (wide)
            ...navigationItems
                .where(
                  (x) => [
                    '/jobs',
                    '/startups',
                    '/funding',
                    '/blogs',
                  ].contains(x.$2),
                )
                .map(
                  (x) => TextButton(
                    onPressed: () => go(context, x.$2),
                    child: Text(x.$1),
                  ),
                ),
          IconButton(
            tooltip: 'My Jobs',
            onPressed: () => go(context, '/my-jobs'),
            icon: const CircleAvatar(
              radius: 17,
              backgroundColor: HoobColors.lime,
              child: Icon(
                Icons.person_outline,
                size: 20,
                color: HoobColors.ink,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 28),
                child: Text(
                  'Make your next\nmove matter. ✦',
                  style: TextStyle(
                    fontSize: 25,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              for (final item in navigationItems)
                ListTile(
                  selected: route == item.$2,
                  selectedTileColor: HoobColors.lime,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  leading: Icon(item.$3, size: 21),
                  title: Text(item.$1),
                  onTap: () {
                    Navigator.pop(context);
                    go(context, item.$2);
                  },
                ),
            ],
          ),
        ),
      ),
      body: SafeArea(top: false, bottom: false, child: child),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: index < 0 ? 1 : index,
              onDestinationSelected: (i) {
                if (route != bottomRoutes[i]) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(bottomRoutes[i], (r) => r.isFirst);
                }
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.work_outline),
                  selectedIcon: Icon(Icons.work),
                  label: 'Jobs',
                ),
                NavigationDestination(
                  icon: Icon(Icons.business_outlined),
                  selectedIcon: Icon(Icons.business),
                  label: 'Startups',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bookmark_border),
                  selectedIcon: Icon(Icons.bookmark),
                  label: 'My Jobs',
                ),
              ],
            ),
    );
  }
}
