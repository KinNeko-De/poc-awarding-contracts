import 'package:flutter/material.dart';

import '../models/match_result.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.response});

  final MatchResponse response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matching Contracts'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ExtractedSkillsBanner(skills: response.profile.extractedSkills),
          Expanded(
            child: response.matches.isEmpty
                ? const _EmptyState()
                : _MatchList(matches: response.matches),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Extracted skills banner
// ---------------------------------------------------------------------------

class _ExtractedSkillsBanner extends StatelessWidget {
  const _ExtractedSkillsBanner({required this.skills});

  final List<String> skills;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detected skills (${skills.length})',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          skills.isEmpty
              ? Text(
                  'No known skills found in your profile.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                )
              : Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: skills
                      .map(
                        (s) => Chip(
                          label: Text(s, style: const TextStyle(fontSize: 12)),
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// No-match state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.black26),
            SizedBox(height: 16),
            Text(
              'No matching contracts found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'None of the available contracts require skills from your profile.\n'
              'Try updating your profile with more technical skills.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Responsive match list
// ---------------------------------------------------------------------------

class _MatchList extends StatelessWidget {
  const _MatchList({required this.matches});

  final List<MatchResult> matches;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useGrid = constraints.maxWidth >= 600;
        if (useGrid) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: matches.length,
            itemBuilder: (_, i) => _ContractCard(result: matches[i], rank: i + 1),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: matches.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => _ContractCard(result: matches[i], rank: i + 1),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Contract card
// ---------------------------------------------------------------------------

class _ContractCard extends StatelessWidget {
  const _ContractCard({required this.result, required this.rank});

  final MatchResult result;
  final int rank;

  Color _scoreColor(double score) {
    if (score >= 75) return Colors.green.shade700;
    if (score >= 40) return Colors.orange.shade700;
    return Colors.red.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final contract = result.contract;
    final score = result.score;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    '$rank',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    contract.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Score bar
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: score / 100,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      color: _scoreColor(score),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${score.toStringAsFixed(0)} %',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _scoreColor(score),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Authority & location
            _IconRow(icon: Icons.account_balance, text: contract.authority),
            const SizedBox(height: 4),
            Row(
              children: [
                _IconRow(icon: Icons.location_on, text: contract.location),
                const SizedBox(width: 12),
                if (contract.remotePossible)
                  const _Badge(label: 'Remote', color: Colors.teal),
              ],
            ),
            const SizedBox(height: 4),
            _IconRow(icon: Icons.calendar_today, text: 'Deadline: ${contract.deadline}'),
            const SizedBox(height: 4),
            Row(
              children: [
                _IconRow(icon: Icons.euro, text: contract.estimatedValue),
                const SizedBox(width: 12),
                _IconRow(icon: Icons.timer, text: contract.duration),
              ],
            ),
            const SizedBox(height: 10),

            // Matching skills
            const Text(
              'Matching skills:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: result.matchingSkills
                  .map(
                    (s) => Chip(
                      label: Text(s, style: const TextStyle(fontSize: 11)),
                      backgroundColor: Colors.green.shade50,
                      side: BorderSide(color: Colors.green.shade200),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconRow extends StatelessWidget {
  const _IconRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.black45),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
