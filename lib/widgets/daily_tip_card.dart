import 'package:flutter/material.dart';

class DailyTipCard extends StatelessWidget {
  const DailyTipCard({super.key});

  static const List<String> _tips = [
    '🌟 Ești un părinte minunat! Fiecare zi cu bebelușul tău este specială.',
    '💙 Nu uita să ai grijă și de tine! Un părinte odihnit este un părinte fericit.',
    '🌸 Bebelușii cresc atât de repede - savurează fiecare moment!',
    '✨ Este OK să ceri ajutor. Nimeni nu face totul perfect.',
    '🌈 Fiecare bebeluș se dezvoltă în ritmul lui. Nu te compara cu alții.',
    '💖 Dragostea ta este cel mai important lucru pentru bebelușul tău.',
    '🎈 Zâmbetul bebelușului tău face ca totul să merite.',
    '🌺 Ai răbdare cu tine însuți. Învățați împreună.',
    '☀️ Fiecare zi este o nouă aventură cu bebelușul tău.',
    '🦋 Modul tău de a fi părinte este perfect pentru bebelușul tău.',
    '🌻 Sărbătorește fiecare realizare mică - toate contează!',
    '💫 Instinctele tale de părinte sunt mai puternice decât crezi.',
    '🌙 Nopțile grele vor trece. Totul este temporar.',
    '🎀 Bebelușul tău te iubește necondiționat.',
    '🌟 Ești exact părintele de care bebelușul tău are nevoie.',
    '💝 Rutina ta de îngrijire este o formă de iubire.',
    '🦄 Magia se întâmplă în momentele simple.',
    '🌈 Fiecare provocare te face mai puternic ca părinte.',
    '✨ Timpul petrecut împreună este cel mai prețios cadou.',
    '💖 Ești suficient. Faci suficient. Ești un părinte grozav!',
  ];

  String _getTodayTip() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return _tips[dayOfYear % _tips.length];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.7),
              Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_emotions, color: Colors.white.withOpacity(0.9), size: 28),
                const SizedBox(width: 8),
                const Text('Sfatul zilei', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 12),
            Text(_getTodayTip(), style: const TextStyle(fontSize: 16, color: Colors.white, height: 1.4)),
          ],
        ),
      ),
    );
  }
}
