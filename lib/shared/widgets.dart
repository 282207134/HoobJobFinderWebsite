import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/app_store.dart';
import '../data/catalog.dart';

void go(BuildContext context, String route, {Object? arguments}) =>
    Navigator.of(context).pushNamed(route, arguments: arguments);

class PageBody extends StatelessWidget {
  final List<Widget> children;
  final bool footer;
  final ScrollController? controller;
  const PageBody({
    super.key,
    required this.children,
    this.footer = true,
    this.controller,
  });
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: const PageStorageKey('page-scroll'),
    controller: controller,
    child: Column(
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.sizeOf(context).width < 600 ? 22 : 40,
                28,
                MediaQuery.sizeOf(context).width < 600 ? 22 : 40,
                44,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ),
        if (footer) const ExploreFooter(),
      ],
    ),
  );
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onTap;
  const SectionTitle(this.title, {super.key, this.action, this.onTap});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 30, bottom: 18),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (action != null)
          TextButton(
            onPressed: onTap,
            child: Text(
              '$action ↗',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
      ],
    ),
  );
}

class Eyebrow extends StatelessWidget {
  final String text;
  const Eyebrow(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        letterSpacing: 1.8,
        fontWeight: FontWeight.w700,
        color: HoobColors.muted,
      ),
    ),
  );
}

class HardPanel extends StatelessWidget {
  final Widget child;
  final Color shadow;
  final EdgeInsets padding;
  const HardPanel({
    super.key,
    required this.child,
    this.shadow = HoobColors.lime,
    this.padding = const EdgeInsets.all(20),
  });
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(right: 5, bottom: 5),
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: HoobColors.ink),
      borderRadius: BorderRadius.circular(4),
      boxShadow: [BoxShadow(color: shadow, offset: const Offset(5, 5))],
    ),
    child: child,
  );
}

class AssetPhoto extends StatelessWidget {
  final String name;
  final double height;
  const AssetPhoto(this.name, {super.key, this.height = 210});
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/$name.png',
    width: double.infinity,
    height: height,
    fit: BoxFit.cover,
  );
}

class BrandAvatar extends StatelessWidget {
  final String? asset;
  final String name;
  final double size;
  const BrandAvatar({
    super.key,
    this.asset,
    required this.name,
    this.size = 44,
  });
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(color: HoobColors.line),
    ),
    child: asset != null
        ? Image.asset('assets/images/$asset.png')
        : Center(
            child: Text(
              name.substring(0, 1),
              style: TextStyle(
                fontSize: size * .45,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
  );
}

class Tag extends StatelessWidget {
  final String text;
  final Color color;
  const Tag(this.text, {super.key, this.color = const Color(0xFFF6F6F6)});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(3),
    ),
    child: Text(
      text,
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
    ),
  );
}

class AdaptiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double minWidth;
  const AdaptiveGrid({super.key, required this.children, this.minWidth = 280});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final columns = (box.maxWidth / minWidth).floor().clamp(1, 3);
      final width = (box.maxWidth - (columns - 1) * 16) / columns;
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: children
            .map((child) => SizedBox(width: width, child: child))
            .toList(),
      );
    },
  );
}

class JobCard extends StatelessWidget {
  final Job job;
  final bool status;
  const JobCard(this.job, {super.key, this.status = false});
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final saved = store.savedJobs.contains(job.id);
    final applied = store.applications.containsKey(job.id);
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(color: HoobColors.line),
      ),
      child: InkWell(
        onTap: () => go(context, '/job', arguments: job),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BrandAvatar(asset: job.asset, name: job.company),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.company,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          job.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    key: ValueKey('save-${job.id}'),
                    tooltip: saved ? 'Unsave job' : 'Save job',
                    onPressed: () => store.toggleJob(job.id),
                    icon: Icon(
                      saved ? Icons.bookmark : Icons.bookmark_border,
                      size: 21,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  Tag(job.type),
                  Tag(job.level),
                  if (job.remote) const Tag('Remote OK'),
                  if (job.fast) const Tag('FAST APPLY', color: HoobColors.lime),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 13,
                    color: HoobColors.muted,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      job.location,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '\$${job.salary}k / yr',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (status)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Tag(
                    applied
                        ? 'Applied · ${store.applications[job.id]!.substring(0, 10)}'
                        : 'Saved',
                    color: applied ? HoobColors.green : const Color(0xFFCFF4FB),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrganizationCard extends StatelessWidget {
  final Organization organization;
  final bool investor;
  const OrganizationCard(this.organization, {super.key, this.investor = false});
  @override
  Widget build(BuildContext context) {
    final o = organization;
    final count = jobs.where((j) => j.company == o.name).length;
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: HoobColors.line),
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        onTap: () => go(context, '/organization', arguments: o),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BrandAvatar(asset: o.asset, name: o.name),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      o.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Icon(Icons.north_east, size: 16),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                o.summary,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: HoobColors.muted, height: 1.6),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Tag(
                    investor ? o.type : '$count jobs available',
                    color: investor ? HoobColors.lime : const Color(0xFFF6F6F6),
                  ),
                  const Spacer(),
                  Text(
                    o.industry,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String title, body;
  final VoidCallback? onReset;
  const EmptyState(this.title, this.body, {super.key, this.onReset});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 44),
    child: Center(
      child: Column(
        children: [
          const Icon(Icons.manage_search, size: 44, color: HoobColors.muted),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(body, textAlign: TextAlign.center),
          if (onReset != null)
            TextButton(onPressed: onReset, child: const Text('Clear filters')),
        ],
      ),
    ),
  );
}

class ExploreFooter extends StatelessWidget {
  const ExploreFooter({super.key});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    color: HoobColors.ink,
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
    child: Column(
      children: [
        const Text(
          '✦',
          style: TextStyle(color: HoobColors.yellow, fontSize: 30),
        ),
        const SizedBox(height: 12),
        const Text(
          'Explore a\nJob Now!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            height: 1.15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Your next chapter starts here.\nFind your people. Build something great.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFC9C9C9), height: 1.6),
        ),
        const SizedBox(height: 24),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: HoobColors.ink,
          ),
          onPressed: () => go(context, '/jobs'),
          child: const Text('Explore Jobs ↗'),
        ),
        const SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 24,
          children: [
            for (final item in [
              ('About', '/company'),
              ('Journal', '/blogs'),
              ('Contact', '/contact'),
            ])
              TextButton(
                onPressed: () => go(context, item.$2),
                child: Text(
                  item.$1,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Hoob · A place for people with ambition',
          style: TextStyle(color: Colors.white54, fontSize: 10),
        ),
      ],
    ),
  );
}
