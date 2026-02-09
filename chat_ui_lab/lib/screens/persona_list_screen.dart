import 'package:flutter/material.dart';
import 'persona_edit_screen.dart';
import '../models/persona_model.dart';
import '../services/persona_service.dart';

class PersonaListScreen extends StatefulWidget {
  const PersonaListScreen({super.key});

  @override
  _PersonaListScreenState createState() => _PersonaListScreenState();
}

class _PersonaListScreenState extends State<PersonaListScreen> {
  final PersonaService _personaService = PersonaService();
  List<Persona> _personas = [];

  @override
  void initState() {
    super.initState();
    _loadPersonas();
  }

  /// Naglo-load ng mga persona mula sa persistent storage (e.g., SharedPreferences).
  Future<void> _loadPersonas() async {
    final personas = await _personaService.loadPersonas();
    setState(() {
      _personas = personas;
    });
  }

  /// Nagse-save ng isang persona.
  /// Kung may kaparehong ID, ia-update ito. Kung wala, idadagdag ito bilang bago.
  void _savePersona(Persona persona) {
    final index = _personas.indexWhere((p) => p.id == persona.id);
    setState(() {
      if (index != -1) {
        _personas[index] = persona; // Ina-update ang kasalukuyang persona
      } else {
        _personas.add(persona); // Nagdaragdag ng bagong persona
      }
    });
    // Sine-save ang buong listahan sa storage.
    _personaService.savePersonas(_personas);
  }

  /// Binubura ang isang persona batay sa kanyang ID.
  void _deletePersona(String id) {
    setState(() {
      _personas.removeWhere((p) => p.id == id);
    });
    // Sine-save ang na-update na listahan sa storage.
    _personaService.savePersonas(_personas);
  }

  /// Nagna-navigate papunta sa PersonaEditScreen para mag-edit o gumawa ng bagong persona.
  void _navigateAndEditPersona({Persona? persona}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PersonaEditScreen(
          persona: persona,
          onSave: _savePersona,
        ),
      ),
    );
    // Pagkatapos bumalik mula sa edit screen, i-reload ang listahan para masigurong updated ito.
    _loadPersonas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Persona'),
      ),
      body: ListView.builder(
        // Ang bilang ng item ay ang bilang ng persona + 1 para sa "Add" button.
        itemCount: _personas.length + 1,
        itemBuilder: (context, index) {
          // Kung ang index ay ang huling item, ipapakita ang "Add New Persona" button.
          if (index == _personas.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add New Persona'),
                onPressed: () => _navigateAndEditPersona(), // Bubuksan nito ang edit screen.
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          // Kung hindi, ipapakita ang persona tile.
          final persona = _personas[index];
          return ListTile(
            title: Text(persona.name),
            subtitle: Text(persona.prompt, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () {
              // Dadalhin ka sa edit screen kapag na-tap ang isang persona.
              _navigateAndEditPersona(persona: persona);
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deletePersona(persona.id),
            ),
          );
        },
      ),
    );
  }
}
