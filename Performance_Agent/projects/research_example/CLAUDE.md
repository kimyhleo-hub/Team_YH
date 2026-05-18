# Research Example — Performance Agent 확장

## 프로젝트 개요

- **태스크 유형**: 이미지 분류 (다중 클래스)
- **평가지표**: Top-1 Accuracy, F1-score (macro)
- **제출 형식**: 논문 Table 형식 (모델별 성능 비교)
- **제약 조건**: 모델 크기 제한 없음, 추론 시간 측정 필요

## 현재 베이스라인

- **모델**: ResNet50 (ImageNet 사전학습)
- **성능**: Top-1 Accuracy 87.2% / F1 0.864
- **주요 미해결 문제**: 소수 클래스 인식률 낮음, 오클루전 케이스 약함

## 프로젝트 특화 전략

**효과 확인된 기법**:
- ImageNet 사전학습 Fine-tuning
- RandomHorizontalFlip + ColorJitter Augmentation

**효과 없었던 기법**:
- (아직 없음)

**우선 탐색 방향**:
1. EfficientNet-B4로 아키텍처 교체
2. Mixup / CutMix Augmentation
3. Focal Loss (클래스 불균형 대응)

## 참조

- 실험 이력: `context.md`
- 아키텍처 전략: `../../strategies/architecture.md`
- 데이터 증강: `../../strategies/data_engineering.md`
- 손실 함수: `../../strategies/loss_function.md`
