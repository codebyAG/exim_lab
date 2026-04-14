import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/section_header.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final testimonials = [
      {
        "name": "Amit Sharma",
        "text":
            "The step-by-step guide on IEC registration and GST for exports was a lifesaver. Started my journey in weeks!",
        "rating": "5.0",
      },
      {
        "name": "Priya Patel",
        "text":
            "The industry insights on documentation are incredible. Best practical learning for Indian exporters.",
        "rating": "4.9",
      },
      {
        "name": "Rahul Verma",
        "text":
            "Finally understood the complexities of DGFT and custom clearance. The support group is very helpful.",
        "rating": "5.0",
      },
      {
        "name": "Vikram Singh",
        "text":
            "Cleared my first export shipment to Dubai with ease. The logistics module is very detailed and practical.",
        "rating": "4.8",
      },
      {
        "name": "Sneha Gupta",
        "text":
            "Best platform for women entrepreneurs. Very easy to follow and the mobile app UI is truly premium!",
        "rating": "5.0",
      },
      {
        "name": "Arjun Mehra",
        "text":
            "Quality courses and highly knowledgeable instructors. Learnt about shipping documents in just 2 days.",
        "rating": "4.9",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: "Student Success Stories",
          subtitle: "Real results from our premium members",
        ),
        SizedBox(height: 0.8.h),
        SizedBox(
          height: 24.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            scrollDirection: Axis.horizontal,
            itemCount: testimonials.length,
            separatorBuilder: (_, _) => SizedBox(width: 4.w),
            itemBuilder: (context, index) {
              final t = testimonials[index];
              return Container(
                width: 80.w,
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: cs.primary.withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            color: cs.primary,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t["name"]!,
                                style: TextStyle(
                                  color: cs.primary,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star, color: cs.primary, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    t["rating"]!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.format_quote_rounded,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      "\"${t["text"]}\"",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: cs.onSurfaceVariant,
                        fontSize: 13.sp,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
