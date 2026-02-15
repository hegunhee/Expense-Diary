import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/tutorial/constants/tutorial_sample_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 튜토리얼 컨트롤러 프로바이더
final tutorialControllerProvider =
    NotifierProvider<TutorialController, TutorialState>(
      TutorialController.new,
    );

/// 튜토리얼 컨트롤러
class TutorialController extends Notifier<TutorialState> {
  static const _keyTutorialShown = 'is_tutorial_shown';

  @override
  TutorialState build() {
    _loadTutorialState();

    // 기본값 반환 (비동기 로딩 전)
    return const TutorialState(
      hasSeenTutorial: true,
      tutorialData: [],
    );
  }

  /// SharedPreferences에서 데이터 로드 및 State 업데이트
  Future<void> _loadTutorialState() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool(_keyTutorialShown) ?? false;

    // 튜토리얼을 아직 안 봤으면 샘플 데이터 설정
    final tutorialData = hasSeen ? <Expense>[] : getTutorialSampleExpenses();
    state = TutorialState(
      hasSeenTutorial: hasSeen,
      tutorialData: tutorialData,
    );
  }

  /// 튜토리얼 표시 완료로 설정
  Future<void> setTutorialShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTutorialShown, true);

    state = state.copyWith(
      hasSeenTutorial: true,
      tutorialData: [], // 튜토리얼 완료 시 샘플 데이터 제거
    );
  }
}

/// 튜토리얼 상태
class TutorialState {
  /// 튜토리얼 생성자
  const TutorialState({
    required this.hasSeenTutorial,
    required this.tutorialData,
  });

  /// 튜토리얼을 이미 봤는지 여부
  final bool hasSeenTutorial;

  /// 튜토리얼용 샘플 데이터
  final List<Expense> tutorialData;

  /// 상태 복사
  TutorialState copyWith({
    bool? hasSeenTutorial,
    List<Expense>? tutorialData,
  }) {
    return TutorialState(
      hasSeenTutorial: hasSeenTutorial ?? this.hasSeenTutorial,
      tutorialData: tutorialData ?? this.tutorialData,
    );
  }
}
