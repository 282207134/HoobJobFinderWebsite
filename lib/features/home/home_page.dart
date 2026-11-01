import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../shared/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final search = TextEditingController();
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageBody(
    children: [
      LayoutBuilder(
        builder: (context, box) {
          final intro = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Tag('2,886 possibilities. One next chapter.'),
              const SizedBox(height: 22),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: Text(
                      'Find your next\nexciting startup job',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  const Positioned(
                    top: 0,
                    right: 0,
                    child: Text(
                      '✦',
                      style: TextStyle(fontSize: 40, color: HoobColors.yellow),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Big ideas need great people. Discover a role\nwhere you can make a difference.',
                style: TextStyle(
                  color: HoobColors.muted,
                  fontSize: 15,
                  height: 1.65,
                ),
              ),
              const SizedBox(height: 24),
              HardPanel(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key('home-search'),
                        controller: search,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) =>
                            go(context, '/jobs', arguments: search.text),
                        decoration: const InputDecoration(
                          hintText: 'Company, job title…',
                          prefixIcon: Icon(Icons.search, size: 20),
                          filled: false,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    FilledButton(
                      onPressed: () =>
                          go(context, '/jobs', arguments: search.text),
                      child: const Icon(Icons.arrow_forward, size: 22),
                    ),
                  ],
                ),
              ),
            ],
          );
          return box.maxWidth > 700
              ? Row(
                  children: [
                    Expanded(child: intro),
                    const SizedBox(width: 40),
                    const Expanded(child: AssetPhoto('hero', height: 420)),
                  ],
                )
              : Column(
                  children: [
                    intro,
                    const SizedBox(height: 30),
                    Stack(
                      children: [
                        const AssetPhoto('hero', height: 190),
                        Positioned(
                          bottom: 14,
                          left: 14,
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            child: const Text(
                              'Good people. Great possibilities. ↗',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
        },
      ),
      const SizedBox(height: 30),
      const Eyebrow('A few of the teams you could join'),
      Image.asset(
        'assets/images/partners.png',
        width: double.infinity,
        fit: BoxFit.contain,
      ),
      SectionTitle(
        'Explore by category',
        action: 'All jobs',
        onTap: () => go(context, '/jobs'),
      ),
      LayoutBuilder(
        builder: (context, box) => Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final item in [
              ('Design', Icons.palette_outlined),
              ('Development', Icons.code),
              ('Marketing', Icons.campaign_outlined),
              ('Operations', Icons.widgets_outlined),
              ('Data Science', Icons.bar_chart),
              ('Mobile Development', Icons.phone_android),
            ])
              SizedBox(
                width: (box.maxWidth - 10) / 2,
                child: OutlinedButton(
                  onPressed: () =>
                      go(context, '/jobs', arguments: {'role': item.$1}),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(14),
                  ),
                  child: Row(
                    children: [
                      Icon(item.$2, size: 18),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          item.$1,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      SectionTitle(
        'Your next great role',
        action: 'View all',
        onTap: () => go(context, '/jobs'),
      ),
      ...jobs
          .take(2)
          .map(
            (j) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: JobCard(j),
            ),
          ),
      SectionTitle(
        'Meet your future team',
        action: 'Explore',
        onTap: () => go(context, '/startups'),
      ),
      AdaptiveGrid(
        children: companies.take(3).map((c) => OrganizationCard(c)).toList(),
      ),
      const SectionTitle('Here, there, everywhere.'),
      const Text(
        'Wherever your next chapter takes you,\nthere’s a team waiting to meet you.',
        style: TextStyle(color: HoobColors.muted),
      ),
      const SizedBox(height: 18),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final city in [
            'Tokyo',
            'Stockholm',
            'London',
            'Amsterdam',
            'Copenhagen',
            'Paris',
          ])
            ActionChip(
              label: Text('$city ↗'),
              onPressed: () =>
                  go(context, '/jobs', arguments: {'location': city}),
            ),
        ],
      ),
    ],
  );
}
