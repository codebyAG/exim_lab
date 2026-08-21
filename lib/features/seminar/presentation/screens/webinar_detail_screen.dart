import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:exim_lab/features/seminar/data/models/webinar_detail_model.dart';
import 'package:exim_lab/features/seminar/data/services/webinar_service.dart';

const _navy = Color(0xFF030E30);
const _gold = Color(0xFFFFD000);
const _goldDeep = Color(0xFFCC9E00);

/// Webinar reminder deep-link target — GET /api/seminars/:seminarId.
/// A plain detail page: banner, title, description, schedule, and a
/// "Join Now" that just opens meetingUrl externally (no in-app call/video
/// handling — Zoom/Meet/YouTube Live all get treated the same way).
class WebinarDetailScreen extends StatefulWidget {
  final String seminarId;
  const WebinarDetailScreen({super.key, required this.seminarId});

  @override
  State<WebinarDetailScreen> createState() => _WebinarDetailScreenState();
}

class _WebinarDetailScreenState extends State<WebinarDetailScreen> {
  final _service = WebinarService();
  WebinarDetail? _detail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final detail = await _service.fetchWebinarDetail(widget.seminarId);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _joinNow() async {
    final url = _detail?.meetingUrl;
    if (url == null || url.isEmpty) return;
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: _navy),
        title: const Text(
          "Webinar",
          style: TextStyle(color: _navy, fontWeight: FontWeight.w800),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _gold))
          : _error != null
          ? _buildError()
          : _buildContent(_detail!),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: _navy, size: 44),
            SizedBox(height: 2.h),
            const Text(
              "Couldn't load this webinar",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _navy,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _gold,
                foregroundColor: _navy,
              ),
              onPressed: _load,
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(WebinarDetail detail) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (detail.bannerImageUrl.isNotEmpty)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl: detail.bannerImageUrl,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => const ColoredBox(color: _navy),
              placeholder: (_, _) => const ColoredBox(color: _navy),
            ),
          ),
        Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (detail.title.isNotEmpty)
                Text(
                  detail.title,
                  style: TextStyle(
                    color: _navy,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w900,
                    height: 1.25,
                  ),
                ),
              if (detail.schedule?.displayLabel.isNotEmpty ?? false) ...[
                SizedBox(height: 1.2.h),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _gold.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _gold.withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        color: _goldDeep,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        detail.schedule!.displayLabel,
                        style: const TextStyle(
                          color: _goldDeep,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (detail.description.isNotEmpty) ...[
                SizedBox(height: 2.h),
                Text(
                  detail.description,
                  style: TextStyle(
                    color: const Color(0xFF334155),
                    fontSize: 13.5.sp,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _gold,
                    foregroundColor: _navy,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 1.6.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: detail.meetingUrl.isEmpty ? null : _joinNow,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.videocam_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        "Join Now",
                        style: TextStyle(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
