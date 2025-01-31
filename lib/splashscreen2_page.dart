import 'package:flutter/material.dart';
import 'package:midterm_project/home_page.dart';

class LearnEnglishReasonPage extends StatefulWidget {
  @override
  _LearnEnglishReasonPageState createState() => _LearnEnglishReasonPageState();
}

class _LearnEnglishReasonPageState extends State<LearnEnglishReasonPage> {
  String? selectedReason;

  final List<Map<String, String>> reasons = [
    {"emoji": "🎓", "reason": "For academic purposes"},
    {"emoji": "💼", "reason": "For career growth"},
    {"emoji": "✈️", "reason": "For travel and exploration"},
    {"emoji": "🗣️", "reason": "To communicate with others"},
    {"emoji": "📚", "reason": "For personal development"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFBFC5), Color(0xFFEB8DB5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                "Why Do You Want to Learn English? 🧐",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text(
                "Pick a reason that motivates you the most.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: reasons.length,
                  itemBuilder: (context, index) {
                    final reason = reasons[index];
                    final isSelected = selectedReason == reason["reason"];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedReason = reason["reason"];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.purple[50] : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                isSelected ? Colors.purple : Colors.grey[300]!,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Text(
                            reason["emoji"]!,
                            style: const TextStyle(fontSize: 28),
                          ),
                          title: Text(
                            reason["reason"]!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle,
                                  color: Colors.purple)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectedReason != null
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Thank you for answer!"),
                          ),
                        );
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedReason != null ? Colors.black : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Next",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
