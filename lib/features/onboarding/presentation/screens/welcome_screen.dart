import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

/// Welcome screen - introduces the app
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Hero section
              Column(
                children: [
                  // App icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.work_outline,
                      size: 56,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Welcome to\n${AppConstants.appName}',
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Subtitle
                  Text(
                    'Your intelligent career companion powered by AI. '
                        'Discover opportunities that match your unique skills and aspirations.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const Spacer(),

              // Features preview
              _FeatureItem(
                icon: Icons.psychology,
                title: 'AI-Powered Insights',
                description: 'Get personalized career guidance',
              ),
              const SizedBox(height: 16),
              _FeatureItem(
                icon: Icons.description,
                title: 'Smart CV Analysis',
                description: 'Optimize your resume for success',
              ),
              const SizedBox(height: 16),
              _FeatureItem(
                icon: Icons.trending_up,
                title: 'Career Pathways',
                description: 'Visualize your growth opportunities',
              ),

              const Spacer(),

              // Action buttons
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to register/onboarding
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Get Started - Coming soon!')),
                  );
                },
                child: const Text('Get Started'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  // TODO: Navigate to login
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sign In - Coming soon!')),
                  );
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Feature item widget
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}