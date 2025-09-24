import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

void main() {
  runApp(const MyApp());
}

// Main App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Multi-Screen App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}

// Login Screen
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF512DA8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 40),
                  buildTextField(emailController, 'Email', Icons.email, false),
                  const SizedBox(height: 20),
                  buildTextField(usernameController, 'Username', Icons.person, false),
                  const SizedBox(height: 20),
                  buildTextField(passwordController, 'Password', Icons.lock, true),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                // Navigate to CRUD screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CrudPage()),
                                );
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          isLoading ? 'Please wait...' : 'Login',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Or continue with',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Image.network(
                          'https://img.icons8.com/color/48/000000/google-logo.png',
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.network(
                          'https://img.icons8.com/color/48/000000/facebook-new.png',
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.network(
                          'https://img.icons8.com/ios-filled/50/000000/mac-os.png',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String label, IconData icon, bool obscure) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (label == 'Email') {
          if (value == null || value.isEmpty) return 'Please enter your email';
          if (!EmailValidator.validate(value)) return 'Enter a valid email';
        } else if (value == null || value.isEmpty) return 'Please enter $label';
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white24,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// CRUD Screen
class CrudPage extends StatefulWidget {
  const CrudPage({super.key});

  @override
  State<CrudPage> createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  final List<String> items = [];
  final TextEditingController controller = TextEditingController();

  void addItem() {
    if (controller.text.isNotEmpty) {
      setState(() {
        items.add(controller.text);
        controller.clear();
      });
    }
  }

  void editItem(int index) {
    controller.text = items[index];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Item'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                items[index] = controller.text;
                controller.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Page')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF004D40)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                          labelText: 'Item', fillColor: Colors.white24, filled: true),
                    ),
                  ),
                  IconButton(onPressed: addItem, icon: const Icon(Icons.add, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: items.isEmpty
                    ? const Center(
                        child: Text('No items yet', style: TextStyle(color: Colors.white)),
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (_, index) => ListTile(
                          title: Text(items[index], style: const TextStyle(color: Colors.white)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () => editItem(index),
                                  icon: const Icon(Icons.edit, color: Colors.white)),
                              IconButton(
                                  onPressed: () => deleteItem(index),
                                  icon: const Icon(Icons.delete, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListViewPage(items: items)),
                  );
                },
                child: const Text('Go to List View'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ListView Screen
class ListViewPage extends StatelessWidget {
  final List<String> items;
  const ListViewPage({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List View Page')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6F00), Color(0xFFE65100)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: items.isEmpty
            ? const Center(child: Text('No items to display', style: TextStyle(color: Colors.white)))
            : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: items.length,
                itemBuilder: (_, index) => ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(items[index], style: const TextStyle(color: Colors.white)),
                ),
              ),
      ),
    );
  }
}
