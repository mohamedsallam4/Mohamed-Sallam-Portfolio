class PortfolioData {
  final Profile profile;
  final List<Social> socials;
  final List<String> skills;
  final List<Project> projects;
  final Contact contact;

  PortfolioData({
    required this.profile,
    required this.socials,
    required this.skills,
    required this.projects,
    required this.contact,
  });

  factory PortfolioData.fromJson(Map<String, dynamic> json) {
    return PortfolioData(
      profile: Profile.fromJson(json['profile']),
      socials: (json['socials'] as List)
          .map((e) => Social.fromJson(e))
          .toList(),
      skills: List<String>.from(json['skills']),
      projects: (json['projects'] as List)
          .map((e) => Project.fromJson(e))
          .toList(),
      contact: Contact.fromJson(json['contact']),
    );
  }
}

class Profile {
  final String name;
  final String role;
  final String bio;
  final String avatarUrl;
  final String cvUrl;
  final String profileBackground;

  Profile({
    required this.name,
    required this.role,
    required this.bio,
    required this.avatarUrl,
    required this.cvUrl,
    required this.profileBackground,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      bio: json['bio'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      cvUrl: json['cvUrl'] ?? '',
      profileBackground: json['profileBackground'] ?? '',
    );
  }
}

class Social {
  final String platform;
  final String url;
  final String iconCode;

  Social({required this.platform, required this.url, required this.iconCode});

  factory Social.fromJson(Map<String, dynamic> json) {
    return Social(
      platform: json['platform'] ?? '',
      url: json['url'] ?? '',
      iconCode: json['iconCode'] ?? '',
    );
  }
}

class Project {
  final String title;
  final String description;
  final String imageUrl;
  final String githubUrl;
  final String? liveUrl; // قد لا يكون هناك رابط مباشر
  final List<String> technologies;

  Project({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.githubUrl,
    this.liveUrl,
    required this.technologies,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      githubUrl: json['githubUrl'] ?? '',
      liveUrl: json['liveUrl'],
      technologies: List<String>.from(json['technologies'] ?? []),
    );
  }
}

class Contact {
  final String email;
  final String phone;
  final String location;

  Contact({required this.email, required this.phone, required this.location});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
    );
  }
}
