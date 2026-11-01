import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../data/app_store.dart';
import '../../data/catalog.dart';
import '../../shared/widgets.dart';

class ApplyPage extends StatefulWidget {
  final Job job;
  const ApplyPage({super.key, required this.job});
  @override
  State<ApplyPage> createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(),
      email = TextEditingController(),
      phone = TextEditingController(),
      title = TextEditingController(),
      linkedin = TextEditingController();
  String? resume, error;
  bool updates = false, saving = false;
  @override
  void dispose() {
    for (final c in [name, email, phone, title, linkedin]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> pick() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        withData: false,
      );
      if (result != null && mounted) {
        setState(() {
          if (result.files.single.size > 10 * 1024 * 1024) {
            error = 'Choose a file smaller than 10 MB.';
          } else {
            resume = result.files.single.name;
            error = null;
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => error = 'Could not open files. Please try again.');
      }
    }
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    if (resume == null) {
      setState(() => error = 'Please attach your CV or resume.');
      return;
    }
    setState(() => saving = true);
    try {
      await StoreScope.of(context)
          .apply(widget.job.id, name.text, updates: updates);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/sent', arguments: widget.job);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          saving = false;
          error = 'Could not save on this device. Please try again.';
        });
      }
    }
  }

  Widget field(
    String label,
    TextEditingController controller, {
    bool required = false,
    TextInputType? keyboard,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboard,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(labelText: '$label${required ? ' *' : ''}'),
      validator: (value) {
        final text = value?.trim() ?? '';
        if (required && text.isEmpty) {
          return 'Please enter your ${label.toLowerCase()}.';
        }
        if (keyboard == TextInputType.emailAddress &&
            text.isNotEmpty &&
            !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(text)) {
          return 'Please enter a valid email.';
        }
        if (label == 'LinkedIn' && text.isNotEmpty && !isWebUrl(text)) {
          return 'Enter a complete URL, starting with https://';
        }
        return null;
      },
    ),
  );
  bool isWebUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        ['http', 'https'].contains(uri.scheme) &&
        uri.host.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) => PageBody(
    footer: false,
    children: [
      const Eyebrow('Make your next move'),
      Text(
        'Apply for\nthis position.',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          BrandAvatar(asset: widget.job.asset, name: widget.job.company),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.job.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  widget.job.company,
                  style: const TextStyle(color: HoobColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 22),
      const Tag('LOCAL DEMO · NO EMAIL WILL BE SENT', color: HoobColors.lime),
      const SizedBox(height: 24),
      Form(
        key: form,
        child: Column(
          children: [
            field('Full name', name, required: true),
            field(
              'Email',
              email,
              required: true,
              keyboard: TextInputType.emailAddress,
            ),
            field('Phone number', phone, keyboard: TextInputType.phone),
            field('Current or previous job title', title),
            field('LinkedIn', linkedin, keyboard: TextInputType.url),
          ],
        ),
      ),
      const Text(
        'CV / Resume *',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 10),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          key: const Key('resume-picker'),
          onPressed: pick,
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(24)),
          child: Column(
            children: [
              Icon(
                resume == null ? Icons.upload_file_outlined : Icons.task_alt,
                size: 28,
              ),
              const SizedBox(height: 10),
              Text(
                resume ?? 'Tap to browse files',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text(
                'PDF, DOC or DOCX · up to 10 MB',
                style: TextStyle(fontSize: 11, color: HoobColors.muted),
              ),
            ],
          ),
        ),
      ),
      if (error != null)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            error!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      const SizedBox(height: 8),
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        value: updates,
        onChanged: (x) => setState(() => updates = x!),
        title: const Text(
          'Save my preference for similar positions',
          style: TextStyle(fontSize: 12),
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'Only your first name, job ID and application date are saved locally. Your selected file and contact details are not uploaded.',
        style: TextStyle(fontSize: 11, color: HoobColors.muted),
      ),
      const SizedBox(height: 24),
      Row(
        children: [
          TextButton(
            onPressed: () => Navigator.maybePop(context),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FilledButton(
              key: const Key('submit-application'),
              onPressed: saving ? null : submit,
              child: Text(saving ? 'Saving…' : 'Save application ↗'),
            ),
          ),
        ],
      ),
    ],
  );
}

class SentPage extends StatelessWidget {
  final Job job;
  const SentPage({super.key, required this.job});
  @override
  Widget build(BuildContext context) => PageBody(
    footer: false,
    children: [
      const SizedBox(height: 38),
      Center(
        child: Container(
          width: 110,
          height: 110,
          decoration: const BoxDecoration(
            color: HoobColors.lime,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 54),
        ),
      ),
      const SizedBox(height: 30),
      Center(
        child: Text(
          'You made\nyour next move.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      const SizedBox(height: 20),
      Center(
        child: Text(
          'Your demo application for ${job.title}\nat ${job.company} is saved on this device.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: HoobColors.muted,
            fontSize: 16,
            height: 1.7,
          ),
        ),
      ),
      const SizedBox(height: 30),
      HardPanel(
        child: Column(
          children: [
            BrandAvatar(asset: job.asset, name: job.company, size: 52),
            const SizedBox(height: 16),
            Text(
              job.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(job.company),
            const SizedBox(height: 18),
            const Tag('APPLICATION SAVED', color: HoobColors.green),
          ],
        ),
      ),
      const SizedBox(height: 28),
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/my-jobs',
            (route) => route.isFirst,
          ),
          child: const Text('View My Jobs ↗'),
        ),
      ),
      const SizedBox(height: 10),
      Center(
        child: TextButton(
          onPressed: () => go(context, '/jobs'),
          child: const Text('Keep exploring'),
        ),
      ),
      const SizedBox(height: 16),
      const Center(
        child: Text(
          'This is a UI demo. No application has been sent\nto the company.',
          textAlign: TextAlign.center,
          style: TextStyle(color: HoobColors.muted, fontSize: 11),
        ),
      ),
    ],
  );
}
