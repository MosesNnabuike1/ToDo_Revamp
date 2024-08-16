import 'package:flutter/material.dart';
import 'task.dart'; // Import the Task class definition
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences for data persistence

// StatefulWidget to manage the state of the to-do list screen
class TodoListScreen extends StatefulWidget {
  final String listTitle; // Title of the to-do list passed from the previous screen

  // Constructor to initialize the listTitle
  const TodoListScreen({super.key, required this.listTitle});

  @override
  _TodoListScreenState createState() => _TodoListScreenState(); // Create the state for this widget
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Task> tasks = []; // List to hold tasks for the current to-do list

  @override
  void initState() {
    super.initState();
    _loadTasksFromSharedPreferences(); // Load tasks from shared preferences when the widget is initialized
  }

  // Method to save tasks to shared preferences
  Future<void> _saveTasksToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance(); // Get the instance of SharedPreferences
    // Convert tasks to a list of strings where each string represents a task
    List<String> taskStrings = tasks.map((task) => '${task.title}|${task.isCompleted}').toList();
    await prefs.setStringList('tasks_${widget.listTitle}', taskStrings); // Save the list of task strings
  }

  // Method to load tasks from shared preferences
  Future<void> _loadTasksFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance(); // Get the instance of SharedPreferences
    List<String>? taskStrings = prefs.getStringList('tasks_${widget.listTitle}'); // Get the list of task strings
    if (taskStrings != null) { // Check if taskStrings is not null
      // Convert the list of strings back to a list of Task objects
      setState(() {
        tasks = taskStrings.map((str) {
          final parts = str.split('|'); // Split each string into parts
          return Task(title: parts[0], isCompleted: parts[1] == 'true'); // Create a Task object
        }).toList(); // Convert the list of strings to a list of Task objects
      });
    }
  }

  // Method to add a new task
  void _addTask(String taskTitle) {
    setState(() {
      tasks.add(Task(title: taskTitle)); // Add a new Task object to the list
      _saveTasksToSharedPreferences(); // Save the updated list of tasks
    });
  }

  // Method to delete a task at a specific index
  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index); // Remove the task at the specified index
      _saveTasksToSharedPreferences(); // Save the updated list of tasks
    });
  }

  // Method to edit an existing task
  void _editTask(int index) {
    TextEditingController controller = TextEditingController(text: tasks[index].title); // Initialize controller with the current task title
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C), // Dark background color for the dialog
          title: const Text('Edit Task', style: TextStyle(color: Colors.white)), // Title of the dialog
          content: TextField(
            controller: controller, // Controller to manage text input
            style: const TextStyle(color: Colors.white), // Style for the text in the text field
            decoration: const InputDecoration(
              hintText: "Enter task", // Hint text when the field is empty
              hintStyle: TextStyle(color: Colors.white54), // Style for the hint text
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54), // Color of the underline border
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white), // Color of the underline border when focused
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF6C63FF))), // 'Cancel' button
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
            ),
            TextButton(
              child: const Text('Save', style: TextStyle(color: Color(0xFF6C63FF))), // 'Save' button
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog and save changes
                setState(() {
                  tasks[index].title = controller.text; // Update the task title
                  _saveTasksToSharedPreferences(); // Save the updated list of tasks
                });
              },
            ),
          ],
        );
      },
    );
  }

  // Method to toggle the completion status of a task
  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted; // Toggle the completion status
      _saveTasksToSharedPreferences(); // Save the updated list of tasks
    });
  }

  // Method to show a dialog for adding a new task
  _showAddTaskDialog() {
    TextEditingController controller = TextEditingController(); // Controller to manage text input
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C), // Dark background color for the dialog
          title: const Text('Add New Task', style: TextStyle(color: Colors.white)), // Title of the dialog
          content: TextField(
            controller: controller, // Controller to manage text input
            style: const TextStyle(color: Colors.white), // Style for the text in the text field
            decoration: const InputDecoration(
              hintText: "Enter task", // Hint text when the field is empty
              hintStyle: TextStyle(color: Colors.white54), // Style for the hint text
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54), // Color of the underline border
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white), // Color of the underline border when focused
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))), // 'Cancel' button
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
            ),
            TextButton(
              child: const Text('Add', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))), // 'Add' button
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog and add the task
                if (controller.text.trim().isNotEmpty) { // Check if the input is not empty
                  _addTask(controller.text.trim()); // Add the task
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
    // Separate tasks into incomplete and completed
    List<Task> incompleteTasks = tasks.where((task) => !task.isCompleted).toList();
    List<Task> completedTasks = tasks.where((task) => task.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C), // Dark background color for the app bar
        title: Text(widget.listTitle), // Title of the app bar (listTitle)
      ),
      backgroundColor: const Color(0xFF1E1E2C), // Dark background color for the screen
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the content
        child: Column(
          children: <Widget>[
            // Incomplete Tasks Section
            if (incompleteTasks.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tasks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10), // Space between sections
              Expanded(
                child: ListView.builder(
                  itemCount: incompleteTasks.length, // Number of tasks to display
                  itemBuilder: (context, index) {
                    return Card(
                      color: const Color(0xFF282A3A), // Background color of the task card
                      child: ListTile(
                        title: Text(
                          incompleteTasks[index].title, // Display task title
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white), // Edit icon
                              onPressed: () => _editTask(index), // Open edit dialog
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red), // Delete icon
                              onPressed: () => _deleteTask(index), // Delete task
                            ),
                            IconButton(
                              icon: Icon(
                                incompleteTasks[index].isCompleted
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: incompleteTasks[index].isCompleted
                                    ? Colors.green
                                    : Colors.white,
                              ),
                              onPressed: () => _toggleTaskCompletion(index), // Toggle completion status
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            // Completed Tasks Section
            if (completedTasks.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Completed Tasks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10), // Space between sections
              Expanded(
                child: ListView.builder(
                  itemCount: completedTasks.length, // Number of completed tasks to display
                  itemBuilder: (context, index) {
                    return Card(
                      color: const Color(0xFF3A3B4E), // Background color of the completed task card
                      child: ListTile(
                        title: Text(
                          completedTasks[index].title, // Display completed task title
                          style: const TextStyle(
                            color: Colors.white70,
                            decoration: TextDecoration.lineThrough, // Strike-through text for completed tasks
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white), // Edit icon
                              onPressed: () => _editTask(index), // Open edit dialog
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red), // Delete icon
                              onPressed: () => _deleteTask(index), // Delete task
                            ),
                            IconButton(
                              icon: Icon(
                                completedTasks[index].isCompleted
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: completedTasks[index].isCompleted
                                    ? Colors.green
                                    : Colors.white,
                              ),
                              onPressed: () => _toggleTaskCompletion(index), // Toggle completion status
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog, // Show add task dialog when pressed
        backgroundColor: const Color(0xFF6C63FF), // Background color of the floating action button
        child: const Icon(Icons.add), // Icon for adding a new task
      ),
    );
  }
}
