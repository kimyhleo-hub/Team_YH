# 오류 분석 프로토콜

## 언제 수행하는가

- 3회 연속 실험에서 성능 개선 없을 때 → 새 실험 전에 반드시 먼저 수행
- 성능 급락이 발생했을 때
- 로컬 검증과 리더보드 점수 괴리가 클 때

## 오류 샘플 수집

```python
# 분류: 틀린 샘플 추출
errors = val_df[val_df['pred'] != val_df['true']].copy()
errors['confidence'] = val_proba.max(axis=1)

# 신뢰도 높은 오류 (모델이 확신했지만 틀린 경우) → 레이블 오류 또는 피처 부재
high_conf_errors = errors[errors['confidence'] > 0.8]

# 경계선 오류 (애매한 경우)
boundary_errors = errors[errors['confidence'].between(0.4, 0.6)]
```

## 오류 패턴 분류

### 1. 클래스별 집중 오류
```python
# 클래스별 오류율
error_by_class = errors.groupby('true')['pred'].count() / total_by_class
print(error_by_class.sort_values(ascending=False))
```
→ 특정 클래스 오류 집중 시: 해당 클래스 데이터 수집·증강

### 2. 피처 구간별 오류
```python
# 특정 피처 범위에 오류 집중?
import matplotlib.pyplot as plt
plt.hist(errors['feature_x'], bins=20, label='error')
plt.hist(val_df['feature_x'], bins=20, alpha=0.5, label='all')
plt.legend()
plt.show()
```
→ 특정 구간 집중 시: 해당 구간 피처 추가, 도메인 지식 확인

### 3. 경계선 샘플 (Hard Examples)
- 낮은 확신도(0.4~0.6)에서 오류 집중 → 모델 표현력 부족
- 높은 확신도(>0.8)에서 오류 집중 → 레이블 오류 또는 이상 샘플

## 근본 원인 진단 → 처방

| 진단 | 증거 | 처방 |
|------|------|------|
| 데이터 부족 | 특정 클래스 오류율 높음, 샘플 수 적음 | 데이터 수집·증강 |
| 레이블 오류 | 고신뢰 오류 많음, 직접 확인 시 이상 | 데이터 정제, 클리닝 |
| 피처 부재 | 오류 샘플과 정답 샘플 시각적 차이 있음 | 피처 엔지니어링 |
| 모델 표현력 부족 | 저신뢰 오류 많음, 복잡한 패턴 | 아키텍처 개선 |
| 분포 불일치 | 로컬 좋지만 리더보드 낮음 | 도메인 적응, 검증 재설계 |

## 오류 분석 결과 기록 형식

```markdown
## 오류 분석 — 실험 {날짜}

**오류율**: {전체 오류 수} / {검증 샘플 수} = {오류율}%

**패턴 발견**:
- 클래스 {X}에서 오류 집중 (오류율 {Y}%)
- {피처명} 값이 높을수록 오류 증가
- 고신뢰 오류 {N}건 → 레이블 이상 가능성

**진단**: {원인}

**다음 실험 방향**: {구체적 조치}
```
