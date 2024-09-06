import 'package:flutter/material.dart';
import '../routes/app_routes.dart'; // Update with your actual route imports

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Drawer tapped');
        // Add your logic here
      },
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header11',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home1'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.homeScreen);
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login1'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.loginScreen);
              },
            ),
            // Add more ListTiles for other pages
          ],
        ),
      ),
    );
  }
}
