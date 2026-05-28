import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => AppData(),
    child: const MyApp(),
  ));
}

class AppData extends ChangeNotifier {
  List<Map<String, dynamic>> hackathons = [];
  List<Map<String, dynamic>> teams = [];
  Map<String, dynamic>? currentUser;

  AppData() {
    loadSampleData();
  }

  void loadSampleData() {
    currentUser = {
      'name': 'Alex Johnson',
      'email': 'alex@example.com',
      'college': 'MIT Engineering',
      'year': 3,
      'skills': ['Flutter', 'Firebase', 'UI/UX'],
      'lookingFor': 'Backend Developer',
      'portfolio': ['github.com/alex', 'linkedin.com/in/alex'],
    };

    hackathons = [
      {
        'id': '1',
        'name': 'Hack India 2024',
        'organizer': 'Tech Mahindra',
        'date': '2024-03-15',
        'mode': 'Hybrid',
        'location': 'Bangalore',
        'description': 'India\'s largest hackathon',
        'skills': ['Flutter', 'AI', 'Blockchain'],
        'prize': '₹10,00,000',
        'registered': false,
      },
      {
        'id': '2',
        'name': 'Google Solution Challenge',
        'organizer': 'Google Developers',
        'date': '2024-04-10',
        'mode': 'Online',
        'location': 'Global',
        'description': 'Solve real-world problems',
        'skills': ['Mobile', 'Web', 'Cloud'],
        'prize': '\$10,000',
        'registered': false,
      },
    ];

    teams = [
      {
        'id': '1',
        'title': 'UI/UX Designer Needed',
        'description': 'Looking for a creative UI/UX designer',
        'skills': ['Figma', 'UI Design', 'Prototyping'],
        'color': 0xFF2196F3,
      },
      {
        'id': '2',
        'title': 'Flutter Developer Wanted',
        'description': 'Need experienced Flutter developer',
        'skills': ['Flutter', 'Dart', 'Firebase'],
        'color': 0xFF4CAF50,
      },
    ];
  }

  void registerHackathon(String id) {
    final index = hackathons.indexWhere((h) => h['id'] == id);
    if (index != -1) {
      hackathons[index]['registered'] = true;
      notifyListeners();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.group_work, size: 80, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text('Team Finder', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Finder'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: TeamSearch()),
          ),
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) => const ChatScreen(),
            ),
          ),
        ],
      ),
      body: _tab == 0 ? const ExplorePage() : _tab == 1 ? const HackathonsPage() : const ProfilePage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Hackathons'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Looking for Team Members', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...appData.teams.map((team) => _buildTeamCard(
          title: team['title'] as String,
          description: team['description'] as String,
          skills: team['skills'] as List<String>,
          color: Color(team['color'] as int),
        )).toList(),
      ],
    );
  }

  Widget _buildTeamCard({required String title, required String description, required List<String> skills, required Color color}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: skills.map((s) => Chip(label: Text(s))).toList(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: color),
              child: const Text('Contact Team'),
            ),
          ],
        ),
      ),
    );
  }
}

class HackathonsPage extends StatelessWidget {
  const HackathonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Upcoming Hackathons', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...appData.hackathons.map((h) => _buildHackathonCard(
          id: h['id'] as String,
          name: h['name'] as String,
          organizer: h['organizer'] as String,
          date: h['date'] as String,
          mode: h['mode'] as String,
          location: h['location'] as String,
          prize: h['prize'] as String,
          isRegistered: h['registered'] as bool,
          appData: appData,
        )).toList(),
      ],
    );
  }

  Widget _buildHackathonCard({
    required String id,
    required String name,
    required String organizer,
    required String date,
    required String mode,
    required String location,
    required String prize,
    required bool isRegistered,
    required AppData appData,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(organizer, style: TextStyle(color: Colors.white.withOpacity(0.9))),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(mode, style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text(date),
                    const SizedBox(width: 16),
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(location)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.emoji_events, size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(prize, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: isRegistered ? null : () => appData.registerHackathon(id),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    backgroundColor: isRegistered ? Colors.grey : Colors.blue,
                  ),
                  child: Text(isRegistered ? 'Registered' : 'Register Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final user = appData.currentUser!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(radius: 60, child: Icon(Icons.person, size: 60)),
          const SizedBox(height: 16),
          Text(user['name'] as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(user['email'] as String),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('${user['college']} • Year ${user['year']}'),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: (user['skills'] as List<String>).map((s) => Chip(label: Text(s))).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Looking For', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Chip(label: Text(user['lookingFor'] as String)),
                  const SizedBox(height: 16),
                  const Text('Portfolio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...(user['portfolio'] as List<String>).map((link) => ListTile(
                    leading: const Icon(Icons.link),
                    title: Text(link),
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.chat, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Expanded(child: Text('Team Chat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: msg['isMe'] ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      msg['text'],
                      style: TextStyle(color: msg['isMe'] ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        setState(() {
                          _messages.add({'text': _controller.text, 'isMe': true});
                          _controller.clear();
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TeamSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) => [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];
  @override
  Widget buildLeading(BuildContext context) => IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));
  @override
  Widget buildResults(BuildContext context) => const Center(child: Text('No results found'));
  @override
  Widget buildSuggestions(BuildContext context) => const Center(child: Text('Search for teams, hackathons, or skills...'));
}
