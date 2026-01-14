# 🚀 Career Pilot

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white) ![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white) ![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white) ![OpenAI](https://img.shields.io/badge/OpenAI-000000?style=for-the-badge&logo=openai&logoColor=white)

**Career Pilot** is a **mobile-first AI-powered career assistant** that helps users find jobs tailored to their skills, strengths, and behaviors. Build your career smarter with AI-driven CV analysis, cover letter generation, and personalized career path suggestions.

---

## 🌟 Key Features

- 🤖 **AI Job Recommendations:** Matches jobs from multiple sources based on skills & strengths
- 📄 **CV Analyzer:** Upload your CV & get instant AI-powered analysis
- ✍️ **Cover Letter Builder:** Generate professional cover letters in seconds
- 🚀 **Career Path Suggestions:** Personalized AI-driven career growth advice
- 🔒 **Secure Auth:** Email, social login, and magic links via Supabase
- 🧩 **Scalable Clean Architecture:** Testable, maintainable, and modular

---

## 🏗 Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | Flutter, Bloc, Riverpod, go_router |
| **Networking** | Dio |
| **Backend** | Supabase (PostgreSQL, Auth, Storage, Edge Functions) |
| **AI Services** | OpenAI API |
| **Other Services** | Job Board APIs, Analytics |

---

## 🏛 Architecture

**Hybrid Clean Architecture Layers:**

1. **Bootstrap:** DI, environment, error handling
2. **Presentation:** Flutter UI, Bloc, Riverpod, go_router
3. **Domain:** Entities, Use Cases, Business Logic
4. **Data:** Repositories, Network (Dio), Storage
5. **Core & Shared:** AI helpers, network, UI components, theme
6. **External APIs:** OpenAI, job boards, analytics

---

## 📂 Folder Structure

```text
lib/
├── app/
│   ├── bootstrap/      # DI, environment, error handling
│   ├── app.dart
│   └── providers.dart
├── features/
│   ├── onboarding/
│   │   ├── presentation/
│   │   ├── domain/
│   │   └── data/
│   ├── ai_assistant/
│   │   ├── presentation/
│   │   ├── domain/
│   │   └── data/
│   └── cv_analyzer/
│       ├── presentation/
│       ├── domain/
│       └── data/
├── core/
│   ├── ai/
│   ├── network/
│   ├── routing/
│   ├── storage/
│   └── errors/
├── shared/
│   ├── ui/
│   └── theme/
├── l10n/
└── main.dart
