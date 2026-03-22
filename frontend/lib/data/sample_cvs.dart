// Sample CV texts for demonstration purposes.
// CV 1 — targets contract-008 (Go Microservices Platform)
// CV 2 — targets contract-006 (Mobile App Citizen Services)
// CV 3 — no matching skills (office assistant background)

const String sampleCv1 = '''
# Freelancer Profile — Senior Backend Engineer

## About Me
I am a software engineer with 8 years of professional experience, specialised in
building distributed systems and cloud-native backends.

## Skills
- **Programming languages:** Go (Golang), Python, Bash
- **Frameworks & tools:** gRPC, REST API, Microservices architecture
- **Infrastructure:** Docker, Kubernetes, Linux, CI/CD pipelines
- **Databases:** PostgreSQL, Redis

## Work Experience
### Senior Software Engineer — FinTechCo GmbH (2019–2025)
- Designed and implemented a Go-based microservices backend serving 2 M users.
- Migrated monolith to Kubernetes-orchestrated services, reducing deployment time by 60 %.
- Defined gRPC contracts for cross-team service communication.

### Software Developer — LogiSoft AG (2017–2019)
- Built REST API services in Go for logistics tracking.
- Maintained Linux server infrastructure and CI/CD pipelines.

## Education
B.Sc. Computer Science, TU Berlin, 2017
''';

const String sampleCv2 = '''
# Freelancer Profile — Mobile Developer

## About Me
Cross-platform mobile developer with 5 years of experience delivering polished
iOS and Android applications using Flutter and Dart.

## Skills
- **Mobile:** Flutter, Dart, iOS, Android
- **Integration:** REST API, JSON, OAuth2
- **Methods:** Scrum, Agile, Test-Driven Development

## Work Experience
### Mobile Developer — AppWerkstatt GmbH (2020–2025)
- Delivered 3 Flutter applications for public-sector clients (iOS & Android).
- Integrated apps with REST API backends; handled authentication and offline caching.
- Worked in cross-functional Scrum teams with two-week sprints.

### Junior Developer — StartupHub Berlin (2018–2020)
- Built initial Flutter prototype that attracted seed funding.
- Established Agile ceremonies and sprint reviews.

## Education
B.Sc. Media Informatics, HTW Berlin, 2018
''';

const String sampleCv3 = '''
# Profile — Office Administrator

## About Me
Experienced office administrator with 10 years in public administration.
Strong focus on document management, correspondence, and team coordination.

## Skills
- Microsoft Word, Excel, Outlook
- Document archiving and filing systems
- Telephone and reception support
- Scheduling and calendar management
- General office administration

## Work Experience
### Office Manager — Stadtverwaltung Musterstadt (2015–2025)
- Coordinated daily office operations for a 20-person department.
- Managed incoming and outgoing correspondence.
- Organised meetings and maintained department filing.

### Administrative Assistant — Bezirksamt (2013–2015)
- Handled citizen enquiries and document processing.

## Education
Kauffrau für Büromanagement, Berufsschule Musterstadt, 2013
''';

/// Human-readable labels shown in the sample CV dropdown.
const List<String> sampleCvLabels = [
  'CV 1 — Go Backend Engineer (strong match)',
  'CV 2 — Flutter Mobile Developer (different match)',
  'CV 3 — Office Administrator (no match)',
];

const List<String> sampleCvTexts = [sampleCv1, sampleCv2, sampleCv3];
