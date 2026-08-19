import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Maps an admin-typed emoji glyph (from a content-page API `icon` field) to
/// a flat FontAwesome icon, so pages render one consistent icon style instead
/// of mixed emoji fonts across devices.
///
/// Unrecognized/empty glyphs fall back to a cycling palette picked by index,
/// so a grid always looks deliberate even when the admin leaves `icon` blank
/// or types something unmapped.
class IconMapper {
  IconMapper._();

  static const Map<String, FaIconData> _emojiToIcon = {
    '🎓': FontAwesomeIcons.graduationCap,
    '📚': FontAwesomeIcons.bookOpen,
    '📖': FontAwesomeIcons.book,
    '💡': FontAwesomeIcons.lightbulb,
    '🎥': FontAwesomeIcons.video,
    '🎬': FontAwesomeIcons.clapperboard,
    '📺': FontAwesomeIcons.video,
    '🌍': FontAwesomeIcons.earthAsia,
    '🌐': FontAwesomeIcons.globe,
    '📥': FontAwesomeIcons.download,
    '⬇️': FontAwesomeIcons.download,
    '💬': FontAwesomeIcons.comments,
    '🗨️': FontAwesomeIcons.comment,
    '🏆': FontAwesomeIcons.trophy,
    '🏅': FontAwesomeIcons.medal,
    '✅': FontAwesomeIcons.circleCheck,
    '✔️': FontAwesomeIcons.check,
    '🔥': FontAwesomeIcons.fire,
    '⭐': FontAwesomeIcons.star,
    '🌟': FontAwesomeIcons.star,
    '🛠️': FontAwesomeIcons.screwdriverWrench,
    '🛠': FontAwesomeIcons.screwdriverWrench,
    '📈': FontAwesomeIcons.chartLine,
    '📊': FontAwesomeIcons.chartColumn,
    '💼': FontAwesomeIcons.briefcase,
    '🕐': FontAwesomeIcons.clock,
    '⏱️': FontAwesomeIcons.stopwatch,
    '⏱': FontAwesomeIcons.stopwatch,
    '📅': FontAwesomeIcons.calendarDays,
    '🎯': FontAwesomeIcons.bullseye,
    '🚀': FontAwesomeIcons.rocket,
    '📞': FontAwesomeIcons.phone,
    '☎️': FontAwesomeIcons.phone,
    '💰': FontAwesomeIcons.sackDollar,
    '💵': FontAwesomeIcons.moneyBillWave,
    '🔒': FontAwesomeIcons.lock,
    '🔓': FontAwesomeIcons.lockOpen,
    '👥': FontAwesomeIcons.userGroup,
    '👤': FontAwesomeIcons.user,
    '📜': FontAwesomeIcons.scroll,
    '📌': FontAwesomeIcons.thumbtack,
    '📝': FontAwesomeIcons.penToSquare,
    '🚢': FontAwesomeIcons.ship,
    '✈️': FontAwesomeIcons.plane,
    '📦': FontAwesomeIcons.box,
    '🏢': FontAwesomeIcons.building,
    '🎁': FontAwesomeIcons.gift,
    '📄': FontAwesomeIcons.fileLines,
    '🔍': FontAwesomeIcons.magnifyingGlass,
    '🤝': FontAwesomeIcons.handshake,
    '🛡️': FontAwesomeIcons.shieldHalved,
    '🛡': FontAwesomeIcons.shieldHalved,
    '❤️': FontAwesomeIcons.heart,
    '💎': FontAwesomeIcons.gem,
  };

  /// A varied, brand-neutral cycling set used when the glyph is unmapped.
  static const List<FaIconData> _fallbackCycle = [
    FontAwesomeIcons.star,
    FontAwesomeIcons.bookOpen,
    FontAwesomeIcons.lightbulb,
    FontAwesomeIcons.chartLine,
    FontAwesomeIcons.circleCheck,
    FontAwesomeIcons.rocket,
  ];

  static FaIconData resolve(String? rawIcon, {int fallbackIndex = 0}) {
    final glyph = rawIcon?.trim() ?? '';
    final mapped = _emojiToIcon[glyph];
    if (mapped != null) return mapped;
    return _fallbackCycle[fallbackIndex % _fallbackCycle.length];
  }
}
