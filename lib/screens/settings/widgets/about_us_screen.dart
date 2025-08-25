import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/models/settings/settings_model.dart';

/// AboutUsScreen displays company information in a professional layout
/// - Shows company vision, mission, and who we are
/// - Consistent with app's design patterns
/// - Clean, grouped content design
class AboutUsScreen extends StatelessWidget {
  final AboutUs aboutInfo;

  const AboutUsScreen({
    Key? key,
    required this.aboutInfo,
  }) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalmColors.white,
      appBar: AppBar(
        backgroundColor: PalmColors.backGroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'About Us',
          style: PalmTextStyles.title.copyWith(
            fontWeight: FontWeight.bold,
            color: PalmColors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: PalmColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(PalmSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(),
            
            const SizedBox(height: PalmSpacings.l),
            
            // Company Information Sections
            if (_hasContent()) ...[
              ..._buildContentSections(),
            ] else ...[
              _buildEmptyState(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [    
        // Document type
        Text(
          'COMPANY',
          style: PalmTextStyles.label.copyWith(
            color: PalmColors.neutralLight,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
        
        const SizedBox(height: PalmSpacings.s),
        
        // Title
        Text(
          'About Us',
          style: PalmTextStyles.heading.copyWith(
            color: PalmColors.neutralDark,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        
        const SizedBox(height: PalmSpacings.s),
        
        // Description
        Text(
          'Learn more about our company, mission, and vision.',
          style: PalmTextStyles.body.copyWith(
            color: PalmColors.neutralLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  bool _hasContent() {
    return aboutInfo.whoWeAre.isNotEmpty || 
           aboutInfo.ourMission.isNotEmpty || 
           aboutInfo.ourVision.isNotEmpty;
  }

  List<Widget> _buildContentSections() {
    final sections = <Map<String, String>>[];
    
    // Build list of available sections
    if (aboutInfo.whoWeAre.isNotEmpty) {
      sections.add({
        'title': 'Who We Are',
        'content': aboutInfo.whoWeAre,
      });
    }
    
    if (aboutInfo.ourMission.isNotEmpty) {
      sections.add({
        'title': 'Our Mission',
        'content': aboutInfo.ourMission,
      });
    }
    
    if (aboutInfo.ourVision.isNotEmpty) {
      sections.add({
        'title': 'Our Vision',
        'content': aboutInfo.ourVision,
      });
    }

    return sections.asMap().entries.map((entry) {
      final index = entry.key;
      final section = entry.value;
      
      return Padding(
        padding: EdgeInsets.only(
          bottom: index < sections.length - 1 ? 30 : 0,
        ),
        child: _buildSection(section),
      );
    }).toList();
  }

  Widget _buildSection(Map<String, String> section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          section['title']!,
          style: PalmTextStyles.title.copyWith(
            color: PalmColors.neutralDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 12),
        
        // Section content
        Text(
          section['content']!,
          style: PalmTextStyles.body.copyWith(
            color: PalmColors.neutralDark,
            height: 1.5,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: PalmColors.backgroundAccent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.business_outlined,
                size: 48,
                color: PalmColors.neutralLight,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No information available',
              style: PalmTextStyles.title.copyWith(
                color: PalmColors.neutralLight,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Company information is currently not available.',
              textAlign: TextAlign.center,
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.neutralLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 