# 실험 관리 프로토콜

## context.md 실험 이력 기록 형식

```markdown
| 실험 ID | 변경 내용 | 검증 성능 | 비고 |
|---------|----------|----------|------|
| 001     | 베이스라인 (ResNet50, lr=1e-3) | 0.823 | 시드 42 |
| 002     | lr=3e-4 | 0.841 (+0.018) | 단일 변인 |
| 003     | lr=3e-4 + CosineAnnealingLR | 0.856 (+0.015) | |
```

- 실험 ID는 순번으로 관리
- 변경 내용은 "무엇을 어떻게 바꿨는지" 한 줄로
- 검증 성능은 절대값 + 이전 대비 증감 함께 기록
- 비고에 특이사항, 시드, 재현 주의사항 기록

## 재현성 확보 체크리스트

```python
import random, numpy as np, torch

def set_seed(seed=42):
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    torch.backends.cudnn.deterministic = True
    torch.backends.cudnn.benchmark = False
```

- 시드는 context.md에 항상 기록
- 라이브러리 버전 고정: `pip freeze > requirements.txt`
- 데이터 셔플 순서도 시드로 고정

## 실험 우선순위 결정 기준

1. **기대 효과**: 검증 데이터 기준 예상 성능 향상 (크면 우선)
2. **실험 비용**: 학습 시간·GPU 비용 (낮으면 우선)
3. **불확실성**: 이미 효과가 확인된 기법 > 새로운 시도

우선순위 매트릭스:
```
높은 효과 + 낮은 비용 → 즉시 실행
높은 효과 + 높은 비용 → 단일 모델 최적화 후 실행
낮은 효과 + 낮은 비용 → 여유 있을 때 실행
낮은 효과 + 높은 비용 → 하지 않음
```

## 실험 비교 원칙

- **단일 변인**: 한 번에 하나만 변경
- **충분한 에포크**: Early Stopping으로 조기 종료 방지
- **동일 시드**: 노이즈 최소화를 위해 같은 시드 사용
- **최소 3회 평균**: 중요한 결정은 다른 시드로 3회 반복

## 실험이 효과 없을 때

1. 성능 개선 없음 → context.md에 "효과 없음"으로 기록
2. 오히려 하락 → "역효과, 이유 추정" 기록
3. 3회 연속 개선 없음 → 오류 분석(error_analysis.md) 먼저 수행
4. 방향 전환 시 → 현재까지 최고 성능 설정을 베이스라인으로 재설정
