import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'data/app_store.dart';
import 'data/catalog.dart';
import 'features/account/application_pages.dart';
import 'features/account/contact_page.dart';
import 'features/account/my_jobs_page.dart';
import 'features/explore/directory_page.dart';
import 'features/explore/marketing_pages.dart';
import 'features/home/home_page.dart';
import 'features/jobs/job_detail_page.dart';
import 'features/jobs/jobs_page.dart';
import 'features/journal/journal_pages.dart';
import 'shared/app_frame.dart';

class HoobApp extends StatelessWidget {
  final AppStore store;
  final GlobalKey<NavigatorState>? navigatorKey;
  const HoobApp({super.key, required this.store, this.navigatorKey});
  @override
  Widget build(BuildContext context) => StoreScope(
    store: store,
    child: MaterialApp(
      title: 'Hoob — Find your next chapter',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: buildTheme(),
      onGenerateRoute: (settings) {
        final route = settings.name ?? '/';
        final arg = settings.arguments;
        final page = switch (route) {
          '/' => const HomePage(),
          '/jobs' => JobsPage(initial: arg),
          '/job' => JobDetailPage(job: arg is Job ? arg : jobs.first),
          '/startups' => const DirectoryPage(),
          '/funding' => const DirectoryPage(funding: true),
          '/for-investor' => const MarketingPage(investor: true),
          '/for-startups' => const MarketingPage(),
          '/company' => const CompanyPage(),
          '/organization' => OrganizationPage(
            organization: arg is Organization ? arg : companies.first,
          ),
          '/blogs' => const JournalPage(),
          '/article' => ArticlePage(
            article: arg is Article ? arg : articles[1],
          ),
          '/contact' => const ContactPage(),
          '/apply' => ApplyPage(job: arg is Job ? arg : jobs.first),
          '/sent' => SentPage(job: arg is Job ? arg : jobs.first),
          '/my-jobs' => const MyJobsPage(),
          _ => const HomePage(),
        };
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => AppFrame(route: route, child: page),
        );
      },
    ),
  );
}
