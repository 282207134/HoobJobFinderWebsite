class Job {
  final String id, title, company, asset, role, level, type, location;
  final int salary;
  final bool remote, fast;
  const Job(
    this.id,
    this.title,
    this.company,
    this.asset,
    this.role,
    this.level,
    this.type,
    this.location,
    this.salary, {
    this.remote = true,
    this.fast = false,
  });
}

const jobs = [
  Job(
    'mailchimp-fe',
    'Front-End Developer',
    'Mailchimp',
    'mailchimp',
    'Development',
    'Senior',
    'Full-time',
    'Remote · GMT−8 to GMT+6',
    120,
    fast: true,
  ),
  Job(
    'shopify-design',
    'Lead Product Designer',
    'Shopify',
    'shopify',
    'Design',
    'Leadership',
    'Contract',
    'Stockholm, Sweden',
    140,
  ),
  Job(
    'intercom-pm',
    'Project Manager',
    'Intercom',
    'intercom',
    'Operations',
    'Leadership',
    'Full-time',
    'London, UK',
    105,
  ),
  Job(
    'airbnb-social',
    'Social Media Manager',
    'Airbnb',
    'airbnb',
    'Marketing',
    'Junior',
    'Part-time',
    'Copenhagen, Denmark',
    48,
    remote: false,
  ),
  Job(
    'telegram-marketing',
    'Marketing Assistant',
    'Telegram',
    'telegram',
    'Marketing',
    'Mid-Level',
    'Internship',
    'Amsterdam, Netherlands',
    42,
    fast: true,
  ),
  Job(
    'meta-engineer',
    'Software Engineer',
    'Meta',
    'meta',
    'Development',
    'Senior',
    'Full-time',
    'Tokyo, Japan',
    155,
    remote: false,
  ),
  Job(
    'intercom-data',
    'Data Analyst',
    'Intercom',
    'intercom',
    'Data Science',
    'Junior',
    'Full-time',
    'Paris, France',
    65,
  ),
  Job(
    'shopify-mobile',
    'Mobile Developer',
    'Shopify',
    'shopify',
    'Mobile Development',
    'Mid-Level',
    'Full-time',
    'Sydney, Australia',
    110,
  ),
];

class Organization {
  final String id, name, summary, industry, location, stage, size, type;
  final String? asset;
  final bool remote, funding;
  final int ticket;
  const Organization(
    this.id,
    this.name,
    this.summary,
    this.industry,
    this.location, {
    this.asset,
    this.stage = 'Growth and expansion',
    this.size = '51–100',
    this.type = 'VC',
    this.remote = true,
    this.funding = false,
    this.ticket = 250,
  });
}

const companies = [
  Organization(
    'shopify',
    'Shopify',
    'Make commerce better for everyone. Build tools that help independent businesses grow.',
    'Consumer Goods',
    'Stockholm, Sweden',
    asset: 'shopify',
    size: '200+',
  ),
  Organization(
    'intercom',
    'Intercom',
    'Create better customer experiences through thoughtful products and meaningful conversations.',
    'SaaS',
    'London, UK',
    asset: 'intercom',
    size: '101–200',
  ),
  Organization(
    'telegram',
    'Telegram',
    'Fast, simple and secure messaging. Connect people around the world.',
    'Technology',
    'Amsterdam, Netherlands',
    asset: 'telegram',
    stage: 'Go to market',
    funding: true,
  ),
  Organization(
    'mailchimp',
    'Mailchimp',
    'An all-in-one marketing platform helping small businesses turn ambitions into success.',
    'Advertising',
    'Atlanta, USA',
    asset: 'mailchimp',
    size: '200+',
  ),
  Organization(
    'airbnb',
    'Airbnb',
    'A world where anyone can belong anywhere. Help people discover their next adventure.',
    'Travel',
    'Copenhagen, Denmark',
    asset: 'airbnb',
    remote: false,
  ),
  Organization(
    'meta',
    'Meta',
    'Build the future of human connection and bring people closer together.',
    'Technology',
    'Tokyo, Japan',
    asset: 'meta',
    size: '200+',
    remote: false,
  ),
];
const investors = [
  Organization(
    'squarespace',
    'Squarespace',
    'Backing ambitious founders who are building the next generation of creative businesses.',
    'Technology',
    'New York, USA',
    type: 'Private Funds',
    stage: 'Go to market',
    ticket: 100,
  ),
  Organization(
    'egmont',
    'Egmont Fonden',
    'Supporting the people and ideas shaping a more inclusive and creative future.',
    'Education',
    'Copenhagen, Denmark',
    type: 'Private Funds',
    stage: 'Idea',
    ticket: 50,
  ),
  Organization(
    'point-nine',
    'Point Nine Capital',
    'An early-stage venture capital firm focused on SaaS and digital marketplaces.',
    'SaaS',
    'Berlin, Germany',
    stage: 'Product or prototype',
    ticket: 500,
  ),
  Organization(
    'index',
    'The Index Project',
    'We invest in design that improves life. Great ideas deserve a chance to grow.',
    'Healthcare',
    'Copenhagen, Denmark',
    type: 'Private Funds',
    stage: 'Idea',
    ticket: 100,
  ),
  Organization(
    'lakestar',
    'Lakestar',
    'Early and growth-stage investments in the technology companies of tomorrow.',
    'Technology',
    'Zurich, Switzerland',
    ticket: 1000,
  ),
  Organization(
    'byfounders',
    'byFounders VC',
    'A community-powered early-stage venture fund investing in globally ambitious founders.',
    'Fintech',
    'Stockholm, Sweden',
    stage: 'Product or prototype',
    ticket: 250,
  ),
];

class Article {
  final String id, title, category, author, image, intro;
  const Article(
    this.id,
    this.title,
    this.category,
    this.author,
    this.image,
    this.intro,
  );
}

const articles = [
  Article(
    'hiring',
    'Hiring Without Discriminating — Do’s and Don’ts',
    'Hiring',
    'Leslie Alexander',
    'article-hiring',
    'A thoughtful hiring process starts with the way you welcome people. Here are practical ideas for building a fairer, more inclusive team.',
  ),
  Article(
    'funds',
    'Published: e-Money’s Proof of Funds Report by Ernst & Young',
    'Funding',
    'Cameron Chapman',
    'article-funds',
    'Transparency builds trust. Discover how clear reporting helps growing companies strengthen relationships with investors.',
  ),
  Article(
    'team',
    'How to build a team that grows with your startup',
    'Startups',
    'Wade Warren',
    'article-team',
    'From your first hire to your next milestone, make space for curiosity, collaboration and people who share your ambition.',
  ),
  Article(
    'culture',
    'Small teams, big ideas: a better way to work',
    'Culture',
    'Jane Cooper',
    'article-culture',
    'Great company culture is built in everyday moments. Give your team the tools and trust to do their best work.',
  ),
];
