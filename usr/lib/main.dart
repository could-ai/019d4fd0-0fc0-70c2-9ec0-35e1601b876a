import 'package:flutter/material.dart';

void main() {
  runApp(const StoryGeneratorApp());
}

class StoryGeneratorApp extends StatelessWidget {
  const StoryGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Story Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const GeneratorScreen(),
      },
    );
  }
}

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final TextEditingController _promptController = TextEditingController();
  String _generatedStory = "";
  bool _isGenerating = false;
  String _selectedGenre = "Romance";

  final List<String> _genres = [
    "Romance",
    "Fantasy",
    "Sci-Fi",
    "Mystery",
    "Drama",
    "Adventure"
  ];

  void _generateStory() async {
    if (_promptController.text.isEmpty) return;

    setState(() {
      _isGenerating = true;
      _generatedStory = "";
    });

    // Simulate network delay for AI generation
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isGenerating = false;
      _generatedStory = "This is a placeholder for the generated story based on your prompt: '${_promptController.text}'. \n\nTo implement actual AI generation, you would connect this frontend to a backend service (like Supabase Edge Functions) that interfaces with an AI API (e.g., OpenAI, Anthropic, or a custom uncensored model) that fits your content requirements.";
    });
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Story Creator'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create Your Story',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGenre,
              decoration: const InputDecoration(
                labelText: 'Select Genre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _genres.map((String genre) {
                return DropdownMenuItem<String>(
                  value: genre,
                  child: Text(genre),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGenre = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _promptController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Story Prompt',
                hintText: 'Describe the characters, setting, and plot...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isGenerating ? null : _generateStory,
              icon: _isGenerating 
                  ? const SizedBox(
                      width: 20, 
                      height: 20, 
                      child: CircularProgressIndicator(strokeWidth: 2)
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(_isGenerating ? 'Generating...' : 'Generate Story'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Generated Output:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _generatedStory.isEmpty
                        ? 'Your story will appear here...'
                        : _generatedStory,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
