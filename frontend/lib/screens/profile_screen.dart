import 'package:flutter/material.dart';

import '../data/sample_cvs.dart';
import '../models/match_result.dart';
import '../services/api_service.dart';
import 'results_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _api = ApiService();

  bool _loading = false;
  String? _errorMessage;

  void _loadSample(int index) {
    setState(() {
      _controller.text = sampleCvTexts[index];
      _errorMessage = null;
    });
  }

  Future<void> _findContracts() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _errorMessage = 'Please enter your profile text first.');
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final result = await _api.match(text);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ResultsScreen(response: result),
        ),
      );
    } on ApiException catch (e) {
      setState(() => _errorMessage = 'Server error (${e.statusCode}): ${e.message}');
    } catch (e) {
      setState(
        () => _errorMessage =
            'Could not reach the backend. Make sure it is running on localhost:8080.',
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract Matcher'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Find matching public contracts',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Paste your profile or CV in Markdown format below. '
                  'The system will extract your skills and rank available '
                  'public government contracts by relevance.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                _SampleCvDropdown(onSelected: _loadSample),
                const SizedBox(height: 12),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                    decoration: InputDecoration(
                      hintText: '# Your Profile\n\n## Skills\n- Go\n- Docker\n...',
                      border: const OutlineInputBorder(),
                      errorText: _errorMessage,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _loading ? null : _findContracts,
                  icon: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.search),
                  label: Text(_loading ? 'Searching…' : 'Find Matching Contracts'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SampleCvDropdown extends StatefulWidget {
  const _SampleCvDropdown({required this.onSelected});

  final void Function(int index) onSelected;

  @override
  State<_SampleCvDropdown> createState() => _SampleCvDropdownState();
}

class _SampleCvDropdownState extends State<_SampleCvDropdown> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Load sample:', style: TextStyle(fontSize: 13)),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButton<int>(
            value: _selectedIndex,
            isExpanded: true,
            hint: const Text('— choose a sample CV —', style: TextStyle(fontSize: 13)),
            items: List.generate(
              sampleCvLabels.length,
              (i) => DropdownMenuItem(
                value: i,
                child: Text(sampleCvLabels[i], style: const TextStyle(fontSize: 13)),
              ),
            ),
            onChanged: (index) {
              if (index == null) return;
              setState(() => _selectedIndex = index);
              widget.onSelected(index);
            },
          ),
        ),
      ],
    );
  }
}
