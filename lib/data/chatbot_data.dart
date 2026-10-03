class ChatbotData {
  // دالة ذكية لتحليل سؤال المستخدم وإرجاع الرد المناسب
  static String getResponse(String question) {
    question = question.toLowerCase().trim();

    if (question.contains('hello') || question.contains('hi') || question.contains('السلام') || question.contains('مرحبا')) {
      return "Hello! I'm Mohamed Sallam's virtual assistant. How can I help you learn more about him?";
    } 
    else if (question.contains('skills') || question.contains('tech') || question.contains('مهارات') || question.contains('تقنيات')) {
      return "Mohamed is specialized in Flutter, Dart, Mobile App Development, UI/UX implementation, State Management (Provider/Bloc), and RESTful APIs.";
    } 
    else if (question.contains('projects') || question.contains('work') || question.contains('مشاريع') || question.contains('أعمال')) {
      return "Mohamed has built several impressive mobile and web applications using Flutter. You can check the 'Projects' section above for live demos and source codes!";
    } 
    else if (question.contains('contact') || question.contains('hire') || question.contains('email') || question.contains('تواصل') || question.contains('إيميل')) {
      return "You can reach out to Mohamed directly via the 'Contact' section at the bottom of the page, or click 'Say Hello' to send a direct message!";
    } 
    else if (question.contains('flutter') || question.contains('فلاتر')) {
      return "Flutter is Mohamed's superpower! He builds cross-platform apps for Android, iOS, and Web with high performance and smooth animations.";
    }
    else {
      return "That's an interesting question! For specific inquiries, feel free to contact Mohamed directly through the contact form or social links below.";
    }
  }
}