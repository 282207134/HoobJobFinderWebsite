import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../data/app_store.dart';
import '../../shared/widgets.dart';

class MarketingPage extends StatelessWidget {
  final bool investor;
  const MarketingPage({super.key, this.investor = false});
  @override
  Widget build(BuildContext context) => PageBody(
    children: [
      Eyebrow(investor ? 'For investors' : 'For startups'),
      Text(
        investor
            ? 'Let the brightest\nstartups find you.'
            : 'Showcase your startup.\nAttract the right talent.',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      const SizedBox(height: 18),
      Text(
        investor
            ? 'Get profiled to 8,000+ Nordic startups and scaleups. Show off your key assets, previous investments and focus areas.'
            : 'Join 8,000+ Nordic startups. Find great people, discover investors and grow your next big idea.',
        style: const TextStyle(
          fontSize: 16,
          color: HoobColors.muted,
          height: 1.65,
        ),
      ),
      const SizedBox(height: 24),
      FilledButton(
        onPressed: () => showProfileForm(context, investor: investor),
        child: Text(
          investor ? 'Create investor profile ↗' : 'Create your profile ↗',
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        'Free to explore · no credit card required',
        style: TextStyle(fontSize: 11, color: HoobColors.muted),
      ),
      const SizedBox(height: 26),
      AssetPhoto(investor ? 'investor' : 'startup', height: 220),
      const SizedBox(height: 30),
      Image.asset('assets/images/partners.png'),
      const SectionTitle('As easy as 1, 2, 3…'),
      for (final item in [
        (
          investor ? 'Create investor profile' : 'Create startup profile',
          'Tell your story and show what makes you different.',
        ),
        (
          investor ? 'Browse startups' : 'Find your next teammate',
          'Discover a community of people who share your ambition.',
        ),
        (
          investor ? 'Meet your next investment' : 'Hire the perfect match',
          'Make connections that move your business forward.',
        ),
      ].indexed)
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                color: item.$1 == 1 ? HoobColors.yellow : HoobColors.lime,
                child: Text(
                  '0${item.$1 + 1}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.$2.$1,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.$2.$2,
                      style: const TextStyle(color: HoobColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      const SectionTitle('What you get'),
      AdaptiveGrid(
        children: [
          for (final benefit in [
            (
              'Maximise exposure',
              'Be visible to the people who can help your business grow.',
              Icons.person_outline,
              HoobColors.lime,
            ),
            (
              'Free matchmaking',
              'Connect based on industry, stage, location and shared goals.',
              Icons.bolt_outlined,
              HoobColors.yellow,
            ),
            (
              'Free referrals',
              'Let your trusted community make the introduction.',
              Icons.notifications_none,
              const Color(0xFFFA7456),
            ),
            (
              'Startup browsing',
              'Discover ambitious companies and bookmark your favourites.',
              Icons.business_outlined,
              const Color(0xFF64C67E),
            ),
          ])
            HardPanel(
              shadow: benefit.$4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(benefit.$3),
                  const SizedBox(height: 18),
                  Text(
                    benefit.$1,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    benefit.$2,
                    style: const TextStyle(color: HoobColors.muted),
                  ),
                ],
              ),
            ),
        ],
      ),
      const SizedBox(height: 26),
      FilledButton(
        onPressed: () => go(context, '/startups'),
        child: const Text('Browse Startups ↗'),
      ),
      if (!investor) const CommunitySection(),
      const SectionTitle('A few good questions.'),
      const FaqSection(),
    ],
  );
}

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});
  @override
  Widget build(BuildContext context) => HardPanel(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        for (final item in [
          (
            'How come all of this is for free?',
            'Our goal is to make it easier for startups, applicants and investors to find each other. Browsing and creating a demo profile are free.',
          ),
          (
            'Is Hoob open to all?',
            'Yes. Anyone interested in startup careers and the startup community is welcome to explore.',
          ),
          (
            'How does matchmaking work?',
            'Use industry, stage, location and investment filters to find teams that match your interests.',
          ),
          (
            'How can I scout startups?',
            'Browse startup profiles, explore open positions and bookmark the teams you want to follow.',
          ),
        ])
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(bottom: 18),
            shape: const Border(bottom: BorderSide(color: HoobColors.line)),
            title: Text(
              item.$1,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            children: [
              Text(item.$2, style: const TextStyle(color: HoobColors.muted)),
            ],
          ),
      ],
    ),
  );
}

class CommunitySection extends StatelessWidget {
  const CommunitySection({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle('From the community'),
      const HardPanel(
        shadow: HoobColors.ink,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '“The first place we go to reach the Copenhagen tech and startup community.”',
              style: TextStyle(
                fontSize: 19,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: HoobColors.lime,
                  child: Text(
                    'CW',
                    style: TextStyle(fontSize: 12, color: HoobColors.ink),
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cameron Williamson',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Product Designer · community story',
                      style: TextStyle(fontSize: 10, color: HoobColors.muted),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

class CompanyPage extends StatelessWidget {
  const CompanyPage({super.key});
  @override
  Widget build(BuildContext context) => PageBody(
    children: [
      const Eyebrow('About Hoob'),
      Text(
        'A place for people\nwith ambition.',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      const SizedBox(height: 18),
      const Text(
        'A free community platform tailored to the needs of growing startups.',
        style: TextStyle(fontSize: 18, height: 1.6, color: HoobColors.muted),
      ),
      const SizedBox(height: 26),
      const AssetPhoto('startup', height: 220),
      const SectionTitle('The job is just the beginning.'),
      const Text(
        'Hoob brings the startup community together. We help growing companies find talented people and connect founders with investors who believe in their ideas.',
        style: TextStyle(fontSize: 16, height: 1.8),
      ),
      const SectionTitle('Who is our audience?'),
      AdaptiveGrid(
        children: [
          for (final group in [
            (
              'Startups',
              'Build your team and find the support you need to scale.',
              '/for-startups',
            ),
            (
              'Job seekers',
              'Discover a role where your work can make a difference.',
              '/jobs',
            ),
            (
              'Investors',
              'Meet the next generation of ambitious founders.',
              '/for-investor',
            ),
          ])
            HardPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(group.$1, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Text(group.$2),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => go(context, group.$3),
                    child: const Text('Explore ↗'),
                  ),
                ],
              ),
            ),
        ],
      ),
      const CommunitySection(),
      const SectionTitle('Our partners'),
      const Text('Great things happen when we work together.'),
      const SizedBox(height: 24),
      Image.asset('assets/images/partners.png'),
      const SizedBox(height: 28),
      FilledButton(
        onPressed: () => go(context, '/contact'),
        child: const Text('Let’s partner ↗'),
      ),
    ],
  );
}

Future<void> showProfileForm(BuildContext context, {required bool investor}) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (_) => _ProfileForm(investor: investor),
    );

class _ProfileForm extends StatefulWidget {
  final bool investor;
  const _ProfileForm({required this.investor});
  @override
  State<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<_ProfileForm> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(), focus = TextEditingController();
  bool loaded = false, saved = false;
  String get draftKey => widget.investor ? 'investorDraft' : 'startupDraft';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!loaded) {
      final draft = StoreScope.of(context).readDraft(draftKey);
      name.text = draft['name'] ?? '';
      focus.text = draft['focus'] ?? '';
      loaded = true;
    }
  }

  @override
  void dispose() {
    name.dispose();
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      22,
      24,
      22,
      MediaQuery.viewInsetsOf(context).bottom + 28,
    ),
    child: SingleChildScrollView(
      child: saved
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.task_alt, size: 46),
                const SizedBox(height: 18),
                Text(
                  name.text,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(focus.text),
                const SizedBox(height: 18),
                const Text(
                  'Your profile draft is saved on this device. It has not been published.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ],
            )
          : Form(
              key: form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.investor
                        ? 'Your investor profile'
                        : 'Your startup profile',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Create a local draft to start exploring.',
                    style: TextStyle(color: HoobColors.muted),
                  ),
                  const SizedBox(height: 22),
                  TextFormField(
                    controller: name,
                    decoration: const InputDecoration(
                      labelText: 'Organization name',
                    ),
                    validator: requiredValue,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: focus,
                    decoration: InputDecoration(
                      labelText: widget.investor
                          ? 'Investment focus'
                          : 'What are you building?',
                    ),
                    validator: requiredValue,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        if (form.currentState!.validate()) {
                          final ok = await StoreScope.of(context)
                              .saveDraft(draftKey, {
                                'name': name.text.trim(),
                                'focus': focus.text.trim(),
                              });
                          if (mounted && ok) {
                            setState(() => saved = true);
                          }
                        }
                      },
                      child: const Text('Save local profile ↗'),
                    ),
                  ),
                ],
              ),
            ),
    ),
  );
  String? requiredValue(String? value) => value == null || value.trim().isEmpty
      ? 'Please fill in this field.'
      : null;
}
