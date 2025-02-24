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
        title: Text(
          "About",
          style: TextStyle(color: AppColors.lightGrey),
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
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNavy,
                ),
              ),
              SizedBox(height: 16),
              _buildMemberCard(
                'Muhammad Hazrul Fahmi Bin Marhalim',
                'Project Manager',
                'hazrulsehebat@gmail.com',
                'assets/images/hazrul.png',
              ),
              _buildMemberCard(
                'Muhammad Mirza Bin Azhar',
                'Project Designer',
                'whodatijay@gmail.com',
                'assets/images/mirza.png',
              ),
              _buildMemberCard(
                'Muhammad Izzuddin Bin Othman',
                'Lead Development',
                'izzuddin6595@gmail.com',
                'assets/images/izzuddin.png',
              ),
              _buildMemberCard(
                'Muhammad Izhan Zikry Bin Hamdani',
                'UI/UX Designer',
                'izhanzikry@gmail.com',
                'assets/images/izhan.png',
              ),
              _buildMemberCard(
                'Tengku Aizad Bin Tengku Norazman',
                'Backend Developer',
                'aizaddtengkuazman@gmail.com',
                'assets/images/aizad.png',
              ),
              _buildMemberCard(
                'Muhammad Saufi Bin Muhammad Safian',
                'Backend Developer',
                'saufi2706@gmail.com',
                'assets/images/saufi.png',
              ),
              SizedBox(height: 24),
              Text(
                'Copyright Statement',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNavy,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '© 2025 Hospitalzzz. All rights reserved.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.charcoal,
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Visit our ',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.charcoal,
                    ),
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
                      'Website',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.turquoise,
                      ),
                    ),
                  ),
                  Text(
                    ' now !!!',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.charcoal,
                    ),
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
      String name, String role, String email, String imagePath) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      color: AppColors.lightGrey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(imagePath),
              backgroundColor: AppColors.charcoal.withOpacity(0.1),
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
                      color: AppColors.darkNavy,
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
                    _getStudentId(name),
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

  String _getStudentId(String name) {
    final Map<String, String> studentIds = {
      'Muhammad Hazrul Fahmi Bin Marhalim': '2022663458',
      'Muhammad Mirza Bin Azhar': '2022453238',
      'Muhammad Izzuddin Bin Othman': '2022461314',
      'Muhammad Izhan Zikry Bin Hamdani': '2022455842',
      'Tengku Aizad Bin Tengku Norazman': '2022612546',
      'Muhammad Saufi Bin Muhammad Safian': '2022835614',
    };
    return '${studentIds[name] ?? ""}';
  }
}
