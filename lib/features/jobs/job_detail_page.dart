import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../data/app_store.dart';
import '../../data/catalog.dart';
import '../../shared/widgets.dart';

class JobDetailPage extends StatelessWidget {
  final Job job;
  const JobDetailPage({super.key, required this.job});
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final applied = store.applications.containsKey(job.id);
    return Column(
      children: [
        Expanded(
          child: PageBody(
            footer: false,
            children: [
              const Eyebrow('Your next chapter'),
              HardPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        BrandAvatar(
                          asset: job.asset,
                          name: job.company,
                          size: 52,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'JOB BY',
                                style: TextStyle(
                                  fontSize: 9,
                                  letterSpacing: 1.5,
                                  color: HoobColors.muted,
                                ),
                              ),
                              Text(
                                job.company,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          key: const Key('detail-save'),
                          tooltip: store.savedJobs.contains(job.id)
                              ? 'Unsave job'
                              : 'Save job',
                          onPressed: () => store.toggleJob(job.id),
                          icon: Icon(
                            store.savedJobs.contains(job.id)
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      job.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 6,
                      runSpacing: 8,
                      children: [
                        Tag(job.type),
                        Tag(job.level),
                        if (job.remote)
                          const Tag('Remote OK', color: HoobColors.lime),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      job.location,
                      style: const TextStyle(color: HoobColors.muted),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${job.salary}k – \$${job.salary + 25}k / year',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SectionTitle('Overview'),
              Text(
                '${job.company} is on a mission to help ambitious people do their best work. Join a collaborative team building thoughtful products for customers around the world.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SectionTitle('The role'),
              Text(
                'As our ${job.title}, you’ll own meaningful challenges from idea to delivery. Work closely with product, design and engineering to turn complex problems into simple, useful experiences.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SectionTitle('What you’ll do'),
              for (final text in [
                'Own projects from the first conversation to a successful launch.',
                'Collaborate openly and share ideas across disciplines.',
                'Bring customer insights into everyday decisions.',
                'Help build a welcoming, inclusive and ambitious team.',
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '↗  ',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Expanded(child: Text(text)),
                    ],
                  ),
                ),
              const SectionTitle('What you’ll bring'),
              const Text(
                'Curiosity, clear communication and hands-on experience in your field. A portfolio or examples of work you’re proud of. Most of all, the ambition to keep learning.',
              ),
              const SizedBox(height: 26),
              const HardPanel(
                shadow: HoobColors.green,
                child: Text(
                  'Everyone belongs here. Different backgrounds, experiences and perspectives make better teams. We welcome you as you are.',
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => go(
                  context,
                  '/organization',
                  arguments: companies.firstWhere((c) => c.name == job.company),
                ),
                child: Text('More about ${job.company} ↗'),
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: HoobColors.line)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        applied
                            ? 'Application saved'
                            : 'Like the sound of this?',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      const Text(
                        'Local demo application',
                        style: TextStyle(fontSize: 10, color: HoobColors.muted),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  key: const Key('apply-job'),
                  onPressed: () =>
                      go(context, applied ? '/sent' : '/apply', arguments: job),
                  child: Text(applied ? 'View application' : 'Apply Job ↗'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
