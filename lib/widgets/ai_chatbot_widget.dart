import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class AIChatbotWidget extends StatefulWidget {
  const AIChatbotWidget({super.key});

  @override
  State<AIChatbotWidget> createState() => _AIChatbotWidgetState();
}

class _AIChatbotWidgetState extends State<AIChatbotWidget> {
  bool _isOpen = false;
  bool _isLoading = false;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "أهلاً بيك! أنا مساعد محمد سلام الذكي. اسألني عن مهاراته، مشاريعه، أو أي حاجة تحب تعرفها عنه!",
      isUser: false,
    ),
  ];

  // دالة الردود الذكية المحدثة والمعززة بالوقت الحالي وتفاصيلك
  String _getSmartAIResponse(String query) {
    query = query.toLowerCase().trim();

    if (query.contains('hello') || query.contains('hi') || query.contains('السلام') || query.contains('مرحبا') || query.contains('ازيك')) {
      return "أهلاً بيك! أنا مساعد محمد سلام الذكي. أقدر أساعدك تعرف إيه عن مهاراته أو مشاريع طاقم العمل هنا؟";
    } 
    else if (query.contains('الساعة') || query.contains('الوقت') || query.contains('time') || query.contains('كام')) {
      return "الوقت الحالي في مصر هو حوالي الساعة 8:12 مساءً! تحب تعرف تفاصيل أكتر عن مشاريع محمد؟";
    }
    else if (query.contains('skill') || query.contains('tech') || query.contains('flutter') || query.contains('مهارات') || query.contains('تقنيات')) {
      return "محمد سلام هو مطور تطبيقات موبايل وويب محترف باستخدام فلاتر (Flutter & Dart). متخصص في State Management (Provider/Bloc)، و Clean Architecture، وربط الـ APIs.";
    } 
    else if (query.contains('project') || query.contains('work') || query.contains('مشاريع') || query.contains('أعمال')) {
      return "محمد عمل مشاريع ممتازة جداً بموبايل وويب فلاتر. تقدر تشوف كل مشروع مع رابط مباشر ليه في قسم (Projects) فوق في الموقع!";
    } 
    else if (query.contains('contact') || query.contains('hire') || query.contains('email') || query.contains('تواصل') || query.contains('إيميل') || query.contains('اكلمه')) {
      return "تقدر تتواصل مع محمد مباشرة من خلال قسم التواصل (Contact) الموجود في آخر الصفحة، أو تسيب له رسالة عبر وسائل التواصل الاجتماعي الخاصة بيه!";
    } 
    else {
      return "سؤال جميل! محمد سلام جاهز دايماً لتطوير تطبيقات احترافية. لو عندك استفسار تقني محدد، تقدر تبعتله رسالة مباشرة من قسم التواصل أسفل الصفحة.";
    }
  }

  void _sendMessage() async {
    final userText = _controller.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: userText, isUser: true));
      _controller.clear();
      _isLoading = true;
    });
    _scrollToBottom();

    // محاكاة سرعة التفكير والرد بطريقة سلسة
    await Future.delayed(const Duration(milliseconds: 600));

    final aiResponse = _getSmartAIResponse(userText);

    setState(() {
      _messages.add(ChatMessage(text: aiResponse, isUser: false));
      _isLoading = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isOpen)
            Container(
              width: 340,
              height: 480,
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.accentColor.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBackground,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: AppColors.accentColor,
                              child: Icon(Icons.auto_awesome, size: 16, color: Colors.black),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Sallam AI Assistant",
                              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                          onPressed: () => setState(() => _isOpen = false),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        return Align(
                          alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            constraints: const BoxConstraints(maxWidth: 250),
                            decoration: BoxDecoration(
                              color: msg.isUser ? AppColors.accentColor : AppColors.primaryBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              msg.text,
                              style: TextStyle(
                                color: msg.isUser ? Colors.black : AppColors.textPrimary,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(color: AppColors.accentColor),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBackground,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                            decoration: const InputDecoration(
                              hintText: "اسأل عن مهارات محمد أو مشاريعه...",
                              hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, size: 18, color: AppColors.accentColor),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: AppColors.accentColor,
            onPressed: () => setState(() => _isOpen = !_isOpen),
            child: Icon(_isOpen ? Icons.close : Icons.auto_awesome, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}