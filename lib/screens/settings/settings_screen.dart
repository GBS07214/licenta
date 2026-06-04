import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/theme_service.dart';
import '../../services/firebase_service.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(title: const Text('Setări')),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSectionHeader('Aspect'),
          SwitchListTile(
            title: const Text('Temă'),
            subtitle: Text(themeService.isPinkTheme ? 'Roz pentru fete 💗' : 'Albastru pentru băieți 💙'),
            value: themeService.isPinkTheme,
            onChanged: (_) => themeService.toggleTheme(),
            secondary: Icon(
              themeService.isPinkTheme ? Icons.girl : Icons.boy,
              color: themeService.isPinkTheme ? Colors.pink : Colors.blue,
            ),
          ),
          const Divider(),
          _buildSectionHeader('Cont'),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Email'),
            subtitle: Text(firebaseService.currentUser?.email ?? 'Niciun utilizator'),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Deconectare', style: TextStyle(color: Colors.red)),
            onTap: () => _showLogoutDialog(context, firebaseService),
          ),
          const Divider(),
          _buildSectionHeader('Informații'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Despre aplicație'),
            onTap: () => _showAboutDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Ajutor'),
            onTap: () => _showHelpDialog(context),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'BabyTracker v1.0.0\n© 2026 Toate drepturile rezervate',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, FirebaseService firebaseService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deconectare'),
        content: const Text('Sigur vrei să te deconectezi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Anulează'),
          ),
          TextButton(
            onPressed: () async {
              await firebaseService.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Deconectează-te', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Despre BabyTracker'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🍼 BabyTracker v1.0.0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 12),
              Text('Aplicație mobilă pentru tracking activități bebeluș cu integrare AI.'),
              SizedBox(height: 12),
              Text('Funcționalități:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Tracking somn, alăptare, scutece'),
              Text('• Chat AI cu asistent virtual Gemini'),
              Text('• Statistici și grafice interactive'),
              Text('• Sincronizare cloud cu Firebase'),
              Text('• Teme personalizabile (albastru/roz)'),
              SizedBox(height: 12),
              Text('Dezvoltat cu ❤️ folosind Flutter & Firebase'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Închide'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajutor'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cum folosești aplicația?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 12),
              Text('📊 Dashboard:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Apasă pe butoanele de activități pentru tracking rapid.'),
              SizedBox(height: 12),
              Text('😴 Somn:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Pornește cronometrul când bebelușul adoarme. Oprește-l când se trezește.'),
              SizedBox(height: 12),
              Text('🍼 Alăptare:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Selectează sânul și pornește cronometrul.'),
              SizedBox(height: 12),
              Text('💩 Scutec:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Selectează tipul și salvează instant.'),
              SizedBox(height: 12),
              Text('💬 Chat AI:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Pune întrebări despre îngrijirea bebelușului. Asistentul AI oferă sfaturi în română.'),
              SizedBox(height: 12),
              Text('📈 Statistici:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Vezi grafice cu activitățile din ultimele 7/14/30 zile.'),
              SizedBox(height: 12),
              Text('⚙️ Setări:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Schimbă tema între albastru și roz. Deconectează-te din cont.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Am înțeles'),
          ),
        ],
      ),
    );
  }
}
