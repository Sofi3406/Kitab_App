import 'package:flutter/material.dart';
import 'audio_pdf_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<String> records = List.generate(
    20,
    (index) => 'ሸርህ_ኡሱሊ_ሲታህ_${index + 1}',
  );

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      backgroundColor: const Color(0xFF0F622A),
      body: SafeArea(
        child: Column(
          children: [
            if (isPortrait)
              Container(
                margin: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1F7C3C), Color(0xFF0E5A26)],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.75),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        'assets/kitab/Usulu_sitah.png',
                        height: 82,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'ሸርህ ኡሱሊ ሲታህ',
                      style: TextStyle(
                        fontFamily: 'NotoSansEthiopic',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '📚شرح أصول الستة لشيخ صالح الفوزان ',
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF5F8EE),
                        letterSpacing: 1.1,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'በውዱ ኡስታዛችን አቡ አብዲላህ ሰዕድ ኢብኑ ዐብዲለጢፍ(ሀፊዘሁሏህ)',
                      style: TextStyle(
                        fontFamily: 'NotoSansEthiopic',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 16),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: const Color(0xFFF7F8F2),
                      border: Border.all(
                        color: const Color(0xFF1A7A39),
                        width: 2,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AudioPdfScreen(
                              title: 'ክፍል_${index + 1}',
                              audioPath: 'assets/kitab/ክፍል_${index + 1}.mp3',
                              pdfPath: 'assets/kitab/ሸርህ ኡሱሊ ሲታህ.pdf',
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1A7A39),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.chevron_left,
                              color: Color(0xFF1A7A39),
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                records[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'NotoSansEthiopic',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF185F2E),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.chevron_right,
                              color: Color(0xFF1A7A39),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.headphones,
                              color: Color(0xFF1A7A39),
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
