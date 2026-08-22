import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/portfolio_model.dart';

class PortfolioRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // دالة لجلب البيانات من فايربيس (مع الاحتياط لو القاعدة فاضية ترفع ملفك القديم تلقائياً)
  Future<PortfolioData> getPortfolioData() async {
    try {
      // جلب الوثيقة من مجموعة settings
      DocumentSnapshot snapshot = await _firestore.collection('settings').doc('portfolio_data').get();

      if (snapshot.exists && snapshot.data() != null) {
        // لو البيانات موجودة في فايربيس، نقرأها مباشرة
        final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return PortfolioData.fromJson(data);
      } else {
        // لو أول مرة ولسه قاعدة البيانات فاضية، نجلب بيانات الجيت هب ونخزنها في فايربيس
        return await _fetchDefaultAndUploadToFirebase();
      }
    } catch (e) {
      throw Exception('Error fetching data from Firebase: $e');
    }
  }

  // دالة لحفظ التعديلات الجديدة في فايربيس (عندما يقوم الأدمن بالتعديل أو الإضافة)
  Future<void> savePortfolioData(PortfolioData portfolioData) async {
    try {
      // تحويل الكائن بالكامل إلى Map مناسب للتخزين في فايربيس
      Map<String, dynamic> jsonData = {
        "profile": {
          "name": portfolioData.profile.name,
          "role": portfolioData.profile.role,
          "bio": portfolioData.profile.bio,
          "avatarUrl": portfolioData.profile.avatarUrl,
          "cvUrl": portfolioData.profile.cvUrl,
          "profileBackground": portfolioData.profile.profileBackground,
        },
        "socials": portfolioData.socials.map((s) => {
          "platform": s.platform,
          "url": s.url,
          "iconCode": s.iconCode,
        }).toList(),
        "skills": portfolioData.skills,
        "projects": portfolioData.projects.map((p) => {
          "title": p.title,
          "description": p.description,
          "imageUrl": p.imageUrl,
          "githubUrl": p.githubUrl,
          "liveUrl": p.liveUrl,
          "technologies": p.technologies,
        }).toList(),
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

  // دالة مساعدة لرفع ملف الـ Gist الافتراضي لفايربيس لأول مرة فقط
  Future<PortfolioData> _fetchDefaultAndUploadToFirebase() async {
    const String url = "https://gist.githubusercontent.com/mohamedsallam4/2694f1287917771db3f67f59fdec55df/raw/portfolio.json";
    
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // حفظه في فايربيس للأبد
      await _firestore.collection('settings').doc('portfolio_data').set(data);
      return PortfolioData.fromJson(data);
    } else {
      throw Exception('Failed to initialize default data from GitHub');
    }
  }
}