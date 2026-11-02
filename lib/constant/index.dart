class GloablConstans {
  static const String webBaseUrl = 'http://localhost:3000';
  static const String androidBaseUrl = 'http://10.0.2.2:3000';
  static const String iosBaseUrl = 'http://localhost:3000';
  static const Duration connetTimeout = Duration(seconds: 5);
  static const Duration receiveTimeout = Duration(seconds: 5);
  static const String tokenKey = 'yun_music_token';
  static const int successCode = 200;
}

class LoginApiUrl {
  static const String getCode = '/captcha/sent';
  static const String codeLogin = '/captcha/verify';
  static const String temporaryLogin = '/register/anonimous';
}

class MusicApiUrl {
  // 不登录状态下的推荐歌单
  static const String recommendMusicNL = '/personalized/newsong';
  // 获取精品歌单
  static const String highqualityMusic = '/top/playlist/highquality';
  static const String netFriendPlaylist = '/top/playlist';
  // 热门歌单分类
  static const String hotPlayListCates = '/playlist/hot';
  // 获取歌单详情
  static const String playlistDetail = '/playlist/detail';
  // 所有排行榜
  static const String topList = '/toplist';
  // 最新专辑
  static const String newAlbum = '/album/newest';
  // 获取歌曲内容
  static const String songDetail = '/song/url/v1';
  // 获取专辑内容
  static const String albumDetail = '/album';
}

// 不同分类对应的颜色
class TermColor {
  final String term;
  final String hex; // 16进制颜色值
  const TermColor(this.term, this.hex);
}
class GradientRule {
  final List<String> hexes; // 渐变顺序：起点 -> 中间 -> 终点
  final String note;
  const GradientRule(this.hexes, this.note);
}
class PaletteGroup {
  final String group;
  final List<TermColor> terms;
  final GradientRule gradient;
  const PaletteGroup(this.group, this.terms, this.gradient);
}
class FreeGradient {
  final String name;
  final List<String> hexes;
  const FreeGradient(this.name, this.hexes);
}
const chineseLanguage = TermColor('华语', '#C84B31');
const folkSong = TermColor('民谣', '#B7791F');
const toHeal = TermColor('治愈', '#2A9D8F');
const ancientStyle = TermColor('古风', '#6C4AB6');
const popular = TermColor('流行', '#F06595');
const electronicsFactory = TermColor('电子', '#2563EB');
const alternative = TermColor('另类/独立', '#8B5CF6');
const europeAndAmerica = TermColor('欧美', '#1D4ED8');
const rock = TermColor('摇滚', '#B91C1C');
const happiness = TermColor('快乐', '#F59E0B');
const lightMusic = TermColor('轻音乐', '#0EA5E9');
const acg = TermColor('ACG', '#EC4899');
const ost = TermColor('影视原声', '#1E3A8A');
const moved = TermColor('感动', '#DC2626');
const varietyShow = TermColor('综艺', '#F59E0B');
const loneLiness = TermColor('孤独', '#0F766E');
const rbSoul = TermColor('R&B/Soul', '#9D174D');

List<TermColor> cateList = [
  chineseLanguage,
  folkSong,
  toHeal,
  ancientStyle,
  popular,
  electronicsFactory,
  alternative,
  europeAndAmerica,
  rock,
  happiness,
  lightMusic,
  acg,
  ost,
  moved,
  varietyShow,
  loneLiness,
  rbSoul,
];

List<TermColor> getCateColors({String? cate, List<String>? cates}) {
  if(cates != null && cates.isNotEmpty) {
    return cates.map((item) {
      return cateList.firstWhere((element) => element.term == item);
    }).toList();
  }
  return [cateList.firstWhere((element) => element.term == cate)];
}

final List<PaletteGroup> paletteGroups = [
  PaletteGroup('华语 / 民谣 / 治愈', [
    chineseLanguage,
    folkSong,
    toHeal,
  ], GradientRule(['#C84B31', '#B7791F', '#2A9D8F'], '暖红到木色再到柔绿，自然治愈')),
  PaletteGroup('华语 / 古风 / 流行', [
    chineseLanguage,
    ancientStyle,
    popular,
  ], GradientRule(['#C84B31', '#6C4AB6', '#F06595'], '红紫邻近，雅致带流行感')),
  PaletteGroup('电子 / 孤独 / 另类独立', [
    electronicsFactory,
    loneLiness,
    alternative,
  ], GradientRule(['#8B5CF6', '#2563EB', '#0F766E'], '冷感蓝紫，科技与孤独统一')),
  PaletteGroup('欧美 / 摇滚 / 快乐', [
    europeAndAmerica,
    rock,
    happiness,
  ], GradientRule(['#1D4ED8', '#B91C1C', '#F59E0B'], '复古日落式低饱和撞色')),
  PaletteGroup('R&B/Soul / 轻音乐 / ACG', [
    rbSoul,
    lightMusic,
    acg,
  ], GradientRule(['#9D174D', '#0EA5E9', '#EC4899'], '梦幻蓝粉紫，柔和不甜腻')),
  PaletteGroup('影视原声 / 感动 / 综艺', [
    ost,
    moved,
    varietyShow,
  ], GradientRule(['#1E3A8A', '#DC2626', '#F59E0B'], '冷银幕到暖情绪')),
];
final List<FreeGradient> freeGradients = [
  FreeGradient('清新治愈', ['#2A9D8F', '#0F766E', '#0EA5E9']),
  FreeGradient('暖调叙事', ['#B7791F', '#DC2626', '#F59E0B']),
  FreeGradient('红紫雅致', ['#C84B31', '#9D174D', '#6C4AB6']),
  FreeGradient('冷感科技', ['#8B5CF6', '#2563EB', '#0F766E']),
];