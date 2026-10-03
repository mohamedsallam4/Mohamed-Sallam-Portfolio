import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/portfolio_model.dart';

class PortfolioRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _gistRawUrl =
      "https://gist.githubusercontent.com/mohamedsallam4/2694f1287917771db3f67f59fdec55df/raw";

  // دالة لجلب البيانات: تبدأ بجلب ملف الـ Gist مباشرة لضمان عدم توقف الموقع
  Future<PortfolioData> getPortfolioData() async {
    try {
      final response = await http.get(Uri.parse(_gistRawUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return PortfolioData.fromJson(data);
      }
    } catch (_) {
      // في حالة انقطاع الاتصال بالجيست، نحاول القراءة من فايربيس كاحتياطي
    }

    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('settings').doc('portfolio_data').get();

      if (snapshot.exists && snapshot.data() != null) {
        final Map<String, dynamic> data =
            snapshot.data() as Map<String, dynamic>;
        return PortfolioData.fromJson(data);
      }
    } catch (e) {
      throw Exception('Failed to load portfolio data from both Gist and Firebase: $e');
    }

    throw Exception('No portfolio data available.');
  }

  // حفظ التعديلات في فايربيس للأدمن
  Future<void> savePortfolioData(PortfolioData portfolioData) async {
    try {
      Map<String, dynamic> jsonData = {
        "profile": {
          "name": portfolioData.profile.name,
          "role": portfolioData.profile.role,
          "bio": portfolioData.profile.bio,
          "avatarUrl": portfolioData.profile.avatarUrl,
          "cvUrl": portfolioData.profile.cvUrl,
          "profileBackground": portfolioData.profile.profileBackground,
        },
        "socials": portfolioData.socials
            .map((s) => {
                  "platform": s.platform,
                  "url": s.url,
                  "iconCode": s.iconCode,
                })
            .toList(),
        "skills": portfolioData.skills,
        "projects": portfolioData.projects
            .map((p) => {
                  "title": p.title,
                  "description": p.description,
                  "imageUrl": p.imageUrl,
                  "githubUrl": p.githubUrl,
                  "liveUrl": p.liveUrl,
                  "technologies": p.technologies,
                })
            .toList(),
        "contact": {
          "email": portfolioData.contact.email,
          "phone": portfolioData.contact.phone,
          "location": portfolioData.contact.location,
        }
      };

      await _firestore.collection('settings').doc('portfolio_data').set(jsonData);
    } catch (e) {
      throw Exception('Error saving data to Firebase: $e');
    }
  }
}