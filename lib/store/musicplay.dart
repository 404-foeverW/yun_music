// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

// 精简歌曲信息（外部传入的列表元素，不含播放 URL）
class SongBrief {
  final String id;
  final String title;
  final String artistid;
  final String artist;
  final String? coverUrl;
  final Duration? duration;
  final String? localPath;
  final int fee;
  final int pop;
  final int mvid;

  SongBrief({
    required this.id,
    required this.title,
    required this.artistid,
    required this.artist,
    required this.fee,
    required this.pop,
    required this.mvid,
    this.coverUrl,
    this.duration,
    this.localPath,
  });
}

class Song {
  final String id;
  final String title;
  final String artistid;
  final String artist;
  final String url;
  final String? coverUrl;
  final Duration? duration;

  Song({
    required this.id,
    required this.title,
    required this.artistid,
    required this.artist,
    required this.url,
    this.coverUrl,
    this.duration,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['name'],
      artistid: json['ar'][0]['id'].toString(),
      artist: json['ar'][0]['name'],
      url: json['url'],
      coverUrl: json['al']['picUrl'],
      duration: Duration(milliseconds: json['dt']),
    );
  }
}

enum PlayMode {
  // 顺序播放
  sequence,
  // 单曲循环
  loopOne,
  // 随机播放
  shuffle,
}

enum AudioSourceType {
  network, // 网络音源
  local, // 本地音源
}

// 根据 id 解析完整歌曲信息（含播放 URL）
typedef SongResolver = Future<Song> Function(SongBrief songbrief, {int index});

class MusicPlayer extends GetxService {
  // final AudioPlayer _player = AudioPlayer();
  late final AudioPlayer _player;
  final Random _random = Random();

  static const _audioHeaders = {
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36 Edg/155.0.0.0',
    'Accept': '*/*',
    'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6',
    'Accept-Encoding': 'identity', // ⚠️ 重要：避免 gzip，ExoPlayer 需要原始流
    'Connection': 'keep-alive',
    'Host': 'm704.music.126.net',
    'Sec-ch-ua-platform': 'Windows',
    'Sec-fetch-dest': 'audio',
    'Sec-fetch-mode': 'no-cors',
    'Sec-fetch-site': 'cross-site',
    'sec-fetch-storage-access': 'active',
    'Sec-ch-ua':
        '"Microsoft Edge";v="155", "Chromium";v="155", "Not(A:Brand";v="24"',
    'sec-ch-ua-mobile': '?0',
    'Range': 'bytes=0-',
  };

  // ---------- 输入 ----------
  // List<SongBrief> _playlist = [];
  final _playlist = <SongBrief>[].obs;
  SongResolver? _resolver;

  // ---------- 当前播放来源 ----------
  final Rxn<String> _musicOrginTitle = Rxn<String>();
  void setMusicOrigin(String title) {
    _musicOrginTitle.value = title;
  }
  String get musicOrigin => _musicOrginTitle.value ?? '未知来源';


  // ---------- 响应式状态 ----------
  // 当前播放的歌曲（两种模式统一出口）
  final Rxn<Song> currentSong = Rxn<Song>();

  final RxInt currentIndex = 0.obs; // 当前播放歌曲索引
  final Rx<PlayMode> playMode = PlayMode.sequence.obs;
  final RxBool isPlaying = false.obs;
  final RxBool isInitialized = false.obs;
  final Rx<Duration> position = Duration.zero.obs;
  final Rxn<Duration> duration = Rxn<Duration>(); // 当前播放歌曲时长
  final Rxn<String> errorMessage = Rxn<String>();

  // true = 流式模式，false = 列表模式（init 时确定，之后不变）
  bool _streamingMode = false;
  bool get isStreamingMode => _streamingMode;

  // 当前音源类型，供自动切歌 / playNext 等方法复用
  AudioSourceType _currentSourceType = AudioSourceType.network;
  AudioSourceType get currentSourceType => _currentSourceType;

  // ---------- 预解析缓存 ----------
  Song? _cachedNext; // 已取到但还没播放的下一首
  int? _cachedNextIndex; // 缓存的下一首对应的索引
  // 正在解析/加载中（可用于显示 loading）
  final RxBool isLoading = false.obs;
  // 防止 completed 重复触发
  bool _handlingCompleted = false;
  // Stream 订阅，统一在 onClose 取消
  final List<StreamSubscription> _subscriptions = [];
  // 列表是否已就绪
  final RxBool hasPlaylist = false.obs;

  // ---------- Getters ----------
  List<SongBrief> get playlist => List.unmodifiable(_playlist);
  int get length => _playlist.length;

  // 解决playAt的防抖
  Timer? _playAtDebounce;
  int _pendingIndex = 0;
  int _operationId = 0;

  // 销毁
  @override
  onClose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    _player.dispose();
    super.onClose();
  }

  double get progress {
    final d = duration.value;
    if (d == null || d.inMilliseconds == 0) return 0;
    return (position.value.inMilliseconds / d.inMilliseconds).clamp(0.0, 1.0);
  }

  // ---------- 初始化 ----------
  // 启动时调用；用 Get.putAsync 保证初始化完成后才进 UI
  Future<MusicPlayer> init() async {
    if (isInitialized.value) return this;
    // _playlist = List.from(playlist);
    // _resolver = resolver;
    _player = AudioPlayer();
    // 事件订阅
    _bindStreams();

    // if (_playlist.isNotEmpty) {
    //   await _playIndex(initialIndex, autoPlay: autoPlay);
    // }

    isInitialized.value = true;
    return this;
  }

  // ============================================================
  // 后续注入：设置歌曲列表
  // ============================================================
  // 在任意页面调用，注入列表和解析器
  // [autoPlay] 是否自动播放第一首
  // [initialIndex] 从第几首开始
  Future<Duration> setPlaylist({
    required List<SongBrief> playlist,
    required SongResolver resolver,
    AudioSourceType sourceType = AudioSourceType.network,
    int initialIndex = 0,
    bool autoPlay = false,
  }) async {
    if (playlist.isEmpty) {
      clearPlaylist();
      return Duration.zero;
    }
    // _playlist = List.from(playlist);
    _playlist.assignAll(playlist);
    _resolver = resolver;
    _cachedNext = null;
    _cachedNextIndex = null;
    _currentSourceType = sourceType;

    hasPlaylist.value = true;

    return await _playIndex(
      initialIndex,
      sourceType: sourceType,
      autoPlay: autoPlay,
    );
  }

  // 追加列表（比如"加载更多"）
  void appendPlaylist(List<SongBrief> more) {
    if (more.isEmpty) return;
    _playlist.addAll(more);
    hasPlaylist.value = true;
  }

  // 清空列表
  void clearPlaylist() {
    _playlist.clear();
    _resolver = null;
    _cachedNext = null;
    _cachedNextIndex = null;
    currentSong.value = null;
    currentIndex.value = 0;
    hasPlaylist.value = false;
    duration.value = null;
    position.value = Duration.zero;
    _player.stop();
  }

  // 解析 + 加载 + 播放
  Future<Duration> _playIndex(
    int index, {
    AudioSourceType sourceType = AudioSourceType.network,
    bool autoPlay = false,
  }) async {
    print('index----------------');
    print(index);
    // if(_playlist.isEmpty || _resolver == null) return Duration.zero;

    // 网络模式才需要 resolver
    if (sourceType == AudioSourceType.network && _resolver == null) {
      return Duration.zero;
    }

    final safeIndex = index.clamp(0, _playlist.length - 1);
    print('-------------safeIndex----------:${safeIndex}');
    final targetBrief = _playlist[safeIndex];
    final nextIndex = _nextIndex(safeIndex);

    isLoading.value = true;
    errorMessage.value = null;

    // 切歌前清空时长和进度
    duration.value = null;
    position.value = Duration.zero;
    try {
      // 1. 解析当前歌（优先命中缓存）
      Song current;
      Song? next;
      List<AudioSource> sources;

      if (sourceType == AudioSourceType.network) {
        if (_cachedNext != null && _cachedNextIndex == safeIndex) {
          current = _cachedNext!;
          _cachedNext = null;
          _cachedNextIndex = null;
        } else {
          // current = await _resolver!(targetBrief.id);
          current = await _resolver!(targetBrief);
        }

        // 2. 预解析下一首
        if (_playlist.length > 1) {
          if (_cachedNext != null && _cachedNextIndex == nextIndex) {
            next = _cachedNext;
          } else {
            try {
              // next = await _resolver!(_playlist[nextIndex].id);
              next = await _resolver!(_playlist[nextIndex]);
            } catch (e) {
              next = null;
            }
          }
        }

        // 3. 更新状态
        currentIndex.value = safeIndex;
        print('currentIndex 更新: ${currentIndex.value}');
        currentSong.value = current;
        _cachedNext = next;
        _cachedNextIndex = next != null ? nextIndex : null;

        // 4. 塞给播放器：当前 + 下一首
        sources = <AudioSource>[
          AudioSource.uri(
            Uri.parse(current.url),
            headers: {'Referer': 'https://music.163.com/', ..._audioHeaders},
          ),
          // if (next != null)
          //   AudioSource.uri(
          //     Uri.parse(next.url),
          //     headers: {'Referer': 'https://music.163.com/', ..._audioHeaders},
          //   ),
        ];
      } else {
        // ===================== 本地模式 =====================
        // 1. 从 SongBrief 直接构造 Song（本地路径已在 brief 里）
        current = await _resolver!(targetBrief, index: safeIndex);

        if (_playlist.length > 1) {
          next = await _resolver!(_playlist[nextIndex], index: nextIndex);
        }

        // 2. 更新状态（不涉及 resolver 缓存）
        currentIndex.value = safeIndex;
        print('currentIndex 更新: ${currentIndex.value}');
        currentSong.value = current;
        _cachedNext = next;
        _cachedNextIndex = next != null ? nextIndex : null;

        // 3. 构造本地音源
        sources = <AudioSource>[
          // 加载Asset文件中的音乐
          AudioSource.asset(current.url),
          // if (next != null) AudioSource.asset(next.url),
        ];
      }

      // 记录当前模式，供后续自动切歌 / next / previous 使用
      _currentSourceType = sourceType;

      // 拿到 setAudioSources 的返回值（当前音源时长）
      final loadedDuration = await _player.setAudioSources(
        sources,
        initialIndex: 0,
        initialPosition: Duration.zero,
        preload: true, // 预加载相邻曲目
      );

      // 主动设置，不依赖 durationStream 的延迟
      if (loadedDuration != null) {
        duration.value = loadedDuration;
      }

      _applyPlayMode();
      if (autoPlay) {
        await _player.play();
      }
    } catch (e) {
      errorMessage.value = '加载失败：$e';
      return Duration.zero;
    } finally {
      isLoading.value = false;
    }
    return _player.duration ?? Duration.zero;
  }

  // 将 SongBrief 转为本地模式使用的 Song
  Song _briefToSong(SongBrief brief) {
    return Song(
      id: brief.id,
      title: brief.title,
      artistid: brief.artistid,
      artist: brief.artist,
      url: brief.localPath ?? '', // ← 本地路径
      coverUrl: brief.coverUrl,
      duration: brief.duration,
    );
  }

  int _nextIndex(int index) {
    if (_playlist.isEmpty) return 0;
    return (index + 1) % _playlist.length;
  }

  // ============================================================
  // 播放模式
  // ============================================================
  void _applyPlayMode() {
    _player.setLoopMode(LoopMode.off);
    _player.setShuffleModeEnabled(playMode.value == PlayMode.shuffle);
  }

  void setPlayMode(PlayMode mode) {
    if (playMode.value == mode) return;
    playMode.value = mode;
    _applyPlayMode();
  }

  void cyclePlayMode() {
    switch (playMode.value) {
      case PlayMode.sequence:
        setPlayMode(PlayMode.loopOne);
        break;
      case PlayMode.loopOne:
        setPlayMode(PlayMode.shuffle);
        break;
      case PlayMode.shuffle:
        setPlayMode(PlayMode.sequence);
        break;
    }
  }

  void _bindStreams() {
    print('--- _bindStreams 被调用 ---'); // ← 加这个
    _subscriptions.addAll([
      // 播放状态（含播放完毕）
      _player.playerStateStream.listen((state) {
        try {
          print('---------监听播放状态------');
          isPlaying.value =
              state.playing &&
              state.processingState != ProcessingState.completed;
          print(isPlaying.value);
          if (state.processingState == ProcessingState.completed) {
            // 自动切歌
            print('---------播放完毕，自动切歌------');
            _onSongCompleted();
          }
        } catch (e, stack) {
          print('!!! listen 回调抛异常: $e');
          print(stack);
        }
      }),
      // 监听当前播放是第几首歌曲
      // _player.currentIndexStream.listen((index) {
      //   if (index != null) currentIndex.value = index;
      //   print('当前播放的歌曲为${currentIndex.value}');
      // }),
      // _player.positionDiscontinuityStream.listen((d) {
      //   if (d.reason == PositionDiscontinuityReason.autoAdvance) {
      //     // final newIndex = d.event.currentIndex;
      //     print('自动切歌到索引:');
      //     // 更新你的业务逻辑
      //     // currentIndex.value = newIndex ?? 0;
      //     _onSongCompleted();
      //   }
      // }),
      // 播放位置
      _player.positionStream.listen((p) => position.value = p),
      // 总时长
      _player.durationStream.listen((d) {
        print('音乐总时长----------------------');
        print(d);
        // duration.value = d;
        // 只在新时长有效时更新，避免覆盖已设置的时长
        if (d != null && d != duration.value) {
          duration.value = d;
        }
      }),
      // 错误
      _player.errorStream.listen(
        (e) => errorMessage.value = '${e.code}: ${e.message}',
      ),
    ]);
  }

  // 播放控制
  Future<void> play() async {
    if (currentSong.value == null) return;
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> togglePlayPause() async {
    // 还没歌时，尝试播放第一首
    if (currentSong.value == null && _playlist.isNotEmpty) {
      await _playIndex(0, sourceType: _currentSourceType, autoPlay: true);
      return;
    }
    if (_player.playing) {
      await pause();
    } else {
      await play();
    }
  }

  // ---------- 播放完毕自动切歌 ----------
  Future<void> _onSongCompleted() async {
    if (_handlingCompleted) return;
    if (currentSong.value == null) return;
    if (_playlist.isEmpty) return;

    _handlingCompleted = true;
    try {
      switch (playMode.value) {
        case PlayMode.loopOne:
          print('当前播放模式为单曲循环');
          await _player.seek(Duration.zero);
          await _player.play();
          break;
        case PlayMode.sequence:
          print('当前播放模式为顺序播放');
          await _playIndex(
            _nextIndex(currentIndex.value),
            sourceType: _currentSourceType,
          );
          break;
        case PlayMode.shuffle:
          print('当前播放模式为随机播放');
          await _playIndex(_randomIndex(), sourceType: _currentSourceType);
          break;
      }
    } finally {
      // 延迟释放，防止同一帧内多次触发
      Future.delayed(Duration(milliseconds: 300), () {
        _handlingCompleted = false;
      });
    }
  }

  // 播放下一首
  Future<void> playNext() async {
    if (_playlist.isEmpty) return;
    if (playMode.value == PlayMode.shuffle) {
      await _playIndex(_randomIndex(), sourceType: _currentSourceType, autoPlay: true);
    } else {
      await _playIndex(
        _nextIndex(currentIndex.value),
        sourceType: _currentSourceType,
        autoPlay: true
      );
    }
  }

  // 获取歌曲索引
  int _randomIndex() {
    if (_playlist.length <= 1) return 0;
    int next;
    do {
      next = _random.nextInt(_playlist.length);
    } while (next == currentIndex.value);
    return next;
  }

  // 播放上一首
  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;

    // 清空缓存，避免上一首和缓存下一首冲突
    _cachedNext = null;
    _cachedNextIndex = null;
    if (playMode.value == PlayMode.shuffle) {
      await _playIndex(_randomIndex(), sourceType: _currentSourceType, autoPlay: true);
    } else {
      await _playIndex(
        _previousIndex(currentIndex.value),
        sourceType: _currentSourceType,
        autoPlay: true
      );
    }
  }

  int _previousIndex(int from) {
    if (_playlist.isEmpty) return 0;
    return (from - 1 + _playlist.length) % _playlist.length;
  }

  // 播放指定音乐
  Future<void> playAt(int index, {AudioSourceType? sourceType, bool autoPlay = false}) async {
    if (_playlist.isEmpty) return;
    final safeIndex = index.clamp(0, _playlist.length - 1);
    _pendingIndex = safeIndex;

    // 取消上一次的延迟
    _playAtDebounce?.cancel();
    // 延迟 300ms，用户停止滑动后才执行
    _playAtDebounce = Timer(const Duration(milliseconds: 300), () async {
      final op = ++_operationId;
      _cachedNext = null;
      _cachedNextIndex = null;
      print('防抖之后解决的播放索引为$index');
      await _playIndex(
        _pendingIndex,
        sourceType: sourceType ?? _currentSourceType,
        autoPlay: autoPlay
      );
      // 防抖：期间有新请求就忽略
      if (op != _operationId) return;
    });
    // _cachedNext = null;
    // _cachedNextIndex = null;
    // await _playIndex(index, sourceType: _currentSourceType);
  }

  // 设置播放位置
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  // 删除指定歌曲
  Future<void> removeSong(int index) async {
    if (_playlist.isEmpty) return;
    final safeIndex = index.clamp(0, _playlist.length - 1);
    _playlist.removeAt(safeIndex);
    // _playlist.value = _playlist.where((e) => e != _playlist[safeIndex]).toList();
    // if (currentIndex.value == safeIndex) {
    //   await playNext();
    // }
    await _playIndex(index, sourceType: _currentSourceType, autoPlay: true);
  }
}
