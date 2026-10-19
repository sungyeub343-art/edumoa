$ErrorActionPreference = 'Stop'

$siteUrl = 'https://edumoa.kr'
$lastmod = '2026-10-19'
$ogImage = 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?auto=format&amp;fit=crop&amp;w=1200&amp;h=630&amp;q=80'
$utf8 = New-Object System.Text.UTF8Encoding($false)

# Short: 검색에서 주로 쓰는 지역명, Spots: 제목·설명에 넣는 대표 생활권
# Districts: 'slug|구 이름|소개 문장|대표 생활권'
$areas = @(
  [pscustomobject]@{ Slug = 'suwon-si'; Name = '수원시'; Short = '수원'; Spots = '영통·광교'; Focus = '영통·광교·장안·권선 생활권의 학교별 진도와 시험 일정을 함께 살핍니다.'; Districts = @('gwonseon-gu|권선구|호매실·금곡·권선·세류 생활권의 학교 진도와 학습 이동을 고려합니다.|호매실·금곡·권선','yeongtong-gu|영통구|영통·망포·광교 생활권의 학교별 내신 일정과 학습 목표를 반영합니다.|영통·광교·망포','jangan-gu|장안구|정자·천천·조원·연무 생활권의 학교 진도와 취약 단원을 확인합니다.|정자·조원·천천','paldal-gu|팔달구|인계·매교·화서·우만 생활권의 내신 범위와 학생별 진도를 살핍니다.|인계·화서·매교') },
  [pscustomobject]@{ Slug = 'seongnam-si'; Name = '성남시'; Short = '성남'; Spots = '분당·판교'; Focus = '분당·판교와 수정·중원 지역의 학습 환경을 고려해 학생별 계획을 세웁니다.'; Districts = @('bundang-gu|분당구|분당·판교 생활권의 학교별 진도와 내신 일정을 바탕으로 계획합니다.|분당·판교·서현','sujeong-gu|수정구|위례·신흥·태평·수진 생활권의 학교 일정과 취약 개념을 함께 점검합니다.|위례·신흥·태평','jungwon-gu|중원구|성남·금광·은행·하대원 생활권의 학습 환경과 학생별 진도를 반영합니다.|금광·은행·하대원') },
  [pscustomobject]@{ Slug = 'goyang-si'; Name = '고양시'; Short = '고양'; Spots = '일산·삼송'; Focus = '일산동구·일산서구·덕양구의 학교 진도와 통학 여건에 맞춰 수업을 조정합니다.'; Districts = @('deogyang-gu|덕양구|화정·행신·삼송·원흥 생활권의 학교 진도와 이동 여건을 고려합니다.|화정·삼송·원흥','ilsandong-gu|일산동구|백석·마두·정발산·식사 생활권의 내신 일정과 학습 목표를 반영합니다.|일산·백석·마두','ilsanseo-gu|일산서구|주엽·대화·탄현·가좌 생활권의 학교별 시험 범위와 취약점을 확인합니다.|일산·주엽·대화') },
  [pscustomobject]@{ Slug = 'yongin-si'; Name = '용인시'; Short = '용인'; Spots = '수지·기흥·동백'; Focus = '수지·기흥·처인 지역의 학교별 진도와 학생의 이동 여건을 함께 고려합니다.'; Districts = @('giheung-gu|기흥구|보정·동백·구갈·영덕 생활권의 학교 진도와 학습 목표를 살핍니다.|동백·보정·구갈','suji-gu|수지구|죽전·풍덕천·상현·성복 생활권의 학교별 내신 일정과 진도를 반영합니다.|죽전·상현·성복','cheoin-gu|처인구|김량장·역북·고림과 읍면 지역의 이동 여건과 학교 진도를 고려합니다.|역북·김량장·고림') },
  [pscustomobject]@{ Slug = 'bucheon-si'; Name = '부천시'; Short = '부천'; Spots = '중동·상동'; Focus = '원미·소사·오정 생활권의 내신 일정과 현재 학습 수준을 기준으로 수업합니다.'; Districts = @('sosa-gu|소사구|소사본·범박·옥길·괴안 생활권의 학교 진도와 취약 단원을 점검합니다.|범박·옥길·괴안','ojeong-gu|오정구|원종·고강·오정·삼정 생활권의 학교 일정과 학생별 목표를 반영합니다.|원종·고강·오정','wonmi-gu|원미구|중동·상동·심곡·역곡 생활권의 내신 범위와 현재 학습 수준을 살핍니다.|중동·상동·역곡') },
  [pscustomobject]@{ Slug = 'ansan-si'; Name = '안산시'; Short = '안산'; Spots = '고잔·초지'; Focus = '상록구와 단원구의 학교별 진도 차이를 확인해 필요한 단원부터 정리합니다.'; Districts = @('danwon-gu|단원구|고잔·초지·선부·와동 생활권의 학교별 진도와 내신 일정을 확인합니다.|고잔·초지·선부','sangnok-gu|상록구|본오·사동·성포·일동 생활권의 취약 개념과 학습 목표를 함께 살핍니다.|본오·사동·성포') },
  [pscustomobject]@{ Slug = 'anyang-si'; Name = '안양시'; Short = '안양'; Spots = '평촌·호계'; Focus = '동안구와 만안구의 학습 환경, 학교 일정과 학생의 목표를 함께 반영합니다.'; Districts = @('dongan-gu|동안구|평촌·호계·비산·관양 생활권의 학교별 내신 일정과 진도를 반영합니다.|평촌·호계·관양','manan-gu|만안구|안양·석수·박달 생활권의 학교 진도와 학생별 취약 단원을 확인합니다.|안양·석수·박달') },
  [pscustomobject]@{ Slug = 'namyangju-si'; Name = '남양주시'; Short = '남양주'; Spots = '다산·별내'; Focus = '다산·별내·호평·평내 등 생활권별 이동 시간과 학교 진도를 고려합니다.' },
  [pscustomobject]@{ Slug = 'hwaseong-si'; Name = '화성시'; Short = '화성'; Spots = '동탄·봉담'; Focus = '동탄·병점·향남·봉담 등 넓은 생활권의 수업 가능 시간과 학습 목표를 조율합니다.'; Districts = @('dongtan-gu|동탄구|동탄 생활권의 학교별 진도와 내신 일정, 학생의 학습 목표를 반영합니다.|동탄·반송·청계','manse-gu|만세구|향남·남양·마도·송산 생활권의 이동 여건과 학교 진도를 함께 고려합니다.|향남·남양·송산','byeongjeom-gu|병점구|병점·진안·반월·동탄 서부 생활권의 학교 일정과 취약 단원을 점검합니다.|병점·진안·반월','hyohaeng-gu|효행구|봉담·정남·매송 생활권의 학교별 진도와 수업 가능 시간을 조율합니다.|봉담·정남·매송') },
  [pscustomobject]@{ Slug = 'pyeongtaek-si'; Name = '평택시'; Short = '평택'; Spots = '고덕·비전'; Focus = '비전·고덕·송탄·안중 생활권의 학교 일정과 학생별 진도를 세심하게 확인합니다.' },
  [pscustomobject]@{ Slug = 'uijeongbu-si'; Name = '의정부시'; Short = '의정부'; Spots = '민락·신곡'; Focus = '민락·신곡·호원·가능 생활권의 내신 진도와 취약 단원을 함께 점검합니다.' },
  [pscustomobject]@{ Slug = 'siheung-si'; Name = '시흥시'; Short = '시흥'; Spots = '배곧·목감'; Focus = '배곧·정왕·은행·목감 등 지역별 학교 일정과 학습 환경에 맞춰 계획합니다.' },
  [pscustomobject]@{ Slug = 'paju-si'; Name = '파주시'; Short = '파주'; Spots = '운정·교하'; Focus = '운정·교하·금촌·문산 생활권의 이동 여건과 학교별 진도를 함께 살핍니다.' },
  [pscustomobject]@{ Slug = 'gimpo-si'; Name = '김포시'; Short = '김포'; Spots = '한강신도시·풍무'; Focus = '한강신도시와 사우·풍무·고촌 지역의 학교 진도와 학습 목표를 연결합니다.' },
  [pscustomobject]@{ Slug = 'gwangmyeong-si'; Name = '광명시'; Short = '광명'; Spots = '철산·하안'; Focus = '철산·하안·소하·광명 생활권의 내신 일정과 학생별 취약점을 반영합니다.' },
  [pscustomobject]@{ Slug = 'gwangju-si'; Name = '광주시'; Short = '경기 광주'; Spots = '태전·오포'; Focus = '경안·태전·오포·곤지암 생활권의 이동 여건과 학교 진도를 고려합니다.' },
  [pscustomobject]@{ Slug = 'gunpo-si'; Name = '군포시'; Short = '군포'; Spots = '산본'; Focus = '산본·당동·부곡 생활권의 학교별 시험 범위와 현재 학습 수준을 확인합니다.' },
  [pscustomobject]@{ Slug = 'hanam-si'; Name = '하남시'; Short = '하남'; Spots = '미사·감일'; Focus = '미사·감일·위례·신장 생활권의 학교 진도와 학생의 목표를 함께 반영합니다.' },
  [pscustomobject]@{ Slug = 'osan-si'; Name = '오산시'; Short = '오산'; Spots = '세교'; Focus = '세교·원동·오산 생활권의 학교 일정에 맞춰 개념과 내신 준비를 연결합니다.' },
  [pscustomobject]@{ Slug = 'icheon-si'; Name = '이천시'; Short = '이천'; Spots = '증포·부발'; Focus = '증포·부발·창전과 읍면 지역의 이동 여건을 고려해 꾸준한 학습 계획을 세웁니다.' },
  [pscustomobject]@{ Slug = 'anseong-si'; Name = '안성시'; Short = '안성'; Spots = '공도'; Focus = '공도·아양·대덕과 읍면 지역의 학교 진도, 수업 가능 시간을 함께 조율합니다.' },
  [pscustomobject]@{ Slug = 'uiwang-si'; Name = '의왕시'; Short = '의왕'; Spots = '내손·포일'; Focus = '내손·포일·오전·고천 생활권의 학교 일정과 학습 수준에 맞춰 수업합니다.' },
  [pscustomobject]@{ Slug = 'yangpyeong-gun'; Name = '양평군'; Short = '양평'; Spots = '양평읍'; Focus = '양평읍과 각 면 지역의 이동 거리, 온라인 수업 가능 여부를 함께 고려합니다.' },
  [pscustomobject]@{ Slug = 'yeoju-si'; Name = '여주시'; Short = '여주'; Spots = '여주·가남'; Focus = '여주 도심과 읍면 지역의 학교 진도, 수업 가능 시간에 맞춰 계획을 조정합니다.' },
  [pscustomobject]@{ Slug = 'dongducheon-si'; Name = '동두천시'; Short = '동두천'; Spots = '지행·송내'; Focus = '지행·송내·생연 생활권의 학교별 진도와 취약 단원을 중심으로 학습합니다.' },
  [pscustomobject]@{ Slug = 'gwacheon-si'; Name = '과천시'; Short = '과천'; Spots = '별양·원문'; Focus = '중앙·별양·원문 생활권의 학교 일정과 학생별 목표를 바탕으로 수업합니다.' },
  [pscustomobject]@{ Slug = 'gapyeong-gun'; Name = '가평군'; Short = '가평'; Spots = '가평읍·청평'; Focus = '가평읍과 각 면 지역의 이동 여건을 살피고 대면·온라인 수업을 협의합니다.' },
  [pscustomobject]@{ Slug = 'yeoncheon-gun'; Name = '연천군'; Short = '연천'; Spots = '전곡'; Focus = '전곡·연천과 각 면 지역의 거리, 학교 진도를 고려해 현실적인 계획을 세웁니다.' },
  [pscustomobject]@{ Slug = 'pocheon-si'; Name = '포천시'; Short = '포천'; Spots = '소흘·신읍'; Focus = '소흘·신읍과 읍면 지역의 이동 시간, 학교별 진도를 함께 확인합니다.' },
  [pscustomobject]@{ Slug = 'yangju-si'; Name = '양주시'; Short = '양주'; Spots = '옥정·회천'; Focus = '옥정·회천·고읍·백석 생활권의 학교 일정과 학생의 현재 단계를 반영합니다.' },
  [pscustomobject]@{ Slug = 'guri-si'; Name = '구리시'; Short = '구리'; Spots = '갈매·인창'; Focus = '갈매·인창·수택·교문 생활권의 내신 일정과 취약 개념을 함께 점검합니다.' }
)

# 학교급별 페이지 내용. {P} 지역 검색명, {F} 전체 지역명, {S} 대표 생활권, {Focus} 지역 소개 문장
$levels = @(
  [pscustomobject]@{
    Slug = 'elementary'; Label = '초등'; En = 'ELEMENTARY'; Range = '초1~초6'
    TitleTail = '기초수학·연산·수학공부 1:1'
    Description = '{F} 초등 수학과외. {S} 초등학생 기초수학, 연산, 문장제와 수학공부 습관까지 1:1로 진단하고 수업합니다. 초1~초6 상담 010-2928-3614'
    Card = '초1~초6 기초수학과 연산, 문장제, 스스로 하는 수학공부 습관까지 1:1로 다집니다.'
    Hero = '초등 수학은 빠른 계산보다 수의 원리를 이해하는 경험이 먼저입니다. 왜 그렇게 계산하는지 스스로 설명할 수 있을 때까지 함께 정리합니다.'
    IntroTitle = '수학이 편해지는<br>초등 수학수업'
    Intros = @(
      '{P} 초등 수학과외는 최근 단원평가와 문제집, 평소 숙제 습관을 먼저 확인합니다. 연산 실수인지, 개념을 모르는 것인지, 문장을 식으로 바꾸지 못하는 것인지 구분해야 맞는 수업을 할 수 있습니다.',
      '같은 초등학생이라도 수 감각과 연산 속도, 집중할 수 있는 시간이 모두 다릅니다. {P} 초등 수학과외는 학생이 막히는 지점을 찾아 이전 학년 단원까지 거슬러 올라가 기초수학을 다시 세웁니다.',
      '{P} 초등 수학수업은 정답 개수보다 풀이 과정을 봅니다. 아이가 문제를 어떻게 읽고 어떤 순서로 계산하는지 확인한 뒤 설명 방식과 과제량을 정합니다.'
    )
    IntroFocus = '{Focus} 초등 수학공부는 짧더라도 매일 이어지는 습관이 중요하므로, 수업 뒤 혼자 할 수 있는 분량의 과제와 오답 정리 방법까지 함께 안내합니다.'
    Grades = @(
      '초1 · 초2|{P} 초1·초2 수학과외는 수 세기, 덧셈과 뺄셈, 시계와 길이처럼 생활 속 수 감각을 구체물과 그림으로 익히고 바르게 식을 쓰는 습관을 만듭니다.',
      '초3 · 초4|{P} 초3·초4 수학과외는 곱셈과 나눗셈, 분수의 시작, 평면도형처럼 이후 학년의 바탕이 되는 단원을 다지고 문장제를 식으로 바꾸는 연습을 합니다.',
      '초5 · 초6|{P} 초5·초6 수학과외는 약수와 배수, 분수·소수의 계산, 비와 비율, 입체도형을 정리하며 중학교 문자와 식으로 이어지는 예비중1 과정을 준비합니다.'
    )
    Topics = @(
      '{P} 초등 수학수업|1:1로 진행해 아이가 이해할 때까지 설명의 속도를 조절합니다. 개념 설명, 함께 풀기, 혼자 풀기의 순서로 한 단원을 끝까지 이해하게 합니다.',
      '{P} 초등 수학공부|하루 분량을 정해 꾸준히 하는 것이 핵심입니다. 문제집 진도표와 오답 표시 방법을 정해 집에서도 스스로 공부하는 흐름을 만듭니다.',
      '{P} 초등 기초수학|구구단, 받아올림·받아내림, 분수 개념처럼 자주 흔들리는 기초를 진단해 이전 학년 내용부터 차근차근 보완합니다.',
      '초등 연산 · 문장제|계산은 맞는데 문장제와 서술형에서 막히는 경우가 많습니다. 조건에 표시하고 식으로 옮기는 과정을 반복해 응용 문제에 대한 자신감을 키웁니다.',
      '예비중1 수학|초등 6학년 2학기에는 분수·소수 계산과 비율을 점검하고 정수, 문자와 식을 미리 경험해 중학교 첫 수학 시험을 편안하게 준비합니다.',
      '초등 사고력 · 응용|교과 개념을 충분히 익힌 학생은 응용·심화 문제로 넓혀 여러 방법으로 풀어 보고 풀이를 비교하며 수학적 사고력을 기릅니다.'
    )
    Faqs = @(
      '{P} 초등 수학과외는 몇 학년부터 가능한가요?|초1부터 초6까지 수업합니다. 학년보다 현재 이해 수준이 중요하므로 상담과 진단을 통해 시작 단원을 정합니다.',
      '초등 기초수학이 많이 부족해도 괜찮을까요?|네. 부족한 부분이 어디서 시작됐는지 찾아 이전 학년 단원부터 다시 정리합니다. 기초가 잡히면 현재 학년 진도와 함께 병행합니다.',
      '{P}에서 방문 수업이 가능한가요?|거주 위치와 희망 시간을 확인한 뒤 대면 수업 가능 여부를 안내합니다. 이동이 어려운 경우 온라인 수업도 협의할 수 있습니다.',
      '수업 횟수와 시간은 어떻게 정하나요?|학생의 학년, 집중할 수 있는 시간, 목표와 일정에 맞춰 상담 시 함께 정합니다.'
    )
  },
  [pscustomobject]@{
    Slug = 'middle'; Label = '중등'; En = 'MIDDLE SCHOOL'; Range = '중1~중3'
    TitleTail = '중1·중2·중3 수학내신·기초수학 1:1'
    Description = '{F} 중등 수학과외. {S} 중학생 중1·중2·중3 수학내신, 서술형, 기초수학까지 학교 진도에 맞춰 1:1로 수업합니다. 상담 010-2928-3614'
    Card = '중1·중2·중3 학교별 수학내신과 서술형, 흔들리는 기초수학을 함께 잡습니다.'
    Hero = '중학교 수학은 학년이 올라갈수록 이전 개념이 다음 단원의 도구가 됩니다. 학교 진도와 내신 일정에 맞춰 빈틈을 메우고 서술형까지 정확하게 쓰도록 돕습니다.'
    IntroTitle = '내신과 기초를<br>함께 잡는 중등 수학'
    Intros = @(
      '{P} 중등 수학과외는 최근 학교 시험지와 사용하는 교재를 먼저 살핍니다. 틀린 문제가 개념, 계산, 서술 중 어디에서 나왔는지 구분해 학생에게 필요한 수업 순서를 정합니다.',
      '{P} 중학생은 학교마다 시험 범위와 출제 경향이 달라 같은 학년이라도 준비 방법이 달라야 합니다. 학교 진도와 학생의 이해 속도를 함께 보며 중등 수학수업을 설계합니다.',
      '중학교 수학은 한 단원이 흔들리면 다음 학년까지 영향을 줍니다. {P} 중등 수학과외는 현재 진도를 따라가면서도 비어 있는 이전 단원을 함께 보완합니다.'
    )
    IntroFocus = '{Focus} 시험 4~5주 전부터는 학교 교과서와 프린트, 기출 유형을 중심으로 수학내신을 준비하고, 시험이 끝나면 오답을 분석해 다음 시험 계획을 세웁니다.'
    Grades = @(
      '중1|{P} 중1 수학과외는 소인수분해, 정수와 유리수, 문자와 식, 일차방정식, 좌표평면과 그래프를 다루며 중학교 첫 지필 시험에 필요한 풀이 습관을 만듭니다.',
      '중2|{P} 중2 수학과외는 식의 계산, 연립방정식과 부등식, 일차함수, 도형의 성질과 확률처럼 분량이 늘어나는 단원을 체계적으로 정리하고 서술형 풀이를 연습합니다.',
      '중3|{P} 중3 수학과외는 제곱근과 실수, 인수분해, 이차방정식과 이차함수, 삼각비를 정리하며 고등 수학으로 이어지는 연결 고리를 미리 다집니다.'
    )
    Topics = @(
      '{P} 중등 수학수업|개념 설명 뒤 학생이 직접 풀이를 설명하게 해 이해 여부를 확인합니다. 학교 진도에 맞춰 예습과 복습의 비중을 조절합니다.',
      '{P} 중등 수학공부|문제를 많이 푸는 것보다 틀린 이유를 정리하는 것이 중요합니다. 주간 과제와 오답 정리 방법을 정해 혼자 공부하는 힘을 기릅니다.',
      '{P} 중등 기초수학|정수 계산, 분수 연산, 문자 사용이 흔들리면 중등 수학 전체가 어려워집니다. 초등 과정까지 점검해 필요한 단원부터 다시 세웁니다.',
      '{P} 중등 수학내신|학교별 교과서와 프린트, 기출 유형을 분석해 시험 범위를 빠짐없이 정리하고 실전처럼 시간을 재며 풀어 봅니다.',
      '중등 서술형 대비|풀이 과정을 논리적으로 쓰는 연습을 따로 합니다. 감점되는 표현과 빠뜨리기 쉬운 조건을 짚어 서술형 점수를 안정적으로 만듭니다.',
      '예비고1 · 고등 준비|중3 2학기 이후에는 중학 전 범위의 빈틈을 정리하고, 학생의 상황에 맞춰 고1 공통수학으로 자연스럽게 이어지도록 준비합니다.'
    )
    Faqs = @(
      '{P} 중등 수학과외는 학교 시험 대비도 하나요?|네. 학교별 시험 범위와 교과서, 프린트를 확인해 수학내신 대비를 진행하고 시험 후 오답 분석으로 다음 계획을 세웁니다.',
      '중학생인데 초등 수학부터 부족하면 어떻게 하나요?|진단 결과에 따라 필요한 초등·중등 기초수학 단원을 함께 보완합니다. 현재 학교 진도와 병행해 부담을 줄입니다.',
      '{P}에서 방문 수업이 가능한가요?|거주 위치와 희망 시간을 확인한 뒤 대면 수업 가능 여부를 안내합니다. 이동이 어려운 경우 온라인 수업도 협의할 수 있습니다.',
      '중1·중2·중3 모두 수업하나요?|네. 중1부터 중3까지 학년별 진도와 목표에 맞춰 수업하며, 예비중1과 예비고1 과정도 상담할 수 있습니다.'
    )
  },
  [pscustomobject]@{
    Slug = 'high'; Label = '고등'; En = 'HIGH SCHOOL'; Range = '고1~고3'
    TitleTail = '고1·고2·고3 내신·수능수학 1:1'
    Description = '{F} 고등 수학과외. {S} 고등학생 수학내신, 수능대비, 수능수학과 고등 기초수학까지 1:1로 진단하고 수업합니다. 고1~고3 상담 010-2928-3614'
    Card = '고1·고2·고3 수학내신과 수능대비, 수능수학 실전 훈련까지 우선순위를 세웁니다.'
    Hero = '고등 수학은 내신과 수능, 선택 과목과 입시 일정이 함께 움직입니다. 학생의 현재 위치를 정확히 진단하고 남은 시간 안에서 우선순위를 정해 수업합니다.'
    IntroTitle = '내신부터 수능까지<br>고등 수학의 우선순위'
    Intros = @(
      '{P} 고등 수학과외는 최근 내신 시험지와 모의고사 성적, 사용하는 교재를 함께 확인합니다. 개념 이해, 문제 해석, 계산 정확도 중 어디에서 점수가 빠지는지 찾아 수업 계획을 세웁니다.',
      '{P} 고등학생은 학교마다 선택 과목과 진도, 시험 난이도가 다릅니다. 학교 일정과 목표, 남은 시간을 함께 고려해 내신과 수능 준비의 비중을 정합니다.',
      '고등 수학은 공식을 외우는 것만으로는 점수가 오르지 않습니다. {P} 고등 수학과외는 개념이 문제에서 어떻게 쓰이는지 연결하고, 처음 보는 문제를 해석하는 과정을 훈련합니다.'
    )
    IntroFocus = '{Focus} 내신 기간에는 학교별 기출과 부교재를 중심으로, 내신이 끝난 뒤에는 수능 기출 분석과 취약 단원 보완을 중심으로 수업을 운영합니다.'
    Grades = @(
      '고1|{P} 고1 수학과외는 다항식, 방정식과 부등식, 경우의 수, 행렬, 도형의 방정식, 집합과 명제, 함수처럼 고등 수학 전체의 바탕이 되는 공통수학을 탄탄하게 다집니다.',
      '고2|{P} 고2 수학과외는 학교에서 배우는 선택 과목의 진도와 내신을 중심으로 지수·로그, 삼각함수, 수열, 미분과 적분 등 수능과 이어지는 핵심 단원을 정리합니다.',
      '고3|{P} 고3 수학과외는 마지막 내신 관리와 함께 수능수학 기출 분석, 시간 배분, 실전 모의 훈련으로 남은 기간의 점수 향상에 집중합니다.'
    )
    Topics = @(
      '{P} 고등 수학수업|학생이 풀이 과정을 직접 설명하며 개념을 확인합니다. 학교 진도, 내신 일정, 모의고사 결과를 함께 보며 매주 수업 방향을 조정합니다.',
      '{P} 고등 수학공부|공부 시간보다 방법이 중요합니다. 개념 복습, 유형 연습, 오답 재풀이의 비율을 정해 혼자 공부하는 시간까지 효율적으로 설계합니다.',
      '{P} 고등 기초수학|중학 수학의 빈틈 때문에 고등 수학이 어려운 학생은 인수분해, 방정식, 함수 등 필요한 중등 단원부터 다시 정리한 뒤 고등 진도로 연결합니다.',
      '{P} 고등 수학내신|학교별 교과서, 부교재, 기출 문제를 분석해 출제 경향에 맞춰 준비하고 고난도 문항과 서술형까지 대비합니다.',
      '{P} 고등 수능대비|모의고사 결과로 취약 단원을 찾고 기출 문제를 단원별, 난이도별로 풀어 보며 실전 감각을 기릅니다.',
      '고등 수능수학|정해진 시간 안에 정확하게 푸는 힘이 필요합니다. 문항별 시간 배분, 검토 습관, 고난도 문항 접근법을 훈련해 실전 점수를 안정시킵니다.'
    )
    Faqs = @(
      '수학 기초가 부족한 고등학생도 수업할 수 있나요?|네. 진단 후 필요한 중등 단원부터 고등 기초수학을 함께 보완하고 현재 학교 진도와 병행합니다.',
      '내신과 수능 중 무엇을 먼저 준비해야 하나요?|학년, 목표, 학교 일정에 따라 다릅니다. 상담에서 현재 성적과 목표를 확인해 시기별로 내신과 수능대비의 비중을 정합니다.',
      '{P}에서 방문 수업이 가능한가요?|거주 위치와 희망 시간을 확인한 뒤 대면 수업 가능 여부를 안내합니다. 이동이 어려운 경우 온라인 수업도 협의할 수 있습니다.',
      '수능수학 대비는 언제부터 시작하면 좋을까요?|고1·고2부터 내신 공부와 함께 수능 기출 유형을 경험하면 고3의 부담이 줄어듭니다. 고3은 남은 기간에 맞춰 기출과 실전 훈련 위주로 진행합니다.'
    )
  }
)

$regionFaqs = @(
  '{P} 수학과외는 어떤 학생이 수업하나요?|초등학생부터 중학생, 고등학생까지 수업합니다. 예비중1부터 예비고3까지 다음 학년을 준비하는 과정도 상담할 수 있습니다.',
  '첫 수업 전에 무엇을 확인하나요?|최근 시험지와 사용 중인 교재, 평소 공부 시간과 목표를 확인해 취약점을 진단하고 수업 계획을 세웁니다.',
  '{P}에서 방문 수업이 가능한가요?|거주 위치와 희망 시간을 확인한 뒤 대면 수업 가능 여부를 안내합니다. 이동이 어려운 경우 온라인 수업도 협의할 수 있습니다.',
  '상담은 어떻게 신청하나요?|010-2928-3614로 전화 주시면 학생의 학년과 고민을 듣고 수업 방향을 안내해 드립니다.'
)

$lessonFlow = @"
      <section class="lesson-flow" aria-labelledby="flow-title">
        <p class="section-number">LESSON FLOW</p><h2 id="flow-title">진단에서 복습까지</h2>
        <ol><li><strong>학습 상담</strong><span>학년과 목표, 최근 고민을 확인합니다.</span></li><li><strong>취약점 진단</strong><span>개념·풀이·계산 중 막힌 지점을 찾습니다.</span></li><li><strong>맞춤 수업</strong><span>학교 진도와 학생 속도에 맞춰 설명합니다.</span></li><li><strong>주간 점검</strong><span>오답과 과제를 바탕으로 계획을 조정합니다.</span></li></ol>
      </section>
"@

$pages = [System.Collections.Generic.List[object]]::new()
$script:variantIndex = 0

function Write-Utf8File([string]$Path, [string]$Content) {
    $directory = Split-Path -Parent $Path
    if (-not (Test-Path $directory)) { New-Item -ItemType Directory -Path $directory -Force | Out-Null }
    [System.IO.File]::WriteAllText($Path, $Content, $utf8)
}

function Fill([string]$Text, $Place) {
    return $Text.Replace('{P}', $Place.P).Replace('{F}', $Place.F).Replace('{N}', $Place.N).Replace('{S}', $Place.S).Replace('{Focus}', $Place.Focus)
}

function Get-Root([string]$Path) {
    $depth = @($Path.Split('/') | Where-Object { $_ }).Count
    return ((1..$depth | ForEach-Object { '..' }) -join '/')
}

function Expand-Faqs($Raw, $Place) {
    return @($Raw | ForEach-Object { $parts = (Fill $_ $Place).Split('|'); [pscustomobject]@{ Q = $parts[0]; A = $parts[1] } })
}

function Get-FaqHtml([string]$Heading, $Faqs) {
    $items = $Faqs | ForEach-Object { "          <details><summary>$($_.Q)</summary><p>$($_.A)</p></details>" }
    return @"
      <section class="faq" aria-labelledby="faq-title">
        <p class="section-number">FAQ</p><h2 id="faq-title">$Heading</h2>
        <div class="faq-list">
$($items -join "`n")
        </div>
      </section>
"@
}

function Get-FaqLd($Faqs) {
    return [ordered]@{ '@type' = 'FAQPage'; mainEntity = @($Faqs | ForEach-Object { [ordered]@{ '@type' = 'Question'; name = $_.Q; acceptedAnswer = [ordered]@{ '@type' = 'Answer'; text = $_.A } } }) }
}

function Get-ServiceLd([string]$Name, [string]$Description, [string]$Area, [string]$Path) {
    return [ordered]@{
        '@type' = 'Service'; name = $Name; serviceType = '수학과외'; url = "$siteUrl/$Path"; description = $Description
        provider = [ordered]@{ '@type' = 'EducationalOrganization'; name = '경기 수학과외'; url = "$siteUrl/"; telephone = '+82-10-2928-3614' }
        areaServed = [ordered]@{ '@type' = 'AdministrativeArea'; name = $Area }
    }
}

# Links: Path(사이트 루트 기준), Text
function Get-LinkGrid([string]$Id, [string]$Label, [string]$Heading, $Links, [string]$Root) {
    $items = $Links | ForEach-Object { "          <a href=`"$Root/$($_.Path)`"><span>$($_.Text)</span><span aria-hidden=`"true`">→</span></a>" }
    return @"
      <section class="local-list" aria-labelledby="$Id">
        <p class="section-number">$Label</p><h2 id="$Id">$Heading</h2>
        <div class="area-links">
$($items -join "`n")
        </div>
      </section>
"@
}

function Get-LevelCards($Place) {
    $cards = $levels | ForEach-Object {
        "          <a class=`"level-card`" href=`"$($_.Slug)/`"><span class=`"level-badge`">$($_.Range)</span><h3>$($Place.P) $($_.Label) 수학과외</h3><p>$(Fill $_.Card $Place)</p><span class=`"level-more`">자세히 보기 →</span></a>"
    }
    return @"
      <section class="level-guide" aria-labelledby="level-title">
        <p class="section-number">SCHOOL LEVEL</p><h2 id="level-title">$($Place.P) 초등·중등·고등<br>수학과외</h2>
        <div class="level-cards">
$($cards -join "`n")
        </div>
      </section>
"@
}

function Write-Page {
    param([string]$Path, [string]$Title, [string]$Description, $Crumbs, [string]$Eyebrow, [string]$Heading, [string]$Hero, [string]$Body, [string]$CtaTitle, $Graph)
    $root = Get-Root $Path
    $canonical = "$siteUrl/$Path"

    $crumbParts = @()
    $crumbItems = @()
    for ($i = 0; $i -lt $Crumbs.Count; $i++) {
        $crumb = $Crumbs[$i]
        if ($i -eq $Crumbs.Count - 1) { $crumbParts += "<strong>$($crumb.Name)</strong>" } else { $crumbParts += "<a href=`"$root/$($crumb.Path)`">$($crumb.Name)</a>" }
        $crumbItems += [ordered]@{ '@type' = 'ListItem'; position = $i + 1; name = $crumb.Name; item = "$siteUrl/$($crumb.Path)" }
    }
    $breadcrumbLd = [ordered]@{ '@type' = 'BreadcrumbList'; itemListElement = $crumbItems }
    $ld = [ordered]@{ '@context' = 'https://schema.org'; '@graph' = @(@($breadcrumbLd) + @($Graph)) }
    $json = ConvertTo-Json -InputObject $ld -Depth 12 -Compress

    $html = @"
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>$Title</title>
  <meta name="description" content="$Description">
  <meta name="naver-site-verification" content="050bf0bd63259510b4235941a5eba51d1bc56f7a">
  <meta name="google-site-verification" content="mp9AG8O31zZiZPC730xmcZrV1MZHnuJm0fWYdXh7lxY">
  <meta name="robots" content="index, follow, max-image-preview:large">
  <meta name="theme-color" content="#123c43">
  <meta property="og:type" content="website">
  <meta property="og:site_name" content="경기 수학과외">
  <meta property="og:locale" content="ko_KR">
  <meta property="og:title" content="$Title">
  <meta property="og:description" content="$Description">
  <meta property="og:url" content="$canonical">
  <meta property="og:image" content="$ogImage">
  <meta name="twitter:card" content="summary_large_image">
  <link rel="canonical" href="$canonical">
  <link rel="alternate" type="application/rss+xml" title="경기 수학과외" href="$siteUrl/rss.xml">
  <link rel="icon" href="$root/favicon.svg" type="image/svg+xml">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@700&family=Pretendard:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="$root/styles.css">
  <script type="application/ld+json">$json</script>
</head>
<body class="location-page">
  <a class="skip-link" href="#main">본문으로 바로가기</a>
  <header class="site-header">
    <a class="brand" href="$root/" aria-label="경기 수학과외 홈"><span class="brand-mark" aria-hidden="true">∑</span><span>경기 수학과외</span></a>
    <nav class="desktop-nav" aria-label="주요 메뉴"><a href="$root/elementary/">초등 수학</a><a href="$root/middle/">중등 수학</a><a href="$root/high/">고등 수학</a><a href="$root/#area">수업 지역</a></nav>
    <a class="header-cta" href="tel:010-2928-3614" aria-label="010-2928-3614로 전화하기">010-2928-3614</a>
  </header>
  <main class="location-main" id="main">
    <section class="location-hero">
      <nav class="breadcrumbs" aria-label="현재 위치">$($crumbParts -join '<span>/</span>')</nav>
      <p class="eyebrow">$Eyebrow</p>
      <h1>$Heading</h1>
      <p>$Hero</p>
    </section>
    <div class="location-layout">
$Body
      <section class="location-cta"><div><p class="section-number">CONTACT</p><h2>$CtaTitle</h2></div><div class="cta-actions"><a class="button" href="tel:010-2928-3614">전화 상담 010-2928-3614</a></div></section>
    </div>
  </main>
  <footer><a class="brand footer-brand" href="$root/"><span class="brand-mark" aria-hidden="true">∑</span><span>경기 수학과외</span></a><p>학생의 이해에서 시작하는 1:1 맞춤 수업</p><nav class="footer-links" aria-label="학교급별 수학과외"><a href="$root/elementary/">경기 초등 수학과외</a><a href="$root/middle/">경기 중등 수학과외</a><a href="$root/high/">경기 고등 수학과외</a><a href="tel:010-2928-3614">전화 상담 010-2928-3614</a></nav><p class="copyright">© 2026 경기 수학과외</p></footer>
</body>
</html>
"@
    Write-Utf8File (Join-Path $PSScriptRoot ($Path.Replace('/', '\') + 'index.html')) $html
    $pages.Add([pscustomobject]@{ Url = $canonical; Title = $Title; Description = $Description })
}

function Write-LevelPage($Place, $Level, $Related, [string]$RelatedHeading) {
    $path = "$($Place.Path)$($Level.Slug)/"
    $p = $Place.P
    $name = "$p $($Level.Label) 수학과외"
    $title = "$name | $($Level.TitleTail)"
    $description = Fill $Level.Description $Place
    $intro = Fill $Level.Intros[$script:variantIndex % $Level.Intros.Count] $Place
    $script:variantIndex++
    $faqs = Expand-Faqs $Level.Faqs $Place
    $grades = $Level.Grades | ForEach-Object { $g = (Fill $_ $Place).Split('|'); "          <article><h3>$($g[0]) 수학과외</h3><p>$($g[1])</p></article>" }
    $topics = $Level.Topics | ForEach-Object { $t = (Fill $_ $Place).Split('|'); "          <article><h3>$($t[0])</h3><p>$($t[1])</p></article>" }
    $relatedHtml = Get-LinkGrid 'related-title' 'RELATED' $RelatedHeading $Related (Get-Root $path)
    $body = @"
      <section class="location-intro" aria-labelledby="intro-title">
        <div><p class="section-number">$($Level.En)</p><h2 id="intro-title">$($Level.IntroTitle)</h2></div>
        <div class="location-intro-copy"><p>$intro</p><p>$(Fill $Level.IntroFocus $Place)</p></div>
      </section>
      <section class="grade-guide" aria-labelledby="grade-title">
        <p class="section-number">GRADE GUIDE</p><h2 id="grade-title">$p 학년별<br>$($Level.Label) 수학과외</h2>
        <div class="grade-grid grade-grid-3">
$($grades -join "`n")
        </div>
      </section>
      <section class="topic-guide" aria-labelledby="topic-title">
        <p class="section-number">CURRICULUM</p><h2 id="topic-title">$p $($Level.Label) 수학수업<br>무엇을 배우나요</h2>
        <div class="topic-grid">
$($topics -join "`n")
        </div>
      </section>
$lessonFlow
$(Get-FaqHtml "$name 자주 묻는 질문" $faqs)
$relatedHtml
"@
    $crumbs = @($Place.Crumbs) + @([pscustomobject]@{ Name = "$($Level.Label) 수학과외"; Path = $path })
    $graph = @((Get-ServiceLd $name $description $Place.F $path), (Get-FaqLd $faqs))
    Write-Page -Path $path -Title $title -Description $description -Crumbs $crumbs -Eyebrow "$($Place.Eyebrow) · $($Level.En)" -Heading "$p $($Level.Label)<br>수학과외" -Hero (Fill $Level.Hero $Place) -Body $body -CtaTitle "$name 상담" -Graph $graph
}

function Get-OtherLevelLinks($Place, $Level) {
    $links = @($levels | Where-Object { $_.Slug -ne $Level.Slug } | ForEach-Object { [pscustomobject]@{ Path = "$($Place.Path)$($_.Slug)/"; Text = "$($Place.P) $($_.Label) 수학과외" } })
    return $links
}

$homeCrumb = [pscustomobject]@{ Name = '경기도'; Path = '' }
$pages.Add([pscustomobject]@{ Url = "$siteUrl/"; Title = '경기 수학과외 | 초등·중등·고등 1:1 맞춤 수학 과외'; Description = '경기도 31개 시군 초등·중등·고등 1:1 수학과외. 초등 기초수학, 중등 수학내신, 고등 수능수학까지 현재 실력을 진단하고 학습 계획을 세웁니다.' })

# 경기 전체 학교급 허브 페이지
$gyeonggi = [pscustomobject]@{ P = '경기'; F = '경기도'; N = '경기도'; S = '수원·성남·용인·고양·화성'; Focus = '경기도 31개 시·군 학생의 거주 지역과 학교 진도, 수업 가능 시간을 함께 고려합니다.'; Path = ''; Eyebrow = 'GYEONGGI'; Crumbs = @($homeCrumb) }
foreach ($level in $levels) {
    $related = @(Get-OtherLevelLinks $gyeonggi $level) + @($areas | ForEach-Object { [pscustomobject]@{ Path = "areas/$($_.Slug)/$($level.Slug)/"; Text = "$($_.Short) $($level.Label) 수학과외" } })
    Write-LevelPage $gyeonggi $level $related "지역별 $($level.Label) 수학과외"
}

foreach ($area in $areas) {
    $cityPath = "areas/$($area.Slug)/"
    $city = [pscustomobject]@{ P = $area.Short; F = "경기 $($area.Name)"; N = $area.Name; S = $area.Spots; Focus = $area.Focus; Path = $cityPath; Eyebrow = "GYEONGGI · $($area.Name)"; Crumbs = @($homeCrumb, [pscustomobject]@{ Name = $area.Name; Path = $cityPath }) }
    $districts = @()
    if ($area.PSObject.Properties.Name -contains 'Districts') {
        $districts = @($area.Districts | ForEach-Object {
            $parts = $_.Split('|')
            $districtPath = "$cityPath$($parts[0])/"
            [pscustomobject]@{ Slug = $parts[0]; P = $parts[1]; F = "$($area.Name) $($parts[1])"; N = $parts[1]; S = $parts[3]; Focus = $parts[2]; Path = $districtPath; Eyebrow = "GYEONGGI · $($area.Name) · $($parts[1])"; Crumbs = @($city.Crumbs) + @([pscustomobject]@{ Name = $parts[1]; Path = $districtPath }) }
        })
    }

    # 시·군 페이지
    $cityFaqs = Expand-Faqs $regionFaqs $city
    $districtSection = ''
    if ($districts.Count -gt 0) {
        $districtSection = Get-LinkGrid 'district-title' 'DISTRICT GUIDE' "$($area.Name) 구별 수학과외" @($districts | ForEach-Object { [pscustomobject]@{ Path = $_.Path; Text = "$($_.N) 수학과외" } }) '../..'
    }
    $cityBody = @"
      <section class="location-intro" aria-labelledby="intro-title">
        <div><p class="section-number">LOCAL TUTORING</p><h2 id="intro-title">학교 진도와<br>학생의 속도를 함께</h2></div>
        <div class="location-intro-copy"><p>경기 $($area.Name) 수학과외는 최근 시험지와 사용하는 교재, 평소 공부 시간을 확인하는 진단에서 시작합니다. 같은 학년이라도 개념의 빈틈과 목표가 다르므로 설명 방식과 과제량을 학생별로 조정합니다.</p><p>$($area.Short) 초등 수학의 개념과 연산, 중등 수학내신의 서술형 풀이, 고등 수학의 개념 연결과 수능수학 문제 해석까지 지금 필요한 단계에 집중합니다.</p><p>$($area.Focus) 대면 수업 가능 여부와 시간은 상담 후 안내하며, 학습 상황에 따라 온라인 수업도 협의할 수 있습니다.</p></div>
      </section>
$(Get-LevelCards $city)
      <section class="grade-guide" aria-labelledby="grade-title">
        <p class="section-number">GRADE TRANSITION</p>
        <h2 id="grade-title">다음 학년의 수학을<br>한발 먼저 준비합니다</h2>
        <div class="grade-grid">
          <article><h3>예비중1</h3><p>$($area.Name) 예비중1 수학과외는 초등 연산과 분수·소수, 문장제의 빈틈을 확인하고 문자와 식을 자연스럽게 받아들일 기초를 만듭니다.</p></article>
          <article><h3>예비중2 · 예비중3</h3><p>예비중2는 방정식과 함수의 연결을, 예비중3은 고등 수학으로 이어지는 식의 계산과 도형 개념을 중심으로 이전 학년의 빈틈을 정리합니다.</p></article>
          <article><h3>예비고1</h3><p>$($area.Name) 예비고1은 중학 수학 전 범위에서 고등 과정의 바탕이 되는 대수, 함수, 도형을 점검하고 풀이 과정을 쓰는 습관을 다집니다.</p></article>
          <article><h3>예비고2 · 예비고3</h3><p>예비고2와 예비고3은 선택 과목, 학교별 진도, 내신과 수능 목표를 함께 살펴 우선순위를 정하고 실전 문제 해석력을 높입니다.</p></article>
        </div>
      </section>
$lessonFlow
$districtSection
$(Get-FaqHtml "$($area.Short) 수학과외 자주 묻는 질문" $cityFaqs)
"@
    $cityTitle = "$($area.Short) 수학과외 | $($area.Spots) 초등·중등·고등 1:1 맞춤 수업"
    $cityDescription = "$($city.F) 수학과외. $($area.Spots) 초등 기초수학, 중등 수학내신, 고등 수능수학까지 학생별 진단 후 1:1로 수업합니다. 예비중1~예비고3 상담 010-2928-3614"
    Write-Page -Path $cityPath -Title $cityTitle -Description $cityDescription -Crumbs $city.Crumbs -Eyebrow $city.Eyebrow -Heading "$($area.Name)<br>수학과외" -Hero $area.Focus -Body $cityBody -CtaTitle "$($area.Short) 수학과외 상담" -Graph @((Get-ServiceLd "$($area.Short) 수학과외" $cityDescription $city.F $cityPath), (Get-FaqLd $cityFaqs))

    foreach ($level in $levels) {
        $related = @(Get-OtherLevelLinks $city $level) + @([pscustomobject]@{ Path = $cityPath; Text = "$($area.Short) 수학과외" })
        if ($districts.Count -gt 0) {
            $related += @($districts | ForEach-Object { [pscustomobject]@{ Path = "$($_.Path)$($level.Slug)/"; Text = "$($_.N) $($level.Label) 수학과외" } })
        } else {
            $related += [pscustomobject]@{ Path = "$($level.Slug)/"; Text = "경기 $($level.Label) 수학과외" }
        }
        Write-LevelPage $city $level $related "함께 찾는 $($area.Short) 수학과외"
    }

    # 구 페이지
    foreach ($district in $districts) {
        $districtFaqs = Expand-Faqs $regionFaqs $district
        $nearby = @($districts | Where-Object { $_.Slug -ne $district.Slug } | ForEach-Object { [pscustomobject]@{ Path = $_.Path; Text = "$($_.N) 수학과외" } }) + @([pscustomobject]@{ Path = $cityPath; Text = "$($area.Short) 수학과외" })
        $districtBody = @"
      <section class="location-intro" aria-labelledby="intro-title">
        <div><p class="section-number">LOCAL TUTORING</p><h2 id="intro-title">가까운 곳에서<br>꾸준히 배우는 수학</h2></div>
        <div class="location-intro-copy"><p>경기 $($area.Name) $($district.N) 수학과외는 최근 시험지와 교재, 평소 공부 습관을 먼저 확인합니다. 정답 개수만 보지 않고 개념 이해, 풀이 순서, 계산 습관 중 어디에서 막혔는지 구분해 수업 계획을 세웁니다.</p><p>$($district.S) 초등 기초수학부터 중등 수학내신, 고등 수능대비까지 학생의 학년과 목표에 맞춰 수업합니다.</p><p>$($district.Focus) 대면 수업 가능 여부와 시간은 학생의 학년과 위치에 따라 상담 후 안내하며 온라인 수업도 협의할 수 있습니다.</p></div>
      </section>
$(Get-LevelCards $district)
      <section class="grade-guide" aria-labelledby="grade-title">
        <p class="section-number">GRADE TRANSITION</p><h2 id="grade-title">다음 학년의 수학을<br>한발 먼저 준비합니다</h2>
        <div class="grade-grid">
          <article><h3>예비중1</h3><p>$($district.N) 예비중1은 초등 연산과 문장제의 빈틈을 확인하고 중학교 문자와 식의 기초를 준비합니다.</p></article>
          <article><h3>예비중2 · 예비중3</h3><p>예비중2와 예비중3은 다음 학년에 이어지는 방정식·함수·도형 개념과 이전 과정의 빈틈을 정리합니다.</p></article>
          <article><h3>예비고1</h3><p>$($district.N) 예비고1은 고등 수학의 바탕이 되는 중학 대수, 함수, 도형을 우선 점검합니다.</p></article>
          <article><h3>예비고2 · 예비고3</h3><p>예비고2와 예비고3은 선택 과목과 학교 진도, 내신·수능 목표에 맞춰 학습 순서를 구체화합니다.</p></article>
        </div>
      </section>
$(Get-LinkGrid 'nearby-title' 'NEARBY DISTRICT' "$($area.Name) 다른 구 수학과외" $nearby '../../..')
$(Get-FaqHtml "$($district.N) 수학과외 자주 묻는 질문" $districtFaqs)
"@
        $districtTitle = "$($district.N) 수학과외 | $($district.S) 초등·중등·고등 1:1 수업"
        $districtDescription = "$($district.F) 수학과외. $($district.S) 초등 기초수학, 중등 수학내신, 고등 수능수학까지 1:1 진단 후 맞춤 수업합니다. 상담 010-2928-3614"
        Write-Page -Path $district.Path -Title $districtTitle -Description $districtDescription -Crumbs $district.Crumbs -Eyebrow $district.Eyebrow -Heading "$($district.N)<br>수학과외" -Hero $district.Focus -Body $districtBody -CtaTitle "$($district.N) 수학과외 상담" -Graph @((Get-ServiceLd "$($district.N) 수학과외" $districtDescription $district.F $district.Path), (Get-FaqLd $districtFaqs))

        foreach ($level in $levels) {
            $related = @(Get-OtherLevelLinks $district $level) + @([pscustomobject]@{ Path = $district.Path; Text = "$($district.N) 수학과외" }, [pscustomobject]@{ Path = "$cityPath$($level.Slug)/"; Text = "$($area.Short) $($level.Label) 수학과외" })
            $related += @($districts | Where-Object { $_.Slug -ne $district.Slug } | ForEach-Object { [pscustomobject]@{ Path = "$($_.Path)$($level.Slug)/"; Text = "$($_.N) $($level.Label) 수학과외" } })
            Write-LevelPage $district $level $related "함께 찾는 $($district.N) 수학과외"
        }
    }
}

$sitemapEntries = $pages | ForEach-Object { "  <url><loc>$($_.Url)</loc><lastmod>$lastmod</lastmod></url>" }
$sitemap = @"
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
$($sitemapEntries -join "`n")
</urlset>
"@
Write-Utf8File (Join-Path $PSScriptRoot 'sitemap.xml') $sitemap

$pubDate = ([datetime]::ParseExact($lastmod, 'yyyy-MM-dd', $null)).ToString('ddd, dd MMM yyyy', [System.Globalization.CultureInfo]::InvariantCulture) + ' 09:00:00 +0900'
$rssItems = $pages | ForEach-Object { "    <item><title>$($_.Title)</title><link>$($_.Url)</link><guid>$($_.Url)</guid><description>$($_.Description)</description><pubDate>$pubDate</pubDate></item>" }
$rss = @"
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
  <channel>
    <title>경기 수학과외</title>
    <link>$siteUrl/</link>
    <description>경기도 초등·중등·고등 1:1 맞춤 수학과외 지역별 안내</description>
    <language>ko</language>
    <lastBuildDate>$pubDate</lastBuildDate>
$($rssItems -join "`n")
  </channel>
</rss>
"@
Write-Utf8File (Join-Path $PSScriptRoot 'rss.xml') $rss

Write-Output "Generated $($pages.Count - 1) pages (sitemap and rss include the homepage)."
