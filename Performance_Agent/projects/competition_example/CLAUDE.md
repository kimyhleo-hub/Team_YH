# Competition Example — Performance Agent 확장

## 프로젝트 개요

- **태스크 유형**: 이진 분류
- **평가지표**: F1-score (macro)
- **제출 형식**: `id,prediction` (확률 아닌 레이블)
- **제약 조건**: 추론 시간 제한 없음, 일일 제출 횟수 5회

## 현재 베이스라인

- **모델**: LightGBM (기본 파라미터)
- **성능**: F1-score 0.823 (5-Fold Stratified CV)
- **주요 미해결 문제**: 클래스 2에서 오류율 높음 (샘플 수 적음)

## 프로젝트 특화 전략

**효과 확인된 기법**:
- Stratified K-Fold (k=5)
- 결측치: 중앙값 대체

**효과 없었던 기법**:
- (아직 없음)

**우선 탐색 방향**:
1. 클래스 2 데이터 증강 (SMOTE)
2. 임계값 최적화 (F1 기준)
3. 학습률 + weight_decay 탐색

## 참조

- 실험 이력: `context.md`
- 하이퍼파라미터 전략: `../../strategies/hyperparameter.md`
- 검증 전략: `../../strategies/validation_strategy.md`
- 오류 분석: `../../strategies/error_analysis.md`
