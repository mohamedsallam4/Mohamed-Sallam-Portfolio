import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/portfolio_model.dart';

class PortfolioRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _gistRawUrl =
      "https://gist.githubusercontent.com/mohamedsallam4/2694f1287917771db3f67f59fdec55df/raw";

  // دالة جلب البيانات: تقرأ من Firestore أولاً لضمان الحصول على أحدث تعديلات الأدمن
  Future<PortfolioData> getPortfolioData() async {
    // 1. محاولة جلب أحدث البيانات المحفوظة في فايربيس
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('settings').doc('portfolio_data').get();

      if (snapshot.exists && snapshot.data() != null) {
        final Map<String, dynamic> data =
            snapshot.data() as Map<String, dynamic>;
        return PortfolioData.fromJson(data);
      }
    } catch (e) {
      debugPrint("Firebase Fetch Warning: $e");
    }

    // 2. إذا كان فايربيس فارغاً أو حدث انقطاع، نعتمد على الـ Gist كقيمة ابتدائية احتياطية
    try {
      final response = await http.get(Uri.parse(_gistRawUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final portfolio = PortfolioData.fromJson(data);

        // حفظ نسخة أولية في فايربيس للبدء منها لاحقاً
        _firestore
            .collection('settings')
            .doc('portfolio_data')
            .set(data)
            .catchError((_) {});

        return portfolio;
      }
    } catch (e) {
      debugPrint("Gist Fetch Error: $e");
    }

    throw Exception('Failed to load portfolio data from Firebase and Gist.');
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

      await _firestore
          .collection('settings')
          .doc('portfolio_data')
          .set(jsonData, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error saving data to Firebase: $e');
    }
  }
}