import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../data/app_store.dart';
import '../../data/catalog.dart';
import '../../shared/widgets.dart';

class MyJobsPage extends StatefulWidget {
  const MyJobsPage({super.key});
  @override
  State<MyJobsPage> createState() => _MyJobsPageState();
}

class _MyJobsPageState extends State<MyJobsPage> {
  bool startups = false;
  String status = 'All status';
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final list = jobs
        .where(
          (j) =>
              (store.savedJobs.contains(j.id) ||
                  store.applications.containsKey(j.id)) &&
              (status == 'All status' ||
                  (status == 'Applied'
                      ? store.applications.containsKey(j.id)
                      : store.savedJobs.contains(j.id))),
        )
        .toList();
    final organizations = [
      ...companies,
      ...investors,
    ].where((c) => store.savedCompanies.contains(c.id)).toList();
    return PageBody(
      children: [
        const Eyebrow('Your dashboard'),
        Row(
          children: [
            Expanded(
              child: Text(
                'Hello ${store.name}.',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const Text(
              '✦',
              style: TextStyle(color: HoobColors.yellow, fontSize: 42),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Your saved and applied jobs,\nand the teams you’re keeping an eye on.',
          style: TextStyle(color: HoobColors.muted),
        ),
        const SizedBox(height: 26),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(
              value: false,
              label: Text('My Jobs'),
              icon: Icon(Icons.work_outline, size: 17),
            ),
            ButtonSegment(
              value: true,
              label: Text('Startups'),
              icon: Icon(Icons.business_outlined, size: 17),
            ),
          ],
          selected: {startups},
          onSelectionChanged: (x) => setState(() => startups = x.first),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: Text(
                '${startups ? 'Bookmarked teams' : 'My Jobs'} (${startups ? organizations.length : list.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (!startups)
              DropdownButton<String>(
                value: status,
                underline: const SizedBox(),
                style: const TextStyle(
                  fontSize: 12,
                  color: HoobColors.ink,
                  fontFamily: 'RedHatDisplay',
                ),
                items: ['All status', 'Saved', 'Applied']
                    .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                    .toList(),
                onChanged: (x) => setState(() => status = x!),
              ),
          ],
        ),
        const SizedBox(height: 20),
        if (startups) ...[
          if (organizations.isEmpty)
            const EmptyState(
              'Your next team is out there.',
              'Bookmark companies and investors to find them here.',
            ),
          AdaptiveGrid(
            children: organizations
                .map(
                  (c) => OrganizationCard(c, investor: investors.contains(c)),
                )
                .toList(),
          ),
        ] else ...[
          if (list.isEmpty)
            const EmptyState(
              'A little space for big plans.',
              'Save a role or submit a demo application to get started.',
            ),
          ...list.map(
            (j) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: JobCard(j, status: true),
            ),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => go(context, startups ? '/startups' : '/jobs'),
          child: Text(
            startups ? 'Discover startups ↗' : 'Discover more jobs ↗',
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Your activity is stored only on this device.',
          style: TextStyle(fontSize: 11, color: HoobColors.muted),
        ),
      ],
    );
  }
}
