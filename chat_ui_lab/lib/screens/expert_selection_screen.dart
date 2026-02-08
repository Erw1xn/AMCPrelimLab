import 'package:flutter/material.dart';
import 'chat_screen.dart';

// The Expert model remains the same.
class Expert {
  final String name;
  final String description;
  final IconData icon;
  final String emoji;
  final String systemPrompt;  const Expert({
    required this.name,
    required this.description,
    required this.icon,
    required this.emoji,
    required this.systemPrompt,
  });
}

// The initial list of experts remains the same.
List<Expert> initialExperts = [
  Expert(
    name: 'Plant Expert',
    description: 'Care, identification, and health',
    icon: Icons.eco,
    emoji: '🪴',
    systemPrompt: '''You are a friendly and encouraging Plant Expert.
* Your role is to specialize in house plants. This includes plant identification, care tips, and diagnosing plant health issues.
* Your tone should be patient and supportive.
* Be concise (2-4 sentences) and use plant-related emojis.
* If a question is completely unrelated to plants, politely state: "I can only help with questions about plants. Let's keep our focus on our leafy friends! 🪴"''',
  ),
  Expert(
    name: 'Fragrance Expert',
    description: 'Perfumes, colognes, and scents',
    icon: Icons.air,
    emoji: '👃',
    systemPrompt: '''You are an elegant and sophisticated Fragrance Expert.
* Your role is to specialize in the world of scents. This includes perfumes, colognes, scent notes, fragrance families, and providing recommendations.
* Your tone should be descriptive and knowledgeable.
* Be concise (2-4 sentences) and use relevant emojis.
* If a question is completely unrelated to fragrances, politely state: "I can only discuss the world of fragrances. 👃"''',
  ),
  Expert(
    name: 'Gym Expert',
    description: 'Workouts, fitness, and nutrition',
    icon: Icons.fitness_center,
    emoji: '💪',
    systemPrompt: '''You are a motivating and energetic Gym Expert.
* Your role is to specialize in fitness and exercise. This includes workout routines, exercise techniques, fitness equipment, and general nutrition for fitness.
* Your tone should be direct and encouraging.
* Be concise (2-4 sentences) and use empowering emojis.
* If a question is completely unrelated to fitness, politely state: "I'm here to help you crush your fitness goals! Let's talk workouts. 💪"''',
  ),
  Expert(
    name: 'Game Expert',
    description: 'Video games, hardware, and strategy',
    icon: Icons.gamepad,
    emoji: '🎮',
    systemPrompt: '''You are an enthusiastic and knowledgeable Game Expert.
* Your role is to specialize in video games. This includes gaming hardware (consoles, PCs), game genres, and gameplay strategies.
* Your tone should be helpful and passionate.
* Be concise (2-4 sentences) and use gaming-related emojis.
* If a question is completely unrelated to video games, politely state: "My expertise is in the world of gaming. Ask me anything about video games! 🎮"''',
  ),
  Expert(
    name: 'Coffee Expert',
    description: 'Beans, brewing, and equipment',
    icon: Icons.coffee,
    emoji: '☕',
    systemPrompt: '''You are a warm and artisanal Coffee Expert.
* Your role is to specialize in all things coffee. This includes coffee bean types, brewing methods, espresso drinks, and coffee-making equipment.
* Your tone should be detailed and welcoming.
* Be concise (2-4 sentences) and use coffee-related emojis.
* If a question is completely unrelated to coffee, politely state: "Let's talk about all things coffee. What's on your mind? ☕"''',
  ),
];

class ExpertSelectionScreen extends StatefulWidget {
  // ✨ 1. Add a field to accept the theme toggling function.
  final VoidCallback toggleTheme;

  const ExpertSelectionScreen({
    super.key,
    required this.toggleTheme, // ✨ 2. Make it a required parameter in the constructor.
  });

  @override
  State<ExpertSelectionScreen> createState() => _ExpertSelectionScreenState();
}

class _ExpertSelectionScreenState extends State<ExpertSelectionScreen> {
  final List<Expert> _experts = List.from(initialExperts);

  void _addNewExpert() async {
    final newExpert = await showDialog<Expert>(
      context: context,
      builder: (BuildContext context) {
        return const _AddExpertDialog();
      },
    );

    if (newExpert != null) {
      setState(() {
        _experts.add(newExpert);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${newExpert.name}" has been added!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✨ Use the Card's theme color, which will adapt to light/dark mode.
    final cardColor = Theme.of(context).cardColor;
    // ✨ Use the theme's primary text color.
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    // ✨ Use a secondary text color from the theme.
    final secondaryTextColor = Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose an Expert'),
        // ⛔ Removed hardcoded backgroundColor to allow the theme to control it.
        actions: [
          // ✨ 3. Add the theme toggle button.
          IconButton(
            icon: Icon(
              // ✨ 4. The icon changes based on the current brightness (light/dark).
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: 'Toggle Theme',
            onPressed: widget.toggleTheme, // ✨ 5. Call the function passed from MyApp.
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create New Persona',
            onPressed: _addNewExpert,
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.9,
        ),
        itemCount: _experts.length,
        itemBuilder: (context, index) {
          final expert = _experts[index];
          return Card(
            elevation: 4.0,
            // ⛔ Removed hardcoded color, it now uses the theme's cardColor.
            // color: Colors.blueGrey[700],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatScreen(expert: expert),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ✨ Using the theme's secondary text color for the icon.
                    Icon(expert.icon, size: 48, color: secondaryTextColor),
                    const SizedBox(height: 12),
                    Text(
                      expert.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          // ✨ Using the theme's primary text color.
                          color: textColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      expert.description,
                      // ✨ Using the theme's secondary text color.
                      style: TextStyle(color: secondaryTextColor, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// The _AddExpertDialog widget remains the same as it uses standard
// AlertDialog and TextFormField widgets that adapt to the theme automatically.
class _AddExpertDialog extends StatefulWidget {
  const _AddExpertDialog();

  @override
  State<_AddExpertDialog> createState() => _AddExpertDialogState();
}

class _AddExpertDialogState extends State<_AddExpertDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _systemPromptController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _systemPromptController.dispose();
    super.dispose();
  }

  void _createExpert() {
    if (_formKey.currentState!.validate()) {
      final newExpert = Expert(
        name: _nameController.text,
        description: _descriptionController.text,
        systemPrompt: _systemPromptController.text,
        icon: Icons.add_reaction,
        emoji: '✨',
      );
      Navigator.of(context).pop(newExpert);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Persona'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Persona Name',
                  hintText: 'e.g., History Buff',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g., An expert in world history',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _systemPromptController,
                decoration: const InputDecoration(
                  labelText: 'System Prompt',
                  hintText: 'e.g., You are a helpful history expert...',
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a system prompt';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: _createExpert,
          child: const Text('Create'),
        ),
      ],
    );
  }
}
