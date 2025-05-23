import 'package:flutter/material.dart';
import 'package:parking_management/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              clipBehavior:
                  Clip.none, // Allows overflow of circle outside banner
              alignment: Alignment.center,
              children: [
                // Top Banner
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/cars.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Floating Circular Avatar
                Positioned(
                  bottom: -45, //Half of the circle height to overlap
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/images/user.jpg"),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
                height: 55), //  Add spacing to compensate for overlap
            const Text(
              "Binyam kebede",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Text(
              "binyam@gmail.com",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 50),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.person_outlined,
                      color: Colors.blue,
                    ),
                    title: const Text("Your profile"),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  Container(height: 1, color: Colors.blue),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.blue,
                    ),
                    title: const Text("settings"),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  Container(height: 1, color: Colors.blue),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.info,
                      color: Colors.blue,
                    ),
                    title: const Text("Help center"),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  Container(height: 1, color: Colors.blue),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.person_add,
                      color: Colors.blue,
                    ),
                    title: const Text("Invite friends"),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  Container(height: 1, color: Colors.blue),
                  ListTile(
                    onTap: () async {
                      final sp = await SharedPreferences.getInstance();
                      sp.remove("access_token");
                      sp.remove("refresh_token");
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: const Text("Sign out"),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  // Container(height: 1, color: Colors.blue)
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
