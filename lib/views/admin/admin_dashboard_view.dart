import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 👈 لاستعراض الرسائل من فايربيس
import '../../view_models/portfolio_view_model.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/portfolio_model.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _bioController;
  late TextEditingController _cvController;
  late TextEditingController _avatarController;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final viewModel = context.read<PortfolioViewModel>();
    final profile = viewModel.portfolioData?.profile;

    _nameController = TextEditingController(text: profile?.name ?? '');
    _roleController = TextEditingController(text: profile?.role ?? '');
    _bioController = TextEditingController(text: profile?.bio ?? '');
    _cvController = TextEditingController(text: profile?.cvUrl ?? '');
    _avatarController = TextEditingController(text: profile?.avatarUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _bioController.dispose();
    _cvController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  // نافذة إضافة مهارة جديدة
  void _showAddSkillDialog(PortfolioViewModel viewModel) {
    final TextEditingController skillController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondaryBackground,
        title: const Text("Add New Skill", style: TextStyle(color: AppColors.textPrimary)),
        content: TextField(
          controller: skillController,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            labelText: "Skill Name (e.g., Flutter, Firebase)",
            labelStyle: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentColor),
            onPressed: () {
              if (skillController.text.isNotEmpty) {
                viewModel.addSkill(skillController.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // نافذة إضافة مشروع جديد
  void _showAddProjectDialog(PortfolioViewModel viewModel) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController imageController = TextEditingController();
    final TextEditingController githubController = TextEditingController();
    final TextEditingController liveController = TextEditingController();
    final TextEditingController techsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondaryBackground,
        title: const Text("Add New Project", style: TextStyle(color: AppColors.textPrimary)),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: "Project Title", labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: "Description", labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: imageController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: "Project Image URL", labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: githubController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: "GitHub URL", labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: liveController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: "Live Demo URL", labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: techsController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: "Technologies (comma separated)", labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentColor),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                List<String> technologies = techsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                final newProject = Project(
                  title: titleController.text.trim(),
                  description: descController.text.trim(),
                  imageUrl: imageController.text.trim(),
                  githubUrl: githubController.text.trim(),
                  liveUrl: liveController.text.trim(),
                  technologies: technologies,
                );

                viewModel.addProject(newProject);
                Navigator.pop(context);
              }
            },
            child: const Text("Add Project", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // نافذة تعديل مشروع موجود مسبقاً
  void _showEditProjectDialog(PortfolioViewModel viewModel, int index, dynamic project) {
    final TextEditingController titleController = TextEditingController(text: project.title);
    final TextEditingController descController = TextEditingController(text: project.description);
    final TextEditingController imageController = TextEditingController(text: project.imageUrl);
    final TextEditingController githubController = TextEditingController(text: project.githubUrl);
    final TextEditingController liveController = TextEditingController(text: project.liveUrl);
    final TextEditingController techsController = TextEditingController(text: project.technologies.join(', '));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondaryBackground,
        title: const Text("Edit Project", style: TextStyle(color: AppColors.textPrimary)),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: "Project Title", labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: "Description", labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: imageController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: "Project Image URL", labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: githubController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: "GitHub URL", labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: liveController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: "Live Demo URL", labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: techsController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: "Technologies (comma separated)", labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentColor),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                List<String> technologies = techsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                final updatedProject = Project(
                  title: titleController.text.trim(),
                  description: descController.text.trim(),
                  imageUrl: imageController.text.trim(),
                  githubUrl: githubController.text.trim(),
                  liveUrl: liveController.text.trim(),
                  technologies: technologies,
                );

                viewModel.updateProject(index, updatedProject);
                Navigator.pop(context);
              }
            },
            child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PortfolioViewModel>();
    
    final rawSkills = viewModel.portfolioData?.skills;
    final List<String> skills = rawSkills != null ? List<String>.from(rawSkills) : [];

    final rawProjects = viewModel.portfolioData?.projects;
    final List<dynamic> projects = rawProjects != null ? List<dynamic>.from(rawProjects) : [];

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryBackground,
        title: const Text("Portfolio Control Panel", style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: "Logout",
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome, Mohamed Sallam 🚀",
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Full control panel: Manage profile, skills, projects, and incoming messages.",
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                ),
                const SizedBox(height: 40),
                
                // 1. قسم بيانات البروفايل
                _buildSectionCard(
                  title: "1. Profile Information",
                  children: [
                    _buildTextField("Full Name", _nameController),
                    const SizedBox(height: 20),
                    _buildTextField("Professional Role", _roleController),
                    const SizedBox(height: 20),
                    _buildTextField("Bio / Description", _bioController, maxLines: 3),
                    const SizedBox(height: 20),
                    _buildTextField("Avatar Image URL", _avatarController),
                    const SizedBox(height: 20),
                    _buildTextField("CV URL", _cvController),
                  ],
                ),
                const SizedBox(height: 30),

                // 2. قسم إدارة المهارات
                _buildSectionCard(
                  title: "2. Skills Management",
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: skills.map((skill) => Chip(
                        backgroundColor: AppColors.primaryBackground,
                        label: Text(skill, style: const TextStyle(color: AppColors.textPrimary)),
                        deleteIcon: const Icon(Icons.close, size: 16, color: Colors.redAccent),
                        onDeleted: () => viewModel.removeSkill(skill),
                      )).toList(),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                      onPressed: () => _showAddSkillDialog(viewModel),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text("Add New Skill", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // 3. قسم إدارة المشاريع
                _buildSectionCard(
                  title: "3. Projects Management",
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        final project = projects[index];
                        return Card(
                          color: AppColors.primaryBackground,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(project.title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                            subtitle: Text(project.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                  tooltip: "Edit Project",
                                  onPressed: () => _showEditProjectDialog(viewModel, index, project),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  tooltip: "Delete Project",
                                  onPressed: () => viewModel.removeProject(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                      onPressed: () => _showAddProjectDialog(viewModel),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text("Add New Project", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // 📨 4. قسم رسائل الزوار (Inbox Messages from Firebase)
                _buildSectionCard(
                  title: "4. Inbox Messages (Client / HR)",
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('messages').orderBy('timestamp', descending: true).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text("No messages yet.", style: TextStyle(color: AppColors.textSecondary));
                        }

                        final messages = snapshot.data!.docs;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final msg = messages[index];
                            final data = msg.data() as Map<String, dynamic>;
                            return Card(
                              color: AppColors.primaryBackground,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(data['name'] ?? 'Unknown', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text("Email: ${data['email'] ?? ''}", style: const TextStyle(color: AppColors.accentColor, fontSize: 13)),
                                    const SizedBox(height: 4),
                                    Text("Message: ${data['message'] ?? ''}", style: const TextStyle(color: AppColors.textSecondary)),
                                  ],
                                ),
                                isThreeLine: true,
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  tooltip: "Delete Message",
                                  onPressed: () async {
                                    // حذف الرسالة من فايربيس
                                    await FirebaseFirestore.instance.collection('messages').doc(msg.id).delete();
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                
                // زر الحفظ النهائي
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentColor,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      viewModel.updateProfile(
                        name: _nameController.text.trim(),
                        role: _roleController.text.trim(),
                        bio: _bioController.text.trim(),
                        avatarUrl: _avatarController.text.trim(),
                        cvUrl: _cvController.text.trim(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("All changes saved & updated live in Firebase! 🎉")),
                      );
                    },
                    child: const Text(
                      "Save All Changes",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: AppColors.accentColor, fontSize: 20, fontWeight: FontWeight.bold)),
          const Divider(color: Colors.white24, height: 30),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white24)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.accentColor)),
      ),
    );
  }
}