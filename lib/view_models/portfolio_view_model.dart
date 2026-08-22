import 'package:flutter/material.dart';
import 'package:mohamed_sallam_portfolio/data/repository/portfolio_repository.dart';
import '../data/models/portfolio_model.dart';

// تعريف حالات التحميل (Loading Status)
enum LoadingStatus { initial, loading, loaded, error }

class PortfolioViewModel extends ChangeNotifier {
  // 1. المستودع المسؤول عن جلب وحفظ البيانات (سحابياً)
  final PortfolioRepository _repository = PortfolioRepository();

  // 2. المتغيرات الخاصة بالبيانات (Private)
  PortfolioData? _portfolioData;
  PortfolioData? get portfolioData => _portfolioData;

  // 3. حالة التحميل
  LoadingStatus _status = LoadingStatus.initial;
  LoadingStatus get status => _status;

  // 4. رسالة الخطأ
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // 5. متغير الوضع الليلي والنهاري
  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  // دالة لجلب البيانات من فايربيس عند بدء التطبيق
  Future<void> fetchPortfolioData() async {
    _status = LoadingStatus.loading;
    notifyListeners();

    try {
      _portfolioData = await _repository.getPortfolioData();
      _status = LoadingStatus.loaded;
    } catch (e) {
      _status = LoadingStatus.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }

  // دالة لتبديل الثيم
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // 🚀 6. دوال التحكم الكامل للأدمن (مع الحفظ السحابي الفوري في Firebase)

  // تحديث البروفايل وحفظه سحابياً
  Future<void> updateProfile({required String name, required String role, required String bio, required String avatarUrl, required String cvUrl}) async {
    if (_portfolioData != null) {
      final oldProfile = _portfolioData!.profile;

      final newProfile = Profile(
        name: name.isNotEmpty ? name : oldProfile.name,
        role: role.isNotEmpty ? role : oldProfile.role,
        bio: bio.isNotEmpty ? bio : oldProfile.bio,
        avatarUrl: avatarUrl.isNotEmpty ? avatarUrl : oldProfile.avatarUrl,
        cvUrl: cvUrl.isNotEmpty ? cvUrl : oldProfile.cvUrl,
        profileBackground: oldProfile.profileBackground,
      );

      _portfolioData = PortfolioData(
        profile: newProfile,
        socials: _portfolioData!.socials,
        skills: _portfolioData!.skills,
        projects: _portfolioData!.projects,
        contact: _portfolioData!.contact,
      );
      
      notifyListeners();
      
      try {
        await _repository.savePortfolioData(_portfolioData!);
      } catch (e) {
        _errorMessage = e.toString();
        notifyListeners();
      }
    }
  }

  // إضافة مهارة وحفظها سحابياً
  Future<void> addSkill(String skill) async {
    if (_portfolioData != null) {
      _portfolioData!.skills.add(skill);
      notifyListeners();
      try {
        await _repository.savePortfolioData(_portfolioData!);
      } catch (e) {
        _errorMessage = e.toString();
        notifyListeners();
      }
    }
  }

  // حذف مهارة وحفظ التغيير سحابياً
  Future<void> removeSkill(String skill) async {
    if (_portfolioData != null) {
      _portfolioData!.skills.remove(skill);
      notifyListeners();
      try {
        await _repository.savePortfolioData(_portfolioData!);
      } catch (e) {
        _errorMessage = e.toString();
        notifyListeners();
      }
    }
  }

  // إضافة مشروع جديد وحفظه سحابياً
  Future<void> addProject(dynamic newProject) async {
    if (_portfolioData != null) {
      _portfolioData!.projects.add(newProject);
      notifyListeners();
      try {
        await _repository.savePortfolioData(_portfolioData!);
      } catch (e) {
        _errorMessage = e.toString();
        notifyListeners();
      }
    }
  }

  // 🔄 تعديل مشروع موجود وحفظ التغيير سحابياً في فايربيس
  Future<void> updateProject(int index, dynamic updatedProject) async {
    if (_portfolioData != null && _portfolioData!.projects.length > index) {
      _portfolioData!.projects[index] = updatedProject;
      notifyListeners();
      try {
        await _repository.savePortfolioData(_portfolioData!); // 👈 الحفظ السحابي للتعديل
      } catch (e) {
        _errorMessage = e.toString();
        notifyListeners();
      }
    }
  }

  // حذف مشروع وحفظ التغيير سحابياً
  Future<void> removeProject(int index) async {
    if (_portfolioData != null && _portfolioData!.projects.length > index) {
      _portfolioData!.projects.removeAt(index);
      notifyListeners();
      try {
        await _repository.savePortfolioData(_portfolioData!);
      } catch (e) {
        _errorMessage = e.toString();
        notifyListeners();
      }
    }
  }
}