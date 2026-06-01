# LLM Wiki — 나만의 AI 세컨드 브레인 (사용 가이드)

안드레 카파시의 **LLM Wiki** 패턴을 그대로 옮긴 셋업입니다.
**옵시디언(지식 베이스) × Claude Code(AI 컴파일러) × LLM Wiki 패턴(스키마) × Graphify(지식 그래프)** 조합으로,
목적 있는 지식 수집 → AI 소화 → **복리처럼 쌓이는 나만의 위키**를 만듭니다.

> 핵심 원칙 **Gold In, Gold Out** — "왜 수집했는지" 말할 수 있는 지식만 위키로 올립니다. 목적 없는 수집은 쓰레기 데이터가 됩니다.

---

## 📦 패키지 구성
```
llm-wiki-share/
├─ skills/llm-wiki/      # Claude Code 스킬 (이걸 설치하면 /llm-wiki 사용 가능)
├─ vault-template/       # 빈 옵시디언 볼트 (인터뷰 전 상태)
├─ install.sh           # 스킬 설치 + 새 볼트 생성 자동화
└─ USAGE.md             # 이 문서
```

## ✅ 사전 준비물
- **옵시디언(Obsidian)** 설치 — https://obsidian.md
- **Claude Code** (CLI/데스크톱/IDE 중 무엇이든)
- (선택) **Python 3** — Graphify 지식 그래프를 쓸 때만 필요

---

## 🚀 설치 — 3단계

### 방법 A. 자동 (권장)
```bash
cd llm-wiki-share
bash install.sh
```
스크립트가 ① 스킬을 `~/.claude/skills/llm-wiki`에 복사하고 ② 새 볼트를 만들고 ③ (선택) graphify 설치까지 안내합니다.

### 방법 B. 수동
```bash
# 1) 스킬 설치
cp -R skills/llm-wiki ~/.claude/skills/llm-wiki

# 2) 새 볼트 생성 (원하는 경로/이름)
bash ~/.claude/skills/llm-wiki/scripts/setup_vault.sh "$HOME/Documents/my-llm-wiki" "My LLM Wiki"

# 3) (선택) 지식 그래프 graphify 설치 — 동의 후 설치 + 검증
bash ~/.claude/skills/llm-wiki/scripts/install_graphify.sh
```
> 빠르게 보고 싶으면 동봉된 `vault-template/`을 그대로 옵시디언에서 열어도 됩니다.
> graphify는 **선택**입니다. 없어도 ingest/query/lint 는 완전히 동작합니다.

### 3) 핵심 맥락 인터뷰
Claude Code에서 볼트 폴더를 연 뒤:
```
/llm-wiki setup
```
3가지 질문(나는 누구인가 / 왜 기록하는가 / 어떤 아웃풋)에 답하면
`_Core-Context.md`와 루트 `CLAUDE.md`가 채워집니다. → AI가 "나"를 이해하는 기준이 됩니다.

### 4) 옵시디언 웹 클리퍼 연결 (지식 수집 자동화)
1. 크롬 웹스토어에서 **Obsidian Web Clipper** 설치 → 확장 프로그램 고정
2. 웹 클리퍼 아이콘 우클릭 → Settings → **Templates**

⚠️ 웹 클리퍼는 **템플릿이 1개뿐이면 기본 템플릿을 못 지웁니다.** 그래서 순서대로:
   1. **Import** → `<볼트>/Templates/webclipper/` 의 **`Default.json`** 먼저 가져오기 (템플릿 2개 → 삭제 가능해짐)
   2. 기존 **"기본 템플릿"** 선택 → **삭제** (이게 `Clippings/`로 저장하던 범인)
   3. 나머지 4종 Import: `YouTube` · `Podcast` · `Book` · `Research`
   4. **`LLM Wiki Default`** 를 목록 **맨 위로** 이동 → 트리거 안 걸린 일반 페이지의 기본이 됨
3. 끝. 우리 템플릿은 모두 `Raw/`에 저장됩니다. 일반 글=Default, 유튜브·논문 등은 트리거로 자동 분류.

> 💡 그래도 `Clippings/` 등에 잘못 저장된 게 있으면 **`/llm-wiki normalize`** 한 번이면 전부 Raw로 옮기고 스키마에 맞게 자동 보정합니다 (안전망).

---

## 🔁 일상 워크플로우

| 명령 | 하는 일 |
|------|---------|
| 웹 클리퍼로 수집 | 아티클·유튜브 등을 `Raw/`에 저장 |
| `/llm-wiki normalize` | 엉뚱한 폴더(Clippings 등)에 저장된 클리핑을 Raw로 옮기고 스키마 자동 보정 |
| `/llm-wiki ingest` | (자동 normalize 후) Raw 소스를 읽고 **왜 모았는지 인터뷰** → `Wiki/`에 개념·개체로 정리·연결 |
| `/llm-wiki query <질문>` | 위키 근거로 답변 (벡터 DB 없는 RAG) |
| `/llm-wiki lint` | 위키 점검·최신화 (깨진 링크/중복/인덱스 정리) |
| `/llm-wiki graphify` | 위키를 지식 그래프로 변환 (graph.json/html/report) |

흐름: **수집(Raw) → 소화(ingest→Wiki) → 통합(Synthesis) → 산출(Output)**

## 📁 폴더 구조
```
<볼트>/
  CLAUDE.md         # 나의 핵심 맥락 + 작업 규칙 + 전역 스키마
  _Core-Context.md  # 나는 누구/왜 기록/어떤 아웃풋 (인터뷰 결과)
  Raw/        원천 수집물 (웹클리퍼 저장)
  Wiki/       AI 정리 지식 — Index/ Log/ Concepts/ Entities/
  Synthesis/  질문·연결로 도출한 시사점
  Output/     외부로 내보낼 산출물
  Templates/webclipper/  웹 클리퍼 템플릿(JSON)
  graphify_out/          Graphify 결과
```
각 폴더의 `CLAUDE.md`가 그 폴더의 **스키마(규칙)** 입니다. AI는 이 규칙대로만 정리합니다.

---

## ❓ FAQ / 주의
- **개인정보 없나요?** 이 공유본은 전부 템플릿/placeholder입니다. 인터뷰 답변은 각자 볼트에만 저장됩니다.
- **Graphify가 안 깔려요.** `pip3 install graphify`가 필요합니다. ⚠️ 단, `graphify` PyPI 패키지가 영상 속 도구와 동일한지는 **미검증**입니다. 설치 전 확인하세요. 그래프 기능 없이도 ingest/query/lint는 완전히 동작합니다.
- **기존 볼트에 써도 되나요?** 셋업 스크립트는 비어있지 않은 경로를 거부합니다(덮어쓰기 방지). 새 볼트를 권장합니다.
- **가장 중요한 건?** 도구가 아니라 **나의 목적**입니다. 수집할 때마다 "왜?"를 답하세요.
