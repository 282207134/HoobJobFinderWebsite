import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../data/app_store.dart';
import '../../data/catalog.dart';
import '../../shared/widgets.dart';

class DirectoryPage extends StatefulWidget {
  final bool funding;
  const DirectoryPage({super.key, this.funding = false});
  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  final query = TextEditingController(), location = TextEditingController();
  String industry = 'All', stage = 'All', kind = 'All', size = 'All';
  bool remote = false, looking = false, alphabetical = false;
  double ticket = 1000;
  @override
  void dispose() {
    query.dispose();
    location.dispose();
    super.dispose();
  }

  void reset() => setState(() {
    industry = stage = kind = size = 'All';
    remote = looking = false;
    ticket = 1000;
    query.clear();
    location.clear();
  });
  Future<void> filters() async {
    var nextIndustry = industry,
        nextStage = stage,
        nextKind = kind,
        nextSize = size;
    var nextRemote = remote, nextLooking = looking;
    var nextTicket = ticket;
    final source = widget.funding ? investors : companies;
    final apply = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (context) => StatefulBuilder(
        builder: (context, change) {
          Widget dropdown(
            String label,
            String value,
            List<String> values,
            ValueChanged<String> set,
          ) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: DropdownButtonFormField<String>(
              key: ValueKey('$label:$value'),
              initialValue: value,
              decoration: InputDecoration(labelText: label),
              isExpanded: true,
              items: [
                'All',
                ...values.toSet(),
              ].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
              onChanged: (x) => change(() => set(x!)),
            ),
          );
          return Padding(
            padding: EdgeInsets.fromLTRB(
              22,
              20,
              22,
              22 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Find your match',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  dropdown(
                    'Industry',
                    nextIndustry,
                    source.map((o) => o.industry).toList(),
                    (x) => nextIndustry = x,
                  ),
                  dropdown(
                    'Startup stage',
                    nextStage,
                    source.map((o) => o.stage).toList(),
                    (x) => nextStage = x,
                  ),
                  if (widget.funding) ...[
                    dropdown(
                      'Investor type',
                      nextKind,
                      source.map((o) => o.type).toList(),
                      (x) => nextKind = x,
                    ),
                    Text('Maximum ticket size: \$${nextTicket.round()}k'),
                    Slider(
                      value: nextTicket,
                      min: 50,
                      max: 1000,
                      divisions: 19,
                      onChanged: (x) => change(() => nextTicket = x),
                    ),
                  ] else ...[
                    dropdown(
                      'Startup size',
                      nextSize,
                      source.map((o) => o.size).toList(),
                      (x) => nextSize = x,
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Open to remote'),
                      value: nextRemote,
                      onChanged: (x) => change(() => nextRemote = x),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Looking for funding'),
                      value: nextLooking,
                      onChanged: (x) => change(() => nextLooking = x),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => change(() {
                          nextIndustry = nextStage = nextKind = nextSize =
                              'All';
                          nextRemote = nextLooking = false;
                          nextTicket = 1000;
                        }),
                        child: const Text('Reset'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Apply filters'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    if (apply == true) {
      setState(() {
        industry = nextIndustry;
        stage = nextStage;
        kind = nextKind;
        size = nextSize;
        remote = nextRemote;
        looking = nextLooking;
        ticket = nextTicket;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final funding = widget.funding;
    final list = (funding ? investors : companies)
        .where(
          (o) =>
              '${o.name} ${o.summary}'.toLowerCase().contains(
                query.text.toLowerCase().trim(),
              ) &&
              o.location.toLowerCase().contains(
                location.text.toLowerCase().trim(),
              ) &&
              (industry == 'All' || o.industry == industry) &&
              (stage == 'All' || o.stage == stage) &&
              (funding
                  ? (kind == 'All' || o.type == kind) && o.ticket <= ticket
                  : (size == 'All' || o.size == size) &&
                        (!remote || o.remote) &&
                        (!looking || o.funding)),
        )
        .toList();
    if (alphabetical) list.sort((a, b) => a.name.compareTo(b.name));
    return PageBody(
      children: [
        Eyebrow(funding ? 'Seek funding' : 'Browse startups'),
        Text(
          funding
              ? 'Connect to\nleading investors.'
              : 'Small teams.\nExtraordinary ideas.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 16),
        Text(
          funding
              ? 'A great idea deserves the right partner.\nFind the people who believe in your next chapter.'
              : 'Discover the companies building what comes next.\nFind a mission you want to be part of.',
          style: const TextStyle(color: HoobColors.muted),
        ),
        if (funding) ...[
          const SizedBox(height: 24),
          const AssetPhoto('funding', height: 190),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: filters,
            child: const Text('Find my investor ↗'),
          ),
        ],
        const SizedBox(height: 24),
        TextField(
          controller: query,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: funding ? 'Investor name or keyword' : 'Search companies',
            prefixIcon: const Icon(Icons.search, size: 20),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: location,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'City or country',
                  prefixIcon: Icon(Icons.location_on_outlined, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton(onPressed: filters, child: const Icon(Icons.tune)),
          ],
        ),
        const SizedBox(height: 26),
        Row(
          children: [
            Expanded(
              child: Text(
                '${funding ? 'Recent investors' : 'Exciting companies'} (${list.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            PopupMenuButton<bool>(
              tooltip: 'Sort results',
              onSelected: (x) => setState(() => alphabetical = x),
              itemBuilder: (_) => [
                const PopupMenuItem(value: false, child: Text('Newest')),
                const PopupMenuItem(value: true, child: Text('Name A–Z')),
              ],
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.sort_by_alpha, size: 20),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: reset,
          child: const Text('Clear search & filters'),
        ),
        const SizedBox(height: 8),
        if (list.isEmpty)
          EmptyState(
            'No matches just yet',
            'Try broadening your search.',
            onReset: reset,
          ),
        AdaptiveGrid(
          children: list
              .map((o) => OrganizationCard(o, investor: funding))
              .toList(),
        ),
        const SizedBox(height: 20),
        const Text(
          'Curated directory · sample profiles',
          style: TextStyle(fontSize: 11, color: HoobColors.muted),
        ),
      ],
    );
  }
}

class OrganizationPage extends StatelessWidget {
  final Organization organization;
  const OrganizationPage({super.key, required this.organization});
  @override
  Widget build(BuildContext context) {
    final o = organization, store = StoreScope.of(context);
    final investor = investors.any((i) => i.id == o.id);
    final related = jobs.where((j) => j.company == o.name).toList();
    return PageBody(
      children: [
        Eyebrow(investor ? 'Investor profile' : 'Meet the team'),
        HardPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BrandAvatar(asset: o.asset, name: o.name, size: 60),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Bookmark profile',
                    onPressed: () => store.toggleCompany(o.id),
                    icon: Icon(
                      store.savedCompanies.contains(o.id)
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(o.name, style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 12),
              Text(o.location, style: const TextStyle(color: HoobColors.muted)),
              const SizedBox(height: 18),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  Tag(o.industry),
                  Tag(investor ? o.type : '${o.size} people'),
                  if (o.remote && !investor)
                    const Tag('Remote friendly', color: HoobColors.lime),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        AssetPhoto(investor ? 'investor' : 'startup', height: 220),
        const SectionTitle('Big ambitions. Real impact.'),
        Text(o.summary, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        Text(
          investor
              ? 'We partner with founders at the ${o.stage.toLowerCase()} stage, sharing experience, connections and long-term support.'
              : 'We’re a curious, collaborative team that believes the best work happens when people have room to grow. Join us and help shape what comes next.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (investor) ...[
          const SectionTitle('Investment focus'),
          Tag(o.stage),
          const SizedBox(height: 16),
          Text(
            'Typical investment: \$${o.ticket}k',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => go(context, '/contact'),
            child: const Text('Start a conversation ↗'),
          ),
        ] else ...[
          const SectionTitle('Open opportunities'),
          ...related.map(
            (j) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: JobCard(j),
            ),
          ),
        ],
      ],
    );
  }
}
