import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// Main entry point of the UNO Chat application
/// 
/// Initializes Firebase and runs the main application widget
void main() async {
  // Ensure Flutter binding is initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific configuration
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Start the application
  runApp(const MyApp());
}

/// Root application widget
/// 
/// Configures the overall app theme and initial route
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UNO Chat', // Application title
      theme: ThemeData(
        // Use Material 3 design with a deep purple seed color
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Set the home page with a title
      home: const MyHomePage(title: 'CSCI Chat'),
    );
  }
}

/// Home page of the chat application
/// 
/// Provides a stateful widget for the main chat interface
class MyHomePage extends StatefulWidget {
  /// Constructor requires a title for the page
  const MyHomePage({super.key, required this.title});

  /// Title displayed in the app bar
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// State management for the home page
/// 
/// Handles message input, sending, and real-time message display
class _MyHomePageState extends State<MyHomePage> {
  /// Controller for the message input text field
  final TextEditingController _messageController = TextEditingController();

  /// Reference to the Firestore messages collection
  final CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');

  /// Sends a message to Firestore
  /// 
  /// Validates message content before adding to the database
  void _sendMessage() {
    // Trim whitespace and check for non-empty message
    final String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      // Add message to Firestore with metadata
      _messagesCollection.add({
        'name': 'Nolan Sherman', // TODO: Replace this with dynamic user authentication
        'message_body': message,
        'date': Timestamp.now(), // Server timestamp
      });

      // Clear the input field after sending
      _messageController.clear();
    }
  }

  /// Builds an individual message widget
  /// 
  /// [message] A map containing message details
  /// Returns a formatted message item with sender, content, and timestamp
  Widget _buildMessageItem(Map<String, dynamic> message) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display sender name
          Text(
            message['name'] ?? 'Anonymous',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),

          // Display message content
          Text(
            message['message_body'] ?? '',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),

          // Display formatted timestamp
          Text(
            // Convert Firestore timestamp to local datetime string
            (message['date'] as Timestamp)
                .toDate()
                .toLocal()
                .toString(),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const Divider(), // Visual separator between messages
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with blue background
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title),
      ),
      
      // Main body with messages and input area
      body: Column(
        children: [
          // Expandable message list with real-time updates
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // Listen to messages collection, ordered by date
              stream: _messagesCollection
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                // Show loading indicator while fetching messages
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Show message when no messages exist
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                // Display messages in a reverse-scrolling list
                return ListView(
                  reverse: true,
                  children: snapshot.data!.docs.map((doc) {
                    return _buildMessageItem(
                        doc.data() as Map<String, dynamic>);
                  }).toList(),
                );
              },
            ),
          ),

          // Message input area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                // Expandable text input field
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Send message button
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
