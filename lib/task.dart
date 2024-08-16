// Define a class named Task to represent a task item in the to-do list
class Task {
  // Field to store the title of the task
  String title;

  // Field to store the completion status of the task
  bool isCompleted;

  // Constructor for the Task class
  // The 'title' parameter is required, and 'isCompleted' has a default value of false
  Task({required this.title, this.isCompleted = false});
}
