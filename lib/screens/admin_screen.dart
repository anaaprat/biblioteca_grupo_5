import 'package:flutter/material.dart';
import '/services/admin_service.dart';
import '/screens/login_screen.dart';

class AdminScreen extends StatefulWidget {
  final String token;
  AdminScreen({required this.token});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final AdminService adminService = AdminService();
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    try {
      final fetchedUsers = await adminService.getUsers(widget.token);

      fetchedUsers.removeWhere((user) => user['role'] == 'ADMIN');

      setState(() {
        users = fetchedUsers;
      });
    } catch (e) {
      print('Error loading users: $e');
    }
  }

  void _logout() async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Future<bool> _toggleUserActivation(dynamic user) async {
    final confirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user['activated'] ? 'Deactivate User' : 'Activate User'),
        content: Text(
          'Are you sure you want to ${user['activated'] ? 'deactivate' : 'activate'} ${user['email']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      bool success;
      if (user['activated']) {
        success = await adminService.deactivateUser(user['id'], widget.token);
      } else {
        success = await adminService.activateUser(user['id'], widget.token);
      }

      if (success) {
        setState(() {
          user['activated'] = !user['activated'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'User ${user['activated'] ? 'activated' : 'deactivated'} successfully')),
        );
        return false;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user status')),
        );
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[700],
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      backgroundColor: Colors.brown[200],
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Dismissible(
            key: Key(user['id'].toString()),
            background: Container(
              color: user['activated'] ? Colors.red : Colors.green,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20),
              child: Icon(Icons.check, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: user['activated'] ? Colors.red : Colors.green,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.block, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await _toggleUserActivation(user);
            },
            child: Card(
              color: Colors.brown[300],
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(user['email'] ?? 'Unknown Email',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                subtitle: Text(user['activated'] ? 'Active' : 'Inactive',
                    style: TextStyle(
                        color: user['activated']
                            ? Colors.greenAccent
                            : Colors.redAccent)),
                trailing: Icon(
                    user['activated'] ? Icons.check_circle : Icons.cancel,
                    color: user['activated']
                        ? Colors.greenAccent
                        : Colors.redAccent),
              ),
            ),
          );
        },
      ),
    );
  }
}
