import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_frontend/utils/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
            SizedBox(width: 8),
            Text(
              "About",
              style: TextStyle(color: AppColors.lightGrey),
            ),
          ],
        ),
        backgroundColor: AppColors.darkNavy,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.lightGrey),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Team Members',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildMemberCard(
                'Muhammad Hazrul Fahmi Bin Marhalim',
                'Project Manager',
                'hazrulsehebat@gmail.com',
                '2022663458',
                'assets/images/hazrul.png',
              ),
              _buildMemberCard(
                'Muhammad Mirza Bin Azhar',
                'Project Designer',
                'whodatijay@gmail.com',
                '2022453238',
                'assets/images/mirza.png',
              ),
              _buildMemberCard(
                'Muhammad Izzuddin Bin Othman',
                'Lead Development',
                'izzuddin6595@gmail.com',
                '2022461314',
                'assets/images/izzuddin.png',
              ),
              _buildMemberCard(
                'Muhammad Izhan Zikry Bin Hamdani',
                'UI/UX Designer',
                'izhanzikry@gmail.com',
                '2022455842',
                'assets/images/izhan.png',
              ),
              _buildMemberCard(
                'Tengku Aizad Bin Tengku Norazman',
                'Backend Developer',
                'aizaddtengkuazman@gmail.com',
                '2022612546',
                'assets/images/aizad.png',
              ),
              _buildMemberCard(
                'Muhammad Saufi Bin Muhammad Safian',
                'Backend Developer',
                'saufi2706@gmail.com',
                '2022835614',
                'assets/images/saufi.png',
              ),
              SizedBox(height: 24),
              Text(
                'Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                'Hospitalzzz is a mobile application designed to help users locate and track nearby hospitals and healthcare facilities. With real-time location tracking and an intuitive interface, users can easily find medical assistance when needed.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 24),
              Text(
                'Copyright Statement',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                '© 2025 Hospitalzzz. All rights reserved.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                'Website',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Visit our ',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () async {
                      final Uri url = Uri.parse(
                          'https://github.com/goodbyeO0/flutter-group-project');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    child: Text(
                      'GitHub Repository',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.turquoise,
                      ),
                    ),
                  ),
                  Text(
                    ' for more information.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberCard(
    String name,
    String role,
    String email,
    String studentId,
    String imagePath,
  ) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(imagePath),
              backgroundColor: Colors.grey[200],
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.turquoise,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.charcoal,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Student ID: $studentId',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.charcoal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
