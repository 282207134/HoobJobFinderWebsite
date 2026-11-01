import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../shared/widgets.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});
  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  String category = 'All';
  @override
  Widget build(BuildContext context) => PageBody(
    children: [
      const Eyebrow('The Hoob journal'),
      Text(
        'Ideas for\nwhat comes next.',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      const SizedBox(height: 16),
      const Text(
        'Fresh perspectives on work, teams and the startup journey.',
        style: TextStyle(color: HoobColors.muted),
      ),
      const SizedBox(height: 28),
      ArticleCard(articles.first, featured: true),
      const SectionTitle('Latest articles'),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final x in ['All', 'Hiring', 'Funding', 'Startups', 'Culture'])
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(x),
                  selected: category == x,
                  onSelected: (_) => setState(() => category = x),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 22),
      AdaptiveGrid(
        children: articles
            .where((a) => category == 'All' || a.category == category)
            .map((a) => ArticleCard(a))
            .toList(),
      ),
    ],
  );
}

class ArticleCard extends StatelessWidget {
  final Article article;
  final bool featured;
  const ArticleCard(this.article, {super.key, this.featured = false});
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    child: InkWell(
      onTap: () => go(context, '/article', arguments: article),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AssetPhoto(article.image, height: featured ? 215 : 170),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow(article.category),
                Text(
                  article.title,
                  style: featured
                      ? Theme.of(context).textTheme.titleLarge
                      : Theme.of(context).textTheme.titleMedium,
                ),
                if (featured) ...[
                  const SizedBox(height: 12),
                  Text(
                    article.intro,
                    style: const TextStyle(color: HoobColors.muted),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: HoobColors.lime,
                      child: Text(
                        article.author.substring(0, 1),
                        style: const TextStyle(
                          color: HoobColors.ink,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        article.author,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Text(
                      '8 Apr 2022',
                      style: TextStyle(fontSize: 10, color: HoobColors.muted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class ArticlePage extends StatelessWidget {
  final Article article;
  const ArticlePage({super.key, required this.article});
  @override
  Widget build(BuildContext context) => PageBody(
    children: [
      Eyebrow('${article.category} / 5 min read'),
      Text(article.title, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 18),
      Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: HoobColors.lime,
            child: Text(
              article.author[0],
              style: const TextStyle(color: HoobColors.ink),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.author,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'April 8, 2022 · From the archive',
                  style: TextStyle(fontSize: 11, color: HoobColors.muted),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Copy article title',
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: article.title));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Article title copied')),
                );
              }
            },
            icon: const Icon(Icons.ios_share, size: 20),
          ),
        ],
      ),
      const SizedBox(height: 26),
      AssetPhoto(article.image, height: 220),
      const SizedBox(height: 26),
      Text(
        article.intro,
        style: const TextStyle(
          fontSize: 19,
          height: 1.7,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SectionTitle('Start with the right questions'),
      const Text(
        'Every new chapter begins with a conversation. What are you trying to build? Who do you want to build it with? Being clear about your purpose helps you make thoughtful decisions as your team grows.',
        style: TextStyle(fontSize: 16, height: 1.85),
      ),
      const SectionTitle('Make room for different perspectives'),
      const Text(
        'The strongest teams bring together people with different experiences and ways of thinking. Listen closely, stay curious and give everyone the opportunity to contribute. Small changes to everyday habits can make a lasting difference.',
        style: TextStyle(fontSize: 16, height: 1.85),
      ),
      const SizedBox(height: 28),
      const HardPanel(
        child: Text(
          '“Build a team around shared ambition, and leave room for people to surprise you.”',
          style: TextStyle(
            fontSize: 23,
            height: 1.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      const SectionTitle('Keep learning as you grow'),
      const Text(
        'There isn’t one perfect playbook for building a startup. Start small, reflect on what is working and make improvements together. A healthy team is always a work in progress.',
        style: TextStyle(fontSize: 16, height: 1.85),
      ),
      const SizedBox(height: 24),
      const Text(
        'Editorial preview adapted for this UI demo. Original article titles and archive dates are retained from the design.',
        style: TextStyle(fontSize: 11, color: HoobColors.muted),
      ),
      const SectionTitle('Continue reading'),
      AdaptiveGrid(
        children: articles
            .where((a) => a.id != article.id)
            .take(2)
            .map((a) => ArticleCard(a))
            .toList(),
      ),
    ],
  );
}
