/// 护眼提醒服务 — 20-20-20 法则
///
/// 连续播放达到设定时长后暂停，休息若干秒后自动恢复。
/// 默认: 每 20 分钟暂停 20 秒。

import 'dart:async';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class EyeCareService {
  static final EyeCareService _instance = EyeCareService._internal();
  factory EyeCareService() => _instance;
  EyeCareService._internal();

  Timer? _intervalTimer;
  Timer? _restCountdown;

  /// 本次连续播放已累积的秒数
  int _accumulatedSeconds = 0;

  /// 是否正在休息中
  bool _isResting = false;

  bool get isResting => _isResting;

  /// 休息倒计时剩余秒数
  int _restRemaining = 0;
  int get restRemaining => _restRemaining;

  bool get isEnabled => Pref.enableEyeCare;
  int get intervalMinutes => Pref.eyeCareIntervalMinutes;
  int get restSeconds => Pref.eyeCareRestSeconds;

  /// 外部回调: 到达间隔 → 暂停播放
  void Function()? onPauseRequired;

  /// 外部回调: 休息结束 → 恢复播放
  void Function()? onRestComplete;

  /// 外部回调: UI 刷新（用于更新倒计时显示）
  void Function()? onTick;

  /// 播放器开始播放时调用
  void onPlaybackStarted() {
    if (!isEnabled || _isResting) return;
    _startIntervalTimer();
  }

  /// 播放器暂停时调用（用户手动暂停）
  void onPlaybackPaused() {
    if (_isResting) return; // 护眼休息中的暂停不计
    _intervalTimer?.cancel();
  }

  /// 播放器停止/销毁时调用
  void onPlaybackStopped() {
    _intervalTimer?.cancel();
    _restCountdown?.cancel();
    _accumulatedSeconds = 0;
    _isResting = false;
    _restRemaining = 0;
    SmartDialog.dismiss();
  }

  void _startIntervalTimer() {
    _intervalTimer?.cancel();
    final intervalSec = intervalMinutes * 60;
    _intervalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _accumulatedSeconds++;
      if (_accumulatedSeconds >= intervalSec) {
        _accumulatedSeconds = 0;
        _triggerRest();
      }
    });
  }

  void _triggerRest() {
    _intervalTimer?.cancel();
    _isResting = true;
    _restRemaining = restSeconds;

    onPauseRequired?.call();
    _showRestOverlay();

    // 倒计时
    _restCountdown?.cancel();
    _restCountdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      _restRemaining--;
      onTick?.call();
      if (_restRemaining <= 0) {
        timer.cancel();
        _onRestFinished();
      }
    });
  }

  void _showRestOverlay() {
    SmartDialog.show(
      alignment: Alignment.center,
      clickMaskDismiss: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // 注册 tick 回调以刷新倒计时
            onTick = () => setDialogState(() {});

            final theme = Theme.of(context);
            return Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.remove_red_eye_outlined,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '护眼时间',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '每 ${intervalMinutes}min 休息 ${restSeconds}s\n'
                    '让眼睛放松一下',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${_restRemaining}s',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      SmartDialog.dismiss();
                      skipRest();
                    },
                    child: const Text('跳过休息'),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      // dialog dismissed
      onTick = null;
    });
  }

  /// 倒计时结束，关闭弹窗并恢复播放
  void _onRestFinished() {
    SmartDialog.dismiss();
    _isResting = false;
    onRestComplete?.call();
    _startIntervalTimer();
  }

  /// 用户手动跳过本次休息
  void skipRest() {
    _restCountdown?.cancel();
    _isResting = false;
    _restRemaining = 0;
    onRestComplete?.call();
    _startIntervalTimer();
    onTick = null;
  }

  void dispose() {
    _intervalTimer?.cancel();
    _restCountdown?.cancel();
    SmartDialog.dismiss();
  }
}

final eyeCareService = EyeCareService();
