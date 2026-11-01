import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../data/app_store.dart';
import '../../shared/widgets.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final form = GlobalKey<FormState>();
  final scroll = ScrollController();
  final first = TextEditingController(),
      last = TextEditingController(),
      email = TextEditingController(),
      message = TextEditingController();
  bool saved = false;
  bool loaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!loaded) {
      final draft = StoreScope.of(context).readDraft('contactDraft');
      first.text = draft['first'] ?? '';
      last.text = draft['last'] ?? '';
      email.text = draft['email'] ?? '';
      message.text = draft['message'] ?? '';
      loaded = true;
    }
  }

  @override
  void dispose() {
    scroll.dispose();
    for (final c in [first, last, email, message]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageBody(
    controller: scroll,
    children: [
      const Eyebrow('Contact us'),
      Text(
        'Got an idea?\nLet’s talk.',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      const SizedBox(height: 18),
      const Text(
        'Good conversations lead to great things.\nLeave us a note below.',
        style: TextStyle(color: HoobColors.muted, fontSize: 16),
      ),
      const SizedBox(height: 28),
      if (saved)
        HardPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle_outline, size: 34),
              const SizedBox(height: 16),
              Text(
                'Your note is saved.',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              const Text(
                'This demo saved your message on this device. No message has been sent.',
              ),
              TextButton(
                onPressed: () => setState(() => saved = false),
                child: const Text('Edit your note ↗'),
              ),
            ],
          ),
        )
      else
        Form(
          key: form,
          child: Column(
            children: [
              for (final item in [
                ('First name', first),
                ('Last name', last),
                ('Email', email),
                ('Tell us about your idea', message),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: TextFormField(
                    controller: item.$2,
                    maxLines: item.$2 == message ? 5 : 1,
                    keyboardType: item.$2 == email
                        ? TextInputType.emailAddress
                        : TextInputType.text,
                    decoration: InputDecoration(labelText: item.$1),
                    validator: (x) {
                      if (x == null || x.trim().isEmpty) {
                        return 'Please fill in this field.';
                      }
                      if (item.$2 == email &&
                          !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                              .hasMatch(x.trim())) {
                        return 'Enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                ),
              const Text(
                'Local demo · your note will not be sent.',
                style: TextStyle(fontSize: 11, color: HoobColors.muted),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    if (form.currentState!.validate()) {
                      final ok = await StoreScope.of(context)
                          .saveDraft('contactDraft', {
                            'first': first.text.trim(),
                            'last': last.text.trim(),
                            'email': email.text.trim(),
                            'message': message.text.trim(),
                          });
                      if (mounted && ok) {
                        setState(() => saved = true);
                        if (scroll.hasClients) {
                          scroll.jumpTo(0);
                        }
                      }
                    }
                  },
                  child: const Text('Save my note ↗'),
                ),
              ),
            ],
          ),
        ),
      const SizedBox(height: 36),
      const Divider(),
      const SizedBox(height: 20),
      const Text(
        'FOR PEOPLE. FOR POSSIBILITIES.',
        style: TextStyle(
          fontSize: 10,
          letterSpacing: 1.5,
          color: HoobColors.muted,
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'Start something good.',
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
      ),
    ],
  );
}
