# LLM Wiki — 나만의 AI 세컨드 브레인 (E2E 가이드)

안드레 카파시의 **LLM Wiki** 패턴을 그대로 옮긴 셋업입니다.
**옵시디언(지식 베이스) × Claude Code(AI 컴파일러) × LLM Wiki 패턴(스키마) × graphify(지식 그래프)** 조합으로,
목적 있는 지식 수집 → AI 소화 → **복리처럼 쌓이는 나만의 위키**를 만듭니다.

> **핵심 원칙 — Gold In, Gold Out**: "왜 수집했는지" 말할 수 있는 지식만 위키로 올립니다. 목적 없는 수집은 쓰레기 데이터(Garbage In, Garbage Out)가 됩니다.

---

## 🗺️ 한눈에 보는 전체 여정 (E2E)

```
①  설치            bash install.sh                  스킬 + 빈 볼트 (+graphify)
        │
②  핵심 맥락 인터뷰   /llm-wiki setup                  "나는 누구/왜/무엇을" → AI가 나를 이해
        │
③  웹 클리퍼 연결     Default.json Import + 기본삭제      웹/유튜브 클리핑이 Raw/로 자동 저장
        │
④  수집 (Raw)       웹 클리퍼로 클리핑                  논문·아티클·영상·책을 Raw/에 모음
        │
⑤  소화 (ingest)    /llm-wiki ingest                 "왜 모았어?" 인터뷰 → Wiki/에 개념·개체로 정리·연결
        │                                            (④~⑤ 반복하며 지식이 복리로 쌓임)
        │
⑥  그래프화          /llm-wiki graphify               Wiki를 지식 그래프(graph.html/json/report)로
        │
⑦  최종 결과 보기 ↓   "어떤 걸 보면 되는가"는 아래 섹션 참조
```

흐름 요약: **수집(Raw) → 소화(ingest→Wiki) → 통합(Synthesis) → 산출(Output)**

---

## ✅ 사전 준비물
- **옵시디언(Obsidian)** — https://obsidian.md
- **Claude Code** (CLI/데스크톱/IDE 중 무엇이든)
- (선택) **Python 3** — graphify 지식 그래프를 쓸 때만

---

## ① 설치

### 방법 A. 자동 (권장)
```bash
cd llm-wiki-share        # git clone 했다면 그 폴더로
bash install.sh
```
스크립트가 ① 스킬을 `~/.claude/skills/llm-wiki`에 복사 → ② 새 볼트 생성 → ③ (선택) graphify 설치까지 안내합니다.

### 방법 B. 수동
```bash
cp -R skills/llm-wiki ~/.claude/skills/llm-wiki
bash ~/.claude/skills/llm-wiki/scripts/setup_vault.sh "$HOME/Documents/my-llm-wiki" "My LLM Wiki"
bash ~/.claude/skills/llm-wiki/scripts/install_graphify.sh   # (선택) 그래프
```
> graphify는 **선택**입니다. 없어도 ②~⑤(setup/ingest/query/lint)는 완전히 동작합니다.

## ② 핵심 맥락 인터뷰
Claude Code에서 **볼트 폴더를 열고**:
```
/llm-wiki setup
```
3가지 질문(나는 누구인가 / 왜 기록하는가 / 어떤 아웃풋)에 답하면 `_Core-Context.md`와 루트 `CLAUDE.md`가 채워집니다. → **AI가 "현재의 나"를 이해하는 기준**이 되어, 이후 모든 수집·정리가 내 목적에 맞춰집니다.

## ③ 옵시디언 웹 클리퍼 연결 (수집 자동화)
1. 크롬 웹스토어에서 **Obsidian Web Clipper** 설치 → 확장 고정
2. 웹 클리퍼 우클릭 → Settings → **Templates**

⚠️ 웹 클리퍼는 **템플릿이 1개뿐이면 기본 템플릿을 못 지웁니다.** 그래서 순서대로:
   1. **Import** → `<볼트>/Templates/webclipper/`의 **`Default.json`** 먼저 (템플릿 2개 → 삭제 가능)
   2. 기존 **"기본 템플릿" 삭제** (이게 `Clippings/`로 저장하던 범인)
   3. 나머지 4종 Import: `YouTube` · `Podcast` · `Book` · `Research`
   4. **`LLM Wiki Default`를 맨 위로** → 트리거 안 걸린 일반 페이지의 기본

> 💡 그래도 `Clippings/` 등에 잘못 저장됐으면 **`/llm-wiki normalize`** 한 번이면 전부 Raw로 옮기고 스키마 자동 보정.

## ④ 수집 (Raw)
관심 있는 웹페이지/유튜브/논문에서 웹 클리퍼를 누르면 알맞은 템플릿으로 `Raw/`에 저장됩니다.
저장된 노트의 `purpose`는 비어 있어도 됩니다 — ⑤에서 AI가 "왜 모았는지" 물어봅니다.

## ⑤ 소화 (ingest) — 핵심 단계
```
/llm-wiki ingest
```
AI가: (0) 잘못 저장된 클리핑 정규화 → (1) Raw 신규 소스 읽기 → (2) **"이거 왜 모았어? 어떤 관점?" 인터뷰**(Gold In) → (3) 개념(Concept)·개체(Entity) 추출 → (4) 기존 Wiki 노트와 `[[링크]]`로 연결 → (5) `Wiki/Index`(지식지도)·`Wiki/Log` 갱신.

→ **④~⑤를 반복**할수록 노트들이 서로 연결되며 지식이 복리로 쌓입니다.

## ⑥ 그래프화 (graphify)
```
/llm-wiki graphify          # 또는  /graphify <볼트경로>
```
Wiki를 스캔해 노드(개념·개체)와 엣지(`[[링크]]`·의미 연결)로 **지식 그래프**를 만듭니다.
> 팁: 깔끔한 그래프를 원하면 `.obsidian`·`Templates` 같은 설정은 제외하고 `Wiki/` 중심으로 돌립니다.

---

## 🎯 ⑦ 최종적으로 "무엇을" 보면 되나

만들고 나서 실제로 들여다보는 산출물은 네 가지입니다:

### 1. 옵시디언 안에서 — 평소 지식 확인
- `Wiki/Index/MOC.md` → **지식 지도**. 내 주제가 어떻게 가지를 뻗는지 한눈에.
- `Wiki/Concepts/`·`Wiki/Entities/` → 개념·개체 노트. 각 노트 하단 **"나의 맥락과의 관계"** 가 핵심.
- 옵시디언 좌측 **그래프 뷰** → 노트 연결망을 시각적으로.

### 2. `graphify-out/graph.html` — 인터랙티브 지식 그래프
브라우저로 열어 **커뮤니티(주제 군집)** 와 노드 연결을 탐색:
```bash
open <볼트>/graphify-out/graph.html
```

### 3. `graphify-out/GRAPH_REPORT.md` — 분석 리포트
- **God Nodes**: 가장 많이 연결된 = 내 지식의 핵심 축
- **Surprising Connections**: 내가 몰랐던 연결
- **Suggested Questions**: 이 그래프만이 답할 수 있는 질문들

### 4. 질문해서 답 얻기 — 세컨드 브레인의 진짜 활용
```
/llm-wiki query "내 병목과 FDE 역량은 어떻게 연결되지?"
/graphify query "X와 Y의 근본적 차이는?"      # 그래프 근거(BFS/DFS) 답변
/graphify explain "통합의 벽"                  # 한 개념과 이웃 설명
/graphify path "A" "B"                        # 두 개념 사이 최단 경로
```
→ 벡터 DB 없이 **내 위키·그래프를 근거로** 답합니다. 이 답을 `Synthesis/`에 저장하고, 다시 가공해 `Output/`(글·자료)로 발행합니다.

> ### 📌 실제 예시 (이 가이드를 만든 케이스)
> 1. "FDE는 어떻게 다른가" 아티클을 웹 클리퍼로 `Raw/`에 수집
> 2. `/llm-wiki ingest` → "FDE 성장의 밑바탕으로 모았다"고 답 → AI가 **FDE / FDE 4대 역량 / 통합의 벽** 개념과 **Palantir / Andela** 개체를 만들고 내 핵심 맥락과 연결
> 3. `/llm-wiki graphify` → graph.html에서 **"나(FDE)" 노드가 'LLM Wiki 방법론'과 'FDE 지식' 두 군집을 잇는 교량**으로 보임
> 4. GRAPH_REPORT가 제안한 질문 → `query`로 추적 → 내 병목(정보 구조화·기획)이 FDE 역량 ②③과 직결됨을 확인 → 성장 로드맵으로 정리

---

## 🔁 일상 치트시트

| 명령 | 하는 일 |
|------|---------|
| 웹 클리퍼로 클리핑 | 자료를 `Raw/`에 저장 |
| `/llm-wiki normalize` | 엉뚱한 폴더에 저장된 클리핑을 Raw로 정규화 |
| `/llm-wiki ingest` | Raw 소스를 **왜 모았는지 인터뷰** 후 `Wiki/`로 정리·연결 |
| `/llm-wiki query <질문>` | 위키 근거 답변 |
| `/llm-wiki lint` | 위키 점검·최신화(깨진 링크/중복/인덱스) |
| `/llm-wiki graphify` | 위키를 지식 그래프로 |
| `/graphify query/explain/path` | 그래프 기반 질문·설명·경로 |

## 📁 폴더 구조
```
<볼트>/
  CLAUDE.md         # 나의 핵심 맥락 + 작업 규칙 + 전역 스키마
  _Core-Context.md  # 나는 누구/왜 기록/어떤 아웃풋 (인터뷰 결과)
  Raw/        원천 수집물 (웹클리퍼 저장)
  Wiki/       AI 정리 지식 — Index(지식지도)/ Log/ Concepts/ Entities/
  Synthesis/  질문·연결로 도출한 시사점
  Output/     외부로 내보낼 산출물
  Templates/webclipper/  웹 클리퍼 템플릿(JSON)
  graphify-out/          graphify 결과 (graph.html/json + GRAPH_REPORT.md)
```
각 폴더의 `CLAUDE.md`가 그 폴더의 **스키마(규칙)** 입니다. AI는 이 규칙대로만 정리합니다.

---

## ❓ FAQ / 주의
- **개인정보 없나요?** 이 공유본은 전부 템플릿/placeholder입니다. 인터뷰 답변·수집물은 각자 볼트에만 저장됩니다.
- **graphify 설치가 안 돼요.** PyPI 패키지명은 **`graphifyy`** (y 두 개)입니다. `pip install graphifyy && graphify install` (CLI 명령은 `graphify`). `graphify`(y 하나)는 무관한 패키지이니 주의. 그래프 없이도 ingest/query/lint는 완전히 동작합니다.
- **그래프에 설정 파일이 잔뜩 잡혀요.** `.obsidian`·웹클리퍼 JSON이 노드로 들어간 경우입니다. `Wiki/`만 대상으로 돌리거나 설정 폴더를 제외하세요.
- **기존 볼트에 써도 되나요?** 셋업 스크립트는 비어있지 않은 경로를 거부합니다(덮어쓰기 방지). 새 볼트를 권장합니다.
- **가장 중요한 건?** 도구가 아니라 **나의 목적**입니다. 수집할 때마다 "왜?"를 답하세요.
