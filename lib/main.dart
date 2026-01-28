import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // കോൺഫിഗറേഷൻ ഫയൽ ഇമ്പോർട്ട് ചെയ്യുന്നു

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ഫയർബേസ് കണക്ട് ചെയ്യുന്നു
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const InstitutionApp());
}

class InstitutionApp extends StatelessWidget {
  const InstitutionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Institution Manager',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const AuthGate(), // ലോഗിൻ ചെക്കിംഗ്
    );
  }
}

// ലോഗിൻ ചെയ്തിട്ടുണ്ടോ എന്ന് പരിശോധിക്കുന്നു
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const RoleBasedRedirect(); // ലോഗിൻ ആണെങ്കിൽ റോൾ നോക്കുന്നു
        }
        return const LoginPage(); // അല്ലെങ്കിൽ ലോഗിൻ പേജ്
      },
    );
  }
}

// അഡ്മിൻ ആണോ സ്റ്റാഫ് ആണോ എന്ന് നോക്കി അതാത് പേജിലേക്ക് വിടുന്നു
class RoleBasedRedirect extends StatelessWidget {
  const RoleBasedRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return const LoginPage();
    
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        if (snapshot.hasData && snapshot.data!.exists) {
          // ഡാറ്റാബേസിലെ 'role' ഫീൽഡ് നോക്കുന്നു
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          String role = data['role'] ?? 'staff'; // റോൾ ഇല്ലെങ്കിൽ ഡിഫോൾട്ട് സ്റ്റാഫ്

          if (role == 'admin' || role == 'supervisor') {
             return const AdminDashboard();
          } else {
             return const StaffDashboard();
          }
        }
        
        return const Scaffold(body: Center(child: Text("Access Denied: User data not found")));
      },
    );
  }
}

// --- 1. LOGIN PAGE ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // ലോഗിൻ സക്സസ് ആയാൽ AuthGate ഓട്ടോമാറ്റിക് ആയി പേജ് മാറ്റിക്കോളും
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Failed: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school, size: 80, color: Colors.indigo),
              const SizedBox(height: 20),
              const Text("Institution Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Email"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("LOGIN"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 2. ADMIN DASHBOARD (Supervisor) ---
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard"), actions: [
        IconButton(onPressed: () => FirebaseAuth.instance.signOut(), icon: const Icon(Icons.logout))
      ]),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        children: [
          _buildCard(Icons.attach_money, "Fees", Colors.green),
          _buildCard(Icons.people, "Staff Mgmt", Colors.blue),
          _buildCard(Icons.school, "Students", Colors.orange),
          _buildCard(Icons.settings, "Settings", Colors.grey),
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, Color color) {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// --- 3. STAFF DASHBOARD ---
class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Staff Portal"), actions: [
        IconButton(onPressed: () => FirebaseAuth.instance.signOut(), icon: const Icon(Icons.logout))
      ]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(child: ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text("Mark Attendance"))),
          Card(child: ListTile(leading: Icon(Icons.edit_note, color: Colors.blue), title: Text("Enter Marks"))),
          Card(child: ListTile(leading: Icon(Icons.list, color: Colors.orange), title: Text("View Student List"))),
        ],
      ),
    );
  }
}
