import 'package:flutter/material.dart'; // Import the Flutter material design package for UI components
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package to stoore data locally
import 'todo_list_screen.dart'; // Import the TodoListScreen to navigate to it

// Define the WelcomeScreen widget which is Stateful
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key}); // Constructor for WelcomeScreen with optional key parameter

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState(); // Create the state for this widget
}

// Define the state for WelcomeScreen
class _WelcomeScreenState extends State<WelcomeScreen> {
  List<String> _todoLists = []; // List to store the names of todo lists

  @override
  void initState() {
    super.initState();
    _loadTodoLists(); // Load todo lists from shared preferences when the widget initializes
  }

  // Function to load todo lists from shared preferences
  Future<void> _loadTodoLists() async {
    final prefs = await SharedPreferences.getInstance(); // Get the instance of SharedPreferences
    setState(() {
      _todoLists = prefs.getStringList('todoLists') ?? []; // Load the list from SharedPreferences or initialize to an empty list
    });
  }

  // Function to save todo lists to shared preferences
  Future<void> _saveTodoLists() async {
    final prefs = await SharedPreferences.getInstance(); // Get the instance of SharedPreferences
    prefs.setStringList('todoLists', _todoLists); // Save the list to SharedPreferences
  }

  // Function to add a new todo list
  void _addTodoList(String listTitle) {
    setState(() {
      _todoLists.add(listTitle); // Add the new list title to the _todoLists
    });
    _saveTodoLists(); // Save the updated list to SharedPreferences
    _navigateToTodoListScreen(listTitle); // Navigate to the TodoListScreen with the new list title
  }

  // Function to navigate to the TodoListScreen
  void _navigateToTodoListScreen(String listTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoListScreen(listTitle: listTitle), // Pass the listTitle to TodoListScreen
      ),
    );
  }

  // Function to delete a todo list
  void _deleteTodoList(int index) {
    setState(() {
      _todoLists.removeAt(index); // Remove the list at the specified index
    });
    _saveTodoLists(); // Save the updated list to SharedPreferences
  }

  // Function to show a dialog to create a new todo list
  void _showAddListDialog() {
    String newListTitle = ''; // Variable to hold the new list title
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New List', style: TextStyle(color: Colors.white)), // Dialog title
          backgroundColor: const Color(0xFF2D2D44), // Background color of the dialog
          content: TextField(
            autofocus: true, // Focus on the text field when the dialog appears
            decoration: const InputDecoration(
              hintText: 'Enter list title', // Hint text in the text field
              hintStyle: TextStyle(color: Colors.white70), // Style of the hint text
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6C63FF)), // Border color of the text field
              ),
            ),
            style: const TextStyle(color: Colors.white), // Text color in the text field
            onChanged: (value) {
              newListTitle = value; // Update newListTitle with the text field value
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))), // Cancel button
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
            ),
            TextButton(
              child: const Text('Create', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))), // Create button
              onPressed: () {
                if (newListTitle.isNotEmpty) { // Check if the list title is not empty
                  Navigator.of(context).pop(); // Close the dialog
                  _addTodoList(newListTitle); // Add the new list
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the content
        child: Column(
          children: <Widget>[
            const Spacer(), // Spacer widget to push the content down
            Center(
              child: Column(
                children: [
                  const Text(
                    'ToDo App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0), // Space between the text and button
                  TextButton.icon(
                    onPressed: _showAddListDialog, // Show the dialog when pressed
                    icon: const Icon(Icons.add, color: Colors.white), // Icon for the button
                    label: const Text('Add New List'), // Text for the button
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Padding inside the button
                      textStyle: const TextStyle(fontSize: 18), // Text style of the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners of the button
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(), // Spacer widget to center the list section
            _todoLists.isEmpty
                ? const Center(
                    child: Text(
                      'No ToDo on the list yet',
                      style: TextStyle(color: Colors.white70, fontSize: 18.0), // Style of the empty list message
                    ),
                  )
                : Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'List of ToDos:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0), // Space between the title and the list
                        Expanded(
                          child: ListView.builder(
                            itemCount: _todoLists.length, // Number of items in the list
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8.0), // Margin around each card
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0), // Rounded corners of the card
                                ),
                                color: const Color(0xFF2D2D44), // Background color of the card
                                child: ListTile(
                                  title: Text(
                                    _todoLists[index], // Display the list title
                                    style: const TextStyle(color: Colors.white), // Text color of the list title
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red), // Delete icon
                                    onPressed: () => _deleteTodoList(index), // Delete the list on press
                                  ),
                                  onTap: () {
                                    _navigateToTodoListScreen(_todoLists[index]); // Navigate to the TodoListScreen
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
            const Spacer(), // Spacer widget to push the content up
          ],
        ),
      ),
    );
  }
}
