import 'package:flutter/material.dart';

class CoachMarkDesc extends StatefulWidget {
  const CoachMarkDesc({
    super.key,
    required this.text,
    this.skip = "skip",
    this.next = "next",
    this.onSkip,
    this.onNext,
  });

  final String text;
  final String skip;
  final String next;
  final void Function()? onSkip;
  final void Function()? onNext;

  @override
  State<CoachMarkDesc> createState() => _CoachMarkDescState();
}

class _CoachMarkDescState extends State<CoachMarkDesc> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD2E9FF),
            Color(0xFFFFFFFF),
          ],
        ),
        borderRadius: BorderRadius.circular(12), // Add rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onSkip,
                child: Text(
                  widget.skip,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(
                width: 16, // Adjusted from height to width for spacing
              ),
              ElevatedButton(
                onPressed: widget.onNext,
                child: Text(
                  widget.next,
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD2E9FF)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
