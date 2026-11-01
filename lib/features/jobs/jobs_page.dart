import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../shared/widgets.dart';

class JobFilter {
  String role = 'All', level = 'All', type = 'All';
  bool remote = false;
  double salary = 0;
  JobFilter copy() => JobFilter()
    ..role = role
    ..level = level
    ..type = type
    ..remote = remote
    ..salary = salary;
  int get count => [
    role != 'All',
    level != 'All',
    type != 'All',
    remote,
    salary > 0,
  ].where((x) => x).length;
  bool matches(Job j) =>
      (role == 'All' || j.role == role) &&
      (level == 'All' || j.level == level) &&
      (type == 'All' || j.type == type) &&
      (!remote || j.remote) &&
      j.salary >= salary;
}

class JobsPage extends StatefulWidget {
  final Object? initial;
  const JobsPage({super.key, this.initial});
  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final query = TextEditingController(), location = TextEditingController();
  JobFilter filter = JobFilter();
  String sort = 'Newest';
  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial is String) query.text = initial;
    if (initial is Map) {
      filter.role = initial['role'] as String? ?? 'All';
      location.text = initial['location'] as String? ?? '';
      query.text = initial['query'] as String? ?? '';
    }
  }

  @override
  void dispose() {
    query.dispose();
    location.dispose();
    super.dispose();
  }

  Future<void> showFilters() async {
    final selected = await showModalBottomSheet<JobFilter>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (context) => JobFilterSheet(filter: filter.copy()),
    );
    if (selected != null) setState(() => filter = selected);
  }

  void clear() => setState(() {
    filter = JobFilter();
    query.clear();
    location.clear();
  });
  @override
  Widget build(BuildContext context) {
    final list = jobs
        .where(
          (j) =>
              filter.matches(j) &&
              '${j.title} ${j.company} ${j.role}'.toLowerCase().contains(
                query.text.trim().toLowerCase(),
              ) &&
              j.location.toLowerCase().contains(
                location.text.trim().toLowerCase(),
              ),
        )
        .toList();
    if (sort == 'Salary: high to low') {
      list.sort((a, b) => b.salary.compareTo(a.salary));
    }
    return PageBody(
      children: [
        const Eyebrow('Find your people'),
        Text(
          'A job to get\nexcited about.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        const Text(
          'Make your next move a meaningful one.',
          style: TextStyle(color: HoobColors.muted),
        ),
        const SizedBox(height: 24),
        HardPanel(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                key: const Key('job-search'),
                controller: query,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Company, job title…',
                  prefixIcon: Icon(Icons.search, size: 20),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('job-location'),
                      controller: location,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'City or country',
                        prefixIcon: Icon(Icons.location_on_outlined, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    key: const Key('job-filters'),
                    tooltip: 'Filters',
                    onPressed: showFilters,
                    style: IconButton.styleFrom(
                      backgroundColor: HoobColors.ink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    icon: Badge(
                      isLabelVisible: filter.count > 0,
                      label: Text('${filter.count}'),
                      child: const Icon(Icons.tune),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: Text(
                'Job opportunities (${list.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            DropdownButton<String>(
              value: sort,
              underline: const SizedBox(),
              style: const TextStyle(
                fontFamily: 'RedHatDisplay',
                fontSize: 11,
                color: HoobColors.ink,
              ),
              items: [
                'Newest',
                'Salary: high to low',
              ].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
              onChanged: (x) => setState(() => sort = x!),
            ),
          ],
        ),
        if (filter.count > 0 ||
            query.text.isNotEmpty ||
            location.text.isNotEmpty)
          TextButton(
            onPressed: clear,
            child: const Text('Clear search & filters ×'),
          ),
        const SizedBox(height: 16),
        if (list.isEmpty)
          EmptyState(
            'No matching roles yet',
            'Try a different keyword, location or filter.',
            onReset: clear,
          ),
        ...list.map(
          (j) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: JobCard(j),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Curated sample opportunities · salaries in USD per year',
          style: TextStyle(color: HoobColors.muted, fontSize: 11),
        ),
      ],
    );
  }
}

class JobFilterSheet extends StatefulWidget {
  final JobFilter filter;
  const JobFilterSheet({super.key, required this.filter});
  @override
  State<JobFilterSheet> createState() => _JobFilterSheetState();
}

class _JobFilterSheetState extends State<JobFilterSheet> {
  late JobFilter f = widget.filter;
  Widget options(
    String title,
    List<String> values,
    String selected,
    ValueChanged<String> changed,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 22, bottom: 10),
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
      Wrap(
        spacing: 7,
        runSpacing: 5,
        children: ['All', ...values]
            .map(
              (x) => ChoiceChip(
                label: Text(x, style: const TextStyle(fontSize: 12)),
                selected: selected == x,
                onSelected: (_) => setState(() => changed(x)),
              ),
            )
            .toList(),
      ),
    ],
  );
  @override
  Widget build(BuildContext context) => FractionallySizedBox(
    heightFactor: .9,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 12, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Make it your kind of job',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                options(
                  'Roles',
                  jobs.map((j) => j.role).toSet().toList(),
                  f.role,
                  (x) => f.role = x,
                ),
                options(
                  'Seniority level',
                  ['Junior', 'Mid-Level', 'Senior', 'Leadership'],
                  f.level,
                  (x) => f.level = x,
                ),
                options(
                  'Job type',
                  ['Full-time', 'Contract', 'Internship', 'Part-time'],
                  f.type,
                  (x) => f.type = x,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Open to remote'),
                  value: f.remote,
                  onChanged: (x) => setState(() => f.remote = x),
                ),
                Text(
                  'Minimum salary: \$${f.salary.round()}k / year',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Slider(
                  value: f.salary,
                  min: 0,
                  max: 160,
                  divisions: 16,
                  label: '\$${f.salary.round()}k',
                  onChanged: (x) => setState(() => f.salary = x),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              TextButton(
                onPressed: () => setState(() => f = JobFilter()),
                child: const Text('Reset'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  key: const Key('apply-filters'),
                  onPressed: () => Navigator.pop(context, f),
                  child: Text(
                    'Show ${jobs.where(f.matches).length} opportunities',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
