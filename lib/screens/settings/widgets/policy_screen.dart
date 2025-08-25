import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// PolicyScreen displays policy content following modern design patterns
/// - Clean header with document type, title, and last updated
/// - Structured content with clear clause sections
/// - Professional typography hierarchy
class PolicyScreen extends StatelessWidget {
  final String title;
  final String content;
  final IconData? icon;

  const PolicyScreen({
    Key? key,
    required this.title,
    required this.content,
    this.icon,
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
          title,
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
            
            // Content Section
            if (content.isNotEmpty) ...[
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
          'AGREEMENT',
          style: PalmTextStyles.label.copyWith(
            color: PalmColors.neutralLight,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
        
        const SizedBox(height: PalmSpacings.s),
        
        // Title
        Text(
          title,
          style: PalmTextStyles.heading.copyWith(
            color: PalmColors.neutralDark,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        
        const SizedBox(height: PalmSpacings.s),
        
        // Last updated
        Text(
          _getLastUpdatedText(),
          style: PalmTextStyles.body.copyWith(
            color: PalmColors.neutralLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildContentSections() {
    final sections = _parseContentIntoSections(content);
    
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
        if (section['title']?.isNotEmpty == true) ...[
          Text(
            section['title']!,
            style: PalmTextStyles.title.copyWith(
              color: PalmColors.neutralDark,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),
        ],
        
        // Section content
        Text(
          section['content'] ?? '',
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
                Icons.article_outlined,
                size: 48,
                color: PalmColors.neutralLight,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No content available',
              style: PalmTextStyles.title.copyWith(
                color: PalmColors.neutralLight,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This document is currently empty or not available.',
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

  List<Map<String, String>> _parseContentIntoSections(String content) {
    final sections = <Map<String, String>>[];
    final lines = content.split('\n').where((line) => line.trim().isNotEmpty).toList();
    
    Map<String, String>? currentSection;
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      
      // Check if this line is a section title/clause
      if (_isSectionTitle(line)) {
        // Save previous section if exists
        if (currentSection != null) {
          sections.add(currentSection);
        }
        
        // Start new section
        currentSection = {
          'title': line,
          'content': '',
        };
      } else if (currentSection != null) {
        // Add to current section content
        if (currentSection['content']!.isNotEmpty) {
          currentSection['content'] = '${currentSection['content']!}\n\n$line';
        } else {
          currentSection['content'] = line;
        }
      } else {
        // No section started yet, create a general section
        currentSection = {
          'title': '',
          'content': line,
        };
      }
    }
    
    // Add the last section
    if (currentSection != null) {
      sections.add(currentSection);
    }
    
    // If no structured sections found, create default sections
    if (sections.isEmpty) {
      // Split content into paragraphs and create clause-like sections
      final paragraphs = content.split('\n\n').where((p) => p.trim().isNotEmpty).toList();
      
      for (int i = 0; i < paragraphs.length; i++) {
        sections.add({
          'title': 'Clause ${i + 1}',
          'content': paragraphs[i].trim(),
        });
      }
    }
    
    return sections;
  }

  bool _isSectionTitle(String line) {
    // Enhanced section title detection patterns
    final patterns = [
      RegExp(r'^\d+\.\s+'), // "1. Title"
      RegExp(r'^Clause\s+\d+', caseSensitive: false), // "Clause 1"
      RegExp(r'^Section\s+\d+', caseSensitive: false), // "Section 1"
      RegExp(r'^Article\s+\d+', caseSensitive: false), // "Article 1"
      RegExp(r'^[A-Z][A-Z\s]+[A-Z]$'), // "ALL CAPS TITLE"
      RegExp(r'^[A-Z][a-z]+.*:$'), // "Title:"
      RegExp(r'^\d+\.\d+'), // "1.1 Sub-section"
    ];
    
    return patterns.any((pattern) => pattern.hasMatch(line)) || 
           line.length < 50 && line.contains(RegExp(r'^[A-Z]'));
  }

  String _getLastUpdatedText() {
    final now = DateTime.now();
    final months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    return 'Last updated on ${months[now.month]} ${now.day}, ${now.year}';
  }
} 