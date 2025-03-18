import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'title': 'Price Drop Alert!',
      'message': 'The price of Rice at Market A has dropped from GHS 50 to GHS 45!',
      'time': '2h ago'
    },
    {
      'title': 'New Listing!',
      'message': 'Yam is now available at Market B for GHS 30.',
      'time': '5h ago'
    },
    {
      'title': 'Price Update!',
      'message': 'Tomatoes at Market C increased from GHS 10 to GHS 12.',
      'time': '1d ago'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(notification['title']!,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(notification['message']!),
              trailing: Text(notification['time']!,
                  style: TextStyle(color: Colors.grey)),
              leading: Icon(Icons.notifications, color: Colors.purple),
            ),
          );
        },
      ),
    );
  }
}
