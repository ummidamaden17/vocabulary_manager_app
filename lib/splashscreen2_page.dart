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
        decoration: BoxDecoration(
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
              SizedBox(
                height: 100,
              ),
              Text(
                "Why Do You Want to Learn English? 🧐",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                "Pick a reason that motivates you the most.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
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
                        margin: EdgeInsets.only(bottom: 12),
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
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Text(
                            reason["emoji"]!,
                            style: TextStyle(fontSize: 28),
                          ),
                          title: Text(
                            reason["reason"]!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: Colors.purple)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectedReason != null
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
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
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Center(
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
