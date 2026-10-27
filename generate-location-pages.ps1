$ErrorActionPreference = 'Stop'

$siteUrl = 'https://edumoa.kr'
$lastmod = '2026-10-27'
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

# 학교 목록: tools/extract-schools.py로 만든 data/gyeonggi-schools.csv (City, District, Level, Name, BaseDate)
$schoolIndex = @{}
$schoolBaseDate = ''
foreach ($row in (Import-Csv -Path (Join-Path $PSScriptRoot 'data\gyeonggi-schools.csv') -Encoding UTF8)) {
    $key = "$($row.City)|$($row.District)|$($row.Level)"
    if (-not $schoolIndex.ContainsKey($key)) { $schoolIndex[$key] = [System.Collections.Generic.List[string]]::new() }
    $schoolIndex[$key].Add($row.Name)
    $schoolBaseDate = $row.BaseDate
}
$schoolLevelNames = @{ elementary = '초등학교'; middle = '중학교'; high = '고등학교' }
$schoolLevelNotes = @{
    '초등학교' = '교과서 진도와 단원평가 일정'
    '중학교' = '시험 범위와 교과서·프린트, 서술형 출제 경향'
    '고등학교' = '선택 과목과 내신 기출, 모의고사 일정'
}

# Districts: 구 이름 목록 (구가 없는 시·군은 @(''))
function Get-SchoolSection($Place, [string]$City, $Districts, $LevelNames) {
    $total = @()
    $blocks = @()
    foreach ($levelName in $LevelNames) {
        $groups = @($Districts | ForEach-Object {
            $key = "$City|$_|$levelName"
            if ($schoolIndex.ContainsKey($key)) { [pscustomobject]@{ District = $_; Names = @($schoolIndex[$key]) } }
        })
        $count = ($groups | ForEach-Object { $_.Names.Count } | Measure-Object -Sum).Sum
        if (-not $count) { continue }
        $total += "$levelName $($count)곳"
        $lists = $groups | ForEach-Object {
            $items = ($_.Names | ForEach-Object { "<li>$_</li>" }) -join ''
            if ($Districts.Count -gt 1) { "          <h4>$($_.District) $levelName</h4><ul class=`"school-list`">$items</ul>" } else { "          <ul class=`"school-list`">$items</ul>" }
        }
        $blocks += @"
        <div class="school-group">
          <h3>$($Place.P) $levelName 수학과외 <span>$($count)곳</span></h3>
$($lists -join "`n")
        </div>
"@
    }
    if ($blocks.Count -eq 0) { return '' }
    $notes = if ($LevelNames.Count -gt 1) { '진도와 시험 범위' } else { $schoolLevelNotes[$LevelNames[0]] }
    $heading = if ($LevelNames.Count -gt 1) { "$($Place.P) 초·중·고등학교<br>수학과외" } else { "$($Place.P) $($LevelNames[0])<br>수학과외" }
    return @"
      <section class="school-guide" aria-labelledby="school-title">
        <p class="section-number">SCHOOLS</p><h2 id="school-title">$heading</h2>
        <p class="school-note">$($Place.F)에는 $($total -join ', ')이 있습니다. 학생이 다니는 학교의 $($notes)을 확인해 수업을 계획하며, 수업 가능 여부는 거주 위치와 시간을 확인한 뒤 안내합니다.</p>
$($blocks -join "`n")
        <p class="school-source">학교 목록 출처: 전국초중등학교위치표준데이터 ($schoolBaseDate 기준)</p>
      </section>
"@
}

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
  <link rel="icon" href="$root/favicon.ico" sizes="48x48">
  <link rel="icon" href="$root/favicon.svg" type="image/svg+xml">
  <link rel="apple-touch-icon" href="$root/apple-touch-icon.png">
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
  <footer><a class="brand footer-brand" href="$root/"><span class="brand-mark" aria-hidden="true">∑</span><span>경기 수학과외</span></a><p>학생의 이해에서 시작하는 1:1 맞춤 수업</p><nav class="footer-links" aria-label="학교급별 수학과외"><a href="$root/elementary/">경기 초등 수학과외</a><a href="$root/middle/">경기 중등 수학과외</a><a href="$root/high/">경기 고등 수학과외</a><a href="$root/visiting/">수학 방문과외</a><a href="$root/online/">온라인 수학과외</a><a href="$root/towns/">신도시 수학과외</a><a href="tel:010-2928-3614">전화 상담 010-2928-3614</a></nav><p class="copyright">© 2026 경기 수학과외</p></footer>
</body>
</html>
"@
    Write-Utf8File (Join-Path $PSScriptRoot ($Path.Replace('/', '\') + 'index.html')) $html
    $pages.Add([pscustomobject]@{ Url = $canonical; Title = $Title; Description = $Description })
}

function Write-LevelPage($Place, $Level, $Related, [string]$RelatedHeading, [string]$Schools = '') {
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
$Schools
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

# 신도시·생활권 페이지: 'slug|이름|상위 지역 경로|제목용 생활권|소개 문장'
$towns = @(
  'gwanggyo|광교|areas/suwon-si/yeongtong-gu/|광교신도시|광교는 수원 영통구·팔달구와 용인 수지구에 걸쳐 있어 같은 생활권이라도 다니는 학교와 시험 일정이 다를 수 있습니다. 학생이 다니는 학교의 진도와 시험 범위를 먼저 확인합니다.',
  'dongtan|동탄|areas/hwaseong-si/dongtan-gu/|동탄신도시|동탄은 1·2신도시로 생활권이 넓고 학교마다 진도와 출제 경향이 다양합니다. 거주 위치와 수업 가능 시간을 함께 확인해 대면 또는 온라인 수업을 안내합니다.',
  'pangyo|판교|areas/seongnam-si/bundang-gu/|판교·백현·삼평|판교·백현·삼평·운중 생활권 학생의 학교 진도와 목표를 확인해, 다음 학년 진도보다 현재 학년 개념의 완성도를 먼저 점검합니다.',
  'ilsan|일산|areas/goyang-si/|일산 백석·주엽·대화|일산은 일산동구와 일산서구에 걸쳐 백석·마두·주엽·대화·탄현까지 생활권이 넓습니다. 학교별 시험 범위와 이동 여건을 함께 고려해 수업을 계획합니다.',
  'pyeongchon|평촌|areas/anyang-si/dongan-gu/|평촌·범계|평촌은 학원이 밀집한 생활권으로, 학원 수업과 병행하는 학생은 학원 진도와 학교 내신 범위를 함께 정리해 비어 있는 단원을 보완합니다.',
  'sanbon|산본|areas/gunpo-si/|산본신도시|산본신도시 학생의 학교별 시험 범위와 현재 학습 수준을 확인해 내신 일정에 맞춘 수업 계획을 세웁니다.',
  'wirye|위례|areas/seongnam-si/sujeong-gu/|위례신도시|위례신도시는 성남 수정구, 하남, 서울 송파에 걸쳐 있어 다니는 학교에 따라 일정이 다릅니다. 성남·하남 지역 학생을 중심으로 학교 진도와 시험 범위를 확인합니다.',
  'misa|미사|areas/hanam-si/|미사강변도시|미사강변도시 학생의 학교 진도와 내신 일정, 학원 병행 여부를 확인해 필요한 단원부터 정리합니다.',
  'dasan|다산|areas/namyangju-si/|다산신도시|다산신도시 학생의 학교별 진도와 시험 범위를 확인하고, 생활권에 맞춰 수업 가능 시간을 조율합니다.',
  'byeollae|별내|areas/namyangju-si/|별내신도시|별내신도시 학생의 학교 일정과 학습 목표를 확인하고, 이동 여건에 따라 대면 또는 온라인 수업을 안내합니다.',
  'unjeong|운정|areas/paju-si/|운정신도시|운정신도시 학생의 학교별 진도와 시험 일정을 확인해 개념 보완과 내신 대비의 순서를 정합니다.',
  'baegot|배곧|areas/siheung-si/|배곧신도시|배곧신도시 학생의 학교 진도와 현재 학습 수준을 확인해 필요한 단원부터 차근차근 수업합니다.',
  'jukjeon|죽전|areas/yongin-si/suji-gu/|죽전·보정|죽전·보정 생활권 학생의 학교별 내신 일정과 진도를 확인해 학생에게 맞는 수업 순서를 정합니다.',
  'homaesil|호매실|areas/suwon-si/gwonseon-gu/|호매실·금곡|호매실·금곡 생활권 학생의 학교 진도와 학습 습관을 확인하고 취약 단원을 중심으로 수업을 계획합니다.',
  'godeok|고덕|areas/pyeongtaek-si/|고덕국제신도시|고덕국제신도시 학생의 학교 일정과 학습 목표를 확인하고 생활권과 이동 여건에 맞춰 수업 방식을 안내합니다.',
  'okjeong|옥정|areas/yangju-si/|옥정신도시|옥정신도시 학생의 학교별 진도와 현재 학습 단계를 확인해 개념 보완과 내신 준비를 연결합니다.'
) | ForEach-Object {
    $parts = $_.Split('|')
    $pathParts = $parts[2].Split('/')
    $cityArea = $areas | Where-Object { $_.Slug -eq $pathParts[1] }
    $parentCrumbs = @([pscustomobject]@{ Name = $cityArea.Name; Path = "areas/$($cityArea.Slug)/" })
    $parentName = $cityArea.Short
    if ($pathParts[2]) {
        $districtName = ($cityArea.Districts | Where-Object { $_.StartsWith("$($pathParts[2])|") }).Split('|')[1]
        $parentCrumbs += [pscustomobject]@{ Name = $districtName; Path = $parts[2] }
        $parentName = $districtName
    }
    [pscustomobject]@{ Slug = $parts[0]; Name = $parts[1]; Parent = $parts[2]; ParentName = $parentName; CityName = $cityArea.Name; ParentCrumbs = $parentCrumbs; Spots = $parts[3]; Point = $parts[4] }
}

# 수업 방식·학년 전환 주제 페이지
$topicPages = @(
  [pscustomobject]@{
    Slug = 'visiting'; Name = '수학 방문과외'; En = 'VISITING TUTORING'
    Title = '경기 수학 방문과외 | 초등·중등·고등 1:1 방문 수학 수업'
    Description = '경기도 수학 방문과외. 학생이 공부하는 공간에서 초등 기초수학, 중등 수학내신, 고등 수능수학까지 1:1로 수업합니다. 방문 가능 지역 상담 010-2928-3614'
    Heading = '수학<br>방문과외'
    Hero = '이동 시간을 줄이고 익숙한 공간에서 집중할 수 있도록, 학생의 위치와 시간에 맞춰 1:1 방문 수업 가능 여부를 안내합니다.'
    IntroTitle = '익숙한 공간에서<br>집중하는 1:1 수업'
    Intros = @(
      '수학 방문과외는 학생이 평소 공부하는 공간에서 수업이 이루어져 이동 부담이 적고, 공부 환경과 학습 습관까지 함께 살필 수 있습니다.',
      '방문 가능 여부는 거주 지역과 희망 요일·시간에 따라 달라지므로 상담에서 먼저 확인합니다. 방문이 어려운 경우 온라인 수업으로 같은 계획을 이어갈 수 있습니다.'
    )
    Topics = @(
      '초등 수학 방문과외|아이가 편안한 공간에서 연산과 분수, 문장제처럼 자주 흔들리는 기초수학을 차근차근 다지고 매일 이어지는 수학공부 습관을 만듭니다.',
      '중등 수학 방문과외|학교 교과서와 프린트를 함께 보며 학교별 수학내신 범위를 정리하고 서술형 풀이와 오답을 꼼꼼하게 점검합니다.',
      '고등 수학 방문과외|내신 기출과 모의고사 결과를 바탕으로 취약 단원을 정리하고 수학내신과 수능수학 준비의 비중을 시기별로 조정합니다.',
      '첫 수업 준비|최근 시험지, 학교 교과서와 사용 중인 문제집, 오답 노트를 준비해 주시면 첫 수업부터 정확하게 진단할 수 있습니다.',
      '방문과외와 학원|학원은 정해진 진도로 여러 학생이 함께 배우고, 방문과외는 한 학생의 속도와 취약점에 맞춰 설명을 조절합니다. 학원과 병행하며 부족한 부분만 보완할 수도 있습니다.',
      '방문 수업 지역|수원, 성남, 용인, 고양, 화성 등 경기도 31개 시·군 학생을 상담합니다. 정확한 방문 가능 여부는 주소와 시간을 확인한 뒤 안내합니다.'
    )
    Faqs = @(
      '방문과외는 어느 지역까지 가능한가요?|경기도 31개 시·군 학생을 상담합니다. 거주 위치와 희망 시간을 확인한 뒤 방문 가능 여부를 안내하며, 어려운 경우 온라인 수업을 협의합니다.',
      '방문 수업을 위해 무엇을 준비하면 되나요?|학생이 집중할 수 있는 책상과 최근 시험지, 교과서, 사용 중인 문제집이면 충분합니다.',
      '학원과 함께 다녀도 되나요?|네. 학원 진도와 학교 범위를 확인해 부족한 단원과 오답을 중심으로 보완 수업을 할 수 있습니다.',
      '수업 시간은 어떻게 정하나요?|학생의 학년, 학교·학원 일정, 집중할 수 있는 시간에 맞춰 상담 시 정합니다.'
    )
  },
  [pscustomobject]@{
    Slug = 'online'; Name = '온라인 수학과외'; En = 'ONLINE TUTORING'
    Title = '온라인 수학과외 | 경기 초등·중등·고등 1:1 화상 수학 수업'
    Description = '경기도 온라인 수학과외. 이동 없이 초등 기초수학, 중등 수학내신, 고등 수능수학까지 1:1 화상 수업으로 진단하고 관리합니다. 상담 010-2928-3614'
    Heading = '온라인<br>수학과외'
    Hero = '거리와 이동 시간 때문에 대면 수업이 어려운 학생도 같은 진단과 계획으로 1:1 수학 수업을 받을 수 있습니다.'
    IntroTitle = '거리와 상관없이<br>같은 밀도의 수업'
    Intros = @(
      '온라인 수학과외는 화상으로 진행하는 1:1 수업입니다. 학생이 푸는 과정을 화면으로 함께 보며 막히는 지점에서 바로 설명하므로, 대면 수업과 같은 방식으로 진단하고 피드백합니다.',
      '양평·가평·연천처럼 이동 거리가 긴 지역이나 학교·학원 일정이 빠듯한 학생에게 특히 알맞으며, 상황에 따라 대면 수업과 온라인 수업을 병행할 수도 있습니다.'
    )
    Topics = @(
      '초등 온라인 수학|짧은 집중 시간에 맞춰 수업을 구성하고 화면 속 그림과 판서로 수 감각과 연산 원리를 설명합니다.',
      '중등 온라인 수학|학교 교과서와 프린트를 화면으로 공유해 수학내신 범위를 정리하고 서술형 풀이를 함께 점검합니다.',
      '고등 온라인 수학|모의고사와 내신 기출을 함께 보며 취약 단원을 정리하고 수능수학 실전 풀이를 훈련합니다.',
      '수업 준비 환경|노트북이나 태블릿과 안정적인 인터넷이 있으면 수업할 수 있습니다. 풀이를 보여주는 방법 등 세부 방식은 상담 시 안내합니다.',
      '대면 · 온라인 병행|평소에는 대면으로, 시험 기간이나 일정이 바쁠 때는 온라인으로 전환해 학습 흐름이 끊기지 않게 할 수 있습니다.',
      '과제와 오답 관리|수업 뒤 과제와 오답을 사진이나 파일로 확인해 다음 수업의 우선순위를 정합니다.'
    )
    Faqs = @(
      '온라인 수학과외도 대면 수업만큼 효과가 있나요?|학생의 풀이 과정을 실시간으로 보며 설명하기 때문에 진단과 피드백 방식은 같습니다. 집중 시간이 짧은 학생은 수업 구성을 조정합니다.',
      '어떤 장비가 필요한가요?|노트북이나 태블릿과 안정적인 인터넷이 필요합니다. 필기 방식 등 세부 내용은 상담 시 안내합니다.',
      '대면 수업과 섞어서 할 수 있나요?|네. 거주 지역과 일정에 따라 대면과 온라인을 병행하는 방식도 협의할 수 있습니다.',
      '초등학생도 온라인 수업이 가능한가요?|가능합니다. 집중 시간에 맞춰 수업 길이와 활동을 조절하고, 필요한 경우 보호자와 수업 방식을 먼저 상의합니다.'
    )
  },
  [pscustomobject]@{
    Slug = 'pre-middle1'; Name = '예비중1 수학과외'; En = 'PRE MIDDLE 1'
    Title = '예비중1 수학과외 | 경기 초6 겨울방학 중1 수학 준비 1:1'
    Description = '경기 예비중1 수학과외. 초등 분수·소수 연산과 문장제 빈틈을 점검하고 정수, 문자와 식, 일차방정식으로 중1 첫 시험을 준비합니다. 상담 010-2928-3614'
    Heading = '예비중1<br>수학과외'
    Hero = '중학교 수학의 첫 단원은 초등에서 배운 수와 연산 위에 쌓입니다. 초등 과정의 빈틈부터 확인하고 중1 수학을 편안하게 시작하도록 준비합니다.'
    IntroTitle = '초등에서 중등으로<br>넘어가는 연결 고리'
    Intros = @(
      '예비중1 수학과외는 초등 5·6학년의 분수·소수 계산, 비와 비율, 문장제를 먼저 점검합니다. 이 단원이 흔들리면 중1의 정수와 유리수, 문자와 식이 갑자기 어렵게 느껴지기 때문입니다.',
      '초6 2학기와 겨울방학에는 빈틈을 보완한 뒤 소인수분해, 정수와 유리수, 문자와 식, 일차방정식을 미리 경험하며 중학교 첫 지필 시험에 필요한 풀이 습관을 만듭니다.'
    )
    Topics = @(
      '초등 수학 빈틈 점검|분수의 사칙연산, 소수 계산, 약수와 배수처럼 중1 수학의 바탕이 되는 단원을 진단해 필요한 부분부터 보완합니다.',
      '중1 수학 미리보기|소인수분해, 정수와 유리수, 문자와 식, 일차방정식, 좌표평면과 그래프를 학생 속도에 맞춰 미리 익힙니다.',
      '문장제 · 서술형 준비|문제의 조건을 식으로 옮기고 풀이 과정을 순서대로 쓰는 연습으로 중학교 서술형 평가에 대비합니다.',
      '중학교 시험 적응|중학교는 지필 평가와 수행평가가 함께 이루어집니다. 시험 범위를 정리하고 오답을 관리하는 방법을 미리 익힙니다.',
      '겨울방학 계획|방학 기간에 맞춰 주간 목표를 세우고, 개학 전까지 중1 1학기 핵심 단원을 정리하도록 학습량을 조절합니다.',
      '공부 습관 만들기|정해진 시간에 과제를 하고 틀린 문제를 다시 푸는 습관을 만들어 중학교 생활에 자연스럽게 적응하도록 돕습니다.'
    )
    Faqs = @(
      '예비중1 수학은 언제부터 준비하면 좋을까요?|초6 2학기부터 초등 과정의 빈틈을 점검하고, 겨울방학에 중1 1학기 핵심 단원을 미리 익히는 흐름을 권합니다. 시작 시기는 학생 상황에 따라 조정합니다.',
      '초등 수학이 부족한데 선행을 해도 될까요?|빈틈이 있는 상태에서 진도만 나가면 중학교 수학이 더 어려워집니다. 진단 후 필요한 초등 단원을 먼저 보완하고 중1 과정을 연결합니다.',
      '중1 첫 시험은 어떻게 준비하나요?|학교별 시험 범위와 교과서를 확인해 개념 정리, 유형 연습, 서술형 풀이 순서로 준비합니다.',
      '방문 수업이 가능한가요?|거주 위치와 희망 시간을 확인한 뒤 대면 수업 가능 여부를 안내합니다. 이동이 어려운 경우 온라인 수업도 협의할 수 있습니다.'
    )
  },
  [pscustomobject]@{
    Slug = 'pre-high1'; Name = '예비고1 수학과외'; En = 'PRE HIGH 1'
    Title = '예비고1 수학과외 | 경기 중3 겨울방학 고1 공통수학 준비 1:1'
    Description = '경기 예비고1 수학과외. 중학 수학 전 범위의 빈틈을 점검하고 고1 공통수학과 첫 내신을 준비합니다. 중3 겨울방학 상담 010-2928-3614'
    Heading = '예비고1<br>수학과외'
    Hero = '고등학교 첫 내신은 이후 입시 계획에 영향을 줍니다. 중학 수학의 빈틈을 정리하고 고1 공통수학을 학생 속도에 맞춰 준비합니다.'
    IntroTitle = '중학 수학을 정리하고<br>고1 공통수학으로'
    Intros = @(
      '예비고1 수학과외는 중학교 과정 중 고등 수학의 바탕이 되는 인수분해, 이차방정식, 이차함수, 일차함수와 도형 단원을 먼저 점검합니다. 이 부분이 흔들리면 고1 진도가 빨라질수록 따라가기 어려워집니다.',
      '중3 2학기와 겨울방학에는 다항식, 방정식과 부등식, 경우의 수, 행렬 등 공통수학1의 핵심 단원을 학생 속도에 맞춰 익히고 고등학교 첫 시험에 맞는 학습 습관을 만듭니다.'
    )
    Topics = @(
      '중학 수학 총정리|인수분해, 이차방정식, 이차함수, 도형의 성질처럼 고등 수학에서 바로 쓰이는 중학 단원을 진단하고 짧고 굵게 다시 정리합니다.',
      '공통수학1 준비|다항식, 방정식과 부등식, 경우의 수, 행렬을 차례로 익히며 고1 1학기 내신 범위를 미리 경험합니다.',
      '공통수학2 연결|도형의 방정식, 집합과 명제, 함수와 그래프로 이어지는 흐름을 미리 보고 학생 상황에 맞춰 진도를 정합니다.',
      '고1 첫 내신 대비|학교별 교과서와 부교재, 시험 범위를 확인해 고등학교 첫 지필 평가를 준비합니다.',
      '수능 기초 다지기|고1 모의고사 유형을 경험하며 정해진 시간 안에 정확하게 푸는 연습을 시작합니다.',
      '고등 공부 습관|중학교보다 많아지는 분량에 맞춰 개념 복습과 오답 재풀이 계획을 세우고 스스로 공부 시간을 관리하도록 돕습니다.'
    )
    Faqs = @(
      '예비고1 수학은 어디까지 선행해야 하나요?|중학 수학의 완성도에 따라 다릅니다. 빈틈이 많다면 중학 과정 정리가 먼저이고, 기초가 탄탄하다면 공통수학1부터 차근차근 진도를 나갑니다.',
      '중학 수학이 부족한 중3도 가능한가요?|네. 진단으로 필요한 중학 단원을 찾아 보완한 뒤 고1 과정으로 연결합니다.',
      '고1 첫 내신은 어떻게 준비하나요?|학교별 교과서와 부교재, 기출 경향을 확인해 시험 4~5주 전부터 범위 정리와 실전 연습을 진행합니다.',
      '방문 수업이 가능한가요?|거주 위치와 희망 시간을 확인한 뒤 대면 수업 가능 여부를 안내합니다. 이동이 어려운 경우 온라인 수업도 협의할 수 있습니다.'
    )
  },
  [pscustomobject]@{
    Slug = 'middle-1'; Name = '중1 수학과외'; En = 'MIDDLE 1'
    Title = '중1 수학과외 | 경기 중학교 1학년 수학 첫 시험 대비 1:1'
    Description = '경기 중1 수학과외. 소인수분해, 정수와 유리수, 문자와 식, 일차방정식부터 중학교 첫 지필 시험과 서술형까지 1:1로 준비합니다. 상담 010-2928-3614'
    Heading = '중1<br>수학과외'
    Hero = '중학교 1학년은 수학 공부 방식이 처음 바뀌는 시기입니다. 초등 과정의 빈틈을 정리하고 중학교 시험에 맞는 풀이 습관을 만듭니다.'
    IntroTitle = '중학교 수학의<br>첫 단추'
    Intros = @(
      '중1 수학은 소인수분해, 정수와 유리수, 문자와 식, 일차방정식, 좌표평면과 그래프처럼 이후 중학 수학 전체의 도구가 되는 단원으로 이루어져 있습니다. 이 시기에 개념을 정확히 잡으면 중2·중3 수학이 훨씬 수월해집니다.',
      '중1 수학과외는 초등 분수·소수 계산과 문장제의 빈틈부터 진단하고, 학교 진도에 맞춰 개념 설명과 풀이 연습, 서술형 쓰기를 함께 진행합니다.'
    )
    Topics = @(
      '정수와 유리수|음수가 들어간 사칙연산에서 부호 실수가 반복되지 않도록 원리부터 설명하고 계산 습관을 바로잡습니다.',
      '문자와 식|문자를 사용하는 이유와 식을 세우는 과정을 이해해 일차방정식 활용 문제까지 자연스럽게 연결합니다.',
      '좌표평면과 그래프|그래프를 읽고 해석하는 방법을 익혀 중2 일차함수로 이어지는 기초를 만듭니다.',
      '도형과 통계|기본 도형, 평면·입체도형, 자료의 정리처럼 개념 용어가 많은 단원을 그림과 함께 정리합니다.',
      '첫 지필 시험 대비|학교별 시험 범위와 교과서, 프린트를 확인해 개념 정리, 유형 연습, 실전 풀이 순서로 준비합니다.',
      '서술형 풀이 습관|풀이 과정을 순서대로 쓰는 연습을 처음부터 시작해 감점 없는 답안 작성 습관을 만듭니다.'
    )
    Faqs = @(
      '중1인데 초등 수학이 부족해요.|진단 후 분수·소수 계산, 약수와 배수 등 필요한 초등 단원을 먼저 보완하고 중1 진도와 병행합니다.',
      '중1 첫 시험은 언제부터 준비하나요?|시험 4~5주 전부터 학교 범위를 정리하고, 평소에는 단원별 개념과 오답을 꾸준히 관리합니다.',
      '선행도 함께 할 수 있나요?|현재 학년 개념이 탄탄한 학생은 상황에 맞춰 다음 학기 진도를 함께 나갑니다.',
      '방문 수업이 가능한가요?|거주 위치와 희망 시간을 확인한 뒤 대면 수업 가능 여부를 안내합니다. 이동이 어려운 경우 온라인 수업도 협의할 수 있습니다.'
    )
  },
  [pscustomobject]@{
    Slug = 'middle-2'; Name = '중2 수학과외'; En = 'MIDDLE 2'
    Title = '중2 수학과외 | 경기 중학교 2학년 수학내신·일차함수 1:1'
    Description = '경기 중2 수학과외. 식의 계산, 연립방정식, 부등식, 일차함수, 도형의 성질과 확률까지 학교별 수학내신과 서술형을 1:1로 준비합니다. 상담 010-2928-3614'
    Heading = '중2<br>수학과외'
    Hero = '중2 수학은 분량과 난도가 함께 올라가 성적 차이가 크게 벌어지는 시기입니다. 함수와 도형의 핵심 개념을 놓치지 않도록 학교 진도에 맞춰 정리합니다.'
    IntroTitle = '분량이 늘어나는<br>중2 수학 정리'
    Intros = @(
      '중2 수학은 식의 계산, 연립방정식과 부등식, 일차함수, 도형의 성질, 확률처럼 단원마다 새로운 개념이 많고 문제 유형도 다양합니다. 특히 일차함수와 도형의 성질을 설명하는 서술형은 많은 학생이 어려워하는 부분입니다.',
      '중2 수학과외는 중1 과정 중 흔들리는 부분을 함께 점검하면서 학교별 교과서와 시험 범위에 맞춰 수학내신을 준비하고, 중3과 고등 수학으로 이어지는 연결을 만듭니다.'
    )
    Topics = @(
      '식의 계산|지수법칙과 다항식 계산에서 반복되는 실수를 유형별로 정리해 계산 정확도를 높입니다.',
      '연립방정식과 부등식|문장을 식으로 바꾸는 과정을 단계별로 연습해 활용 문제에 대한 부담을 줄입니다.',
      '일차함수|그래프와 식, 표를 서로 바꿔 보며 함수의 의미를 이해하고 기울기와 절편을 활용하는 문제를 해결합니다.',
      '도형의 성질과 닮음|삼각형과 사각형의 성질, 도형의 닮음을 그림과 함께 정리하고 근거를 들어 설명하는 서술을 연습합니다.',
      '확률|경우의 수를 빠짐없이 세는 방법을 익혀 확률 문제를 체계적으로 풉니다.',
      '중2 수학내신|학교별 기출 유형과 프린트를 분석해 시험 범위를 정리하고 서술형과 고난도 문항까지 대비합니다.'
    )
    Faqs = @(
      '중2가 되면서 수학이 갑자기 어려워졌어요.|중1 개념의 빈틈이 원인인 경우가 많습니다. 진단으로 원인 단원을 찾아 보완하고 현재 진도와 병행합니다.',
      '일차함수를 특히 어려워해요.|표, 식, 그래프를 연결해 보는 연습으로 함수의 의미부터 다시 정리합니다.',
      '중2 겨울방학에는 무엇을 하면 좋을까요?|중2 과정의 빈틈을 정리하고 중3 핵심 단원인 제곱근, 인수분해, 이차방정식을 학생 상황에 맞춰 준비합니다.',
      '방문 수업이 가능한가요?|거주 위치와 희망 시간을 확인한 뒤 대면 수업 가능 여부를 안내합니다. 이동이 어려운 경우 온라인 수업도 협의할 수 있습니다.'
    )
  },
  [pscustomobject]@{
    Slug = 'middle-3'; Name = '중3 수학과외'; En = 'MIDDLE 3'
    Title = '중3 수학과외 | 경기 중학교 3학년 수학내신·고등 준비 1:1'
    Description = '경기 중3 수학과외. 제곱근과 실수, 인수분해, 이차방정식과 이차함수, 삼각비까지 중3 수학내신과 예비고1 준비를 1:1로 진행합니다. 상담 010-2928-3614'
    Heading = '중3<br>수학과외'
    Hero = '중3 수학은 고등 수학과 가장 가까운 단원으로 이루어져 있습니다. 중3 내신을 준비하면서 고등학교 공통수학으로 이어지는 바탕을 함께 다집니다.'
    IntroTitle = '중학 수학의 마무리,<br>고등 수학의 시작'
    Intros = @(
      '중3 수학의 제곱근과 실수, 다항식의 곱셈과 인수분해, 이차방정식, 이차함수는 고1 공통수학에서 바로 쓰이는 단원입니다. 이 단원의 계산력과 개념 이해가 고등 수학 첫 성적을 좌우합니다.',
      '중3 수학과외는 학교 진도와 수학내신을 준비하는 동시에 중학 전 범위의 빈틈을 점검하고, 2학기 이후에는 학생 상황에 맞춰 예비고1 과정을 연결합니다.'
    )
    Topics = @(
      '제곱근과 실수|근호 계산과 분모의 유리화에서 자주 나오는 실수를 정리하고 실수의 대소 관계를 이해합니다.',
      '인수분해|곱셈 공식과 인수분해 공식을 원리부터 익혀 고등 수학에서 막힘없이 쓸 수 있는 계산력을 만듭니다.',
      '이차방정식과 이차함수|이차방정식의 풀이와 이차함수 그래프의 관계를 연결해 고1 방정식과 부등식 단원의 기초를 다집니다.',
      '삼각비와 원의 성질|삼각비의 뜻과 활용, 원과 관련된 도형의 성질을 그림과 함께 정리합니다.',
      '중3 수학내신|학교별 시험 범위와 기출 유형을 분석해 고난도 문항과 서술형까지 대비합니다.',
      '예비고1 연결|중3 2학기 이후에는 중학 과정을 마무리하고 공통수학1의 다항식, 방정식과 부등식으로 자연스럽게 이어 갑니다.'
    )
    Faqs = @(
      '중3인데 기초가 부족해도 고등 준비가 가능한가요?|진단으로 필요한 중1·중2 단원을 찾아 짧게 보완한 뒤 중3 과정과 고등 준비를 순서대로 진행합니다.',
      '중3 2학기 기말고사 이후에는 무엇을 하나요?|중학 전 범위의 빈틈을 정리하고 고1 공통수학을 학생 속도에 맞춰 시작합니다.',
      '고등 선행은 어디까지 해야 하나요?|중학 수학의 완성도에 따라 다르며, 상담에서 학생 상황을 확인해 범위와 속도를 정합니다.',
      '방문 수업이 가능한가요?|거주 위치와 희망 시간을 확인한 뒤 대면 수업 가능 여부를 안내합니다. 이동이 어려운 경우 온라인 수업도 협의할 수 있습니다.'
    )
  },
  [pscustomobject]@{
    Slug = 'high-1'; Name = '고1 수학과외'; En = 'HIGH 1'
    Title = '고1 수학과외 | 경기 고등학교 1학년 공통수학 내신 1:1'
    Description = '경기 고1 수학과외. 공통수학1·2의 다항식, 방정식과 부등식, 경우의 수, 행렬, 도형의 방정식, 집합과 명제, 함수를 학교 내신에 맞춰 1:1로 준비합니다. 상담 010-2928-3614'
    Heading = '고1<br>수학과외'
    Hero = '고1 수학은 고등학교 수학 전체의 바탕이자 첫 내신 성적이 만들어지는 과목입니다. 공통수학의 개념을 탄탄히 하고 학교별 내신 출제에 맞춰 준비합니다.'
    IntroTitle = '고등 수학의 바탕,<br>공통수학'
    Intros = @(
      '고1은 공통수학1에서 다항식, 방정식과 부등식, 경우의 수, 행렬을, 공통수학2에서 도형의 방정식, 집합과 명제, 함수와 그래프를 배웁니다. 이후 배우는 수학 과목이 모두 이 내용 위에 쌓입니다.',
      '고1 수학과외는 중학 수학의 빈틈부터 진단하고, 학교 교과서와 부교재, 기출 경향에 맞춰 내신을 준비하며 고1 모의고사로 수능 유형에도 익숙해지도록 돕습니다.'
    )
    Topics = @(
      '다항식|다항식의 연산, 나머지정리, 인수분해를 정확하고 빠르게 처리하는 계산력을 기릅니다.',
      '방정식과 부등식|복소수, 이차방정식과 이차함수, 여러 가지 방정식과 부등식의 관계를 연결해 정리합니다.',
      '경우의 수와 행렬|경우의 수, 순열과 조합을 체계적으로 세는 방법과 행렬의 기본 연산을 익힙니다.',
      '도형의 방정식|좌표와 식으로 도형을 다루는 방법을 익히고 그래프를 활용한 문제 해석력을 키웁니다.',
      '집합과 명제 · 함수|정의와 논리를 정확히 이해하고 함수와 그래프 단원의 서술형까지 대비합니다.',
      '고1 내신 · 모의고사|학교별 출제 경향에 맞춰 내신을 준비하고 모의고사 결과로 취약 단원을 보완합니다.'
    )
    Faqs = @(
      '고1 첫 내신이 걱정돼요.|학교별 교과서와 부교재, 기출 경향을 확인해 시험 4~5주 전부터 범위 정리와 실전 연습을 진행합니다.',
      '중학 수학이 부족한 고1도 가능한가요?|네. 인수분해, 이차방정식, 이차함수 등 필요한 중학 단원을 짧게 보완하고 고1 진도와 병행합니다.',
      '모의고사도 함께 준비하나요?|내신을 중심으로 하되 모의고사 결과를 함께 보며 수능 유형에 익숙해지도록 연습합니다.',
      '방문 수업이 가능한가요?|거주 위치와 희망 시간을 확인한 뒤 대면 수업 가능 여부를 안내합니다. 이동이 어려운 경우 온라인 수업도 협의할 수 있습니다.'
    )
  },
  [pscustomobject]@{
    Slug = 'high-2'; Name = '고2 수학과외'; En = 'HIGH 2'
    Title = '고2 수학과외 | 경기 고등학교 2학년 수학내신·수능 기초 1:1'
    Description = '경기 고2 수학과외. 학교 과목 진도에 맞춰 수학내신을 준비하고 지수·로그, 삼각함수, 수열, 미적분 등 수능 핵심 단원을 1:1로 정리합니다. 상담 010-2928-3614'
    Heading = '고2<br>수학과외'
    Hero = '고2는 내신 과목이 늘어나고 수능 범위의 핵심 단원을 본격적으로 배우는 시기입니다. 학교 진도와 수능 준비의 균형을 맞춰 수업합니다.'
    IntroTitle = '내신과 수능의<br>균형을 잡는 고2'
    Intros = @(
      '고2 수학은 학교의 과목 편성에 따라 배우는 내용과 시험 범위가 달라집니다. 지수·로그, 삼각함수, 수열, 미분과 적분, 확률과 통계처럼 수능과 직접 연결되는 단원이 많아 개념을 정확히 잡는 것이 중요합니다.',
      '고2 수학과외는 학생이 다니는 학교의 과목 편성과 시험 범위를 먼저 확인하고, 내신 기간에는 학교 기출 중심으로, 내신 이후에는 수능 기출 중심으로 수업 비중을 조정합니다.'
    )
    Topics = @(
      '지수와 로그|지수법칙과 로그의 성질을 원리부터 정리하고 그래프 문제까지 연결합니다.',
      '삼각함수|삼각함수의 정의와 그래프, 활용 문제를 그림과 함께 이해합니다.',
      '수열|등차·등비수열과 합의 기호, 귀납적 정의를 체계적으로 익힙니다.',
      '미분과 적분|함수의 극한에서 미분과 적분으로 이어지는 흐름을 이해하고 그래프 해석 문제를 훈련합니다.',
      '확률과 통계|경우의 수, 확률, 통계의 개념을 정리하고 실생활 맥락의 문제 해석력을 높입니다.',
      '고2 내신 · 수능 기초|학교별 기출로 내신을 준비하고 수능 기출을 단원별로 풀어 보며 고3을 준비합니다.'
    )
    Faqs = @(
      '고2 수학은 학교마다 배우는 과목이 다른가요?|학교의 과목 편성에 따라 다를 수 있어 상담 시 학생의 시간표와 교과서를 먼저 확인합니다.',
      '내신과 수능 중 무엇을 먼저 해야 하나요?|시험 기간에는 내신을, 그 외 기간에는 수능 기출과 취약 단원 보완을 중심으로 비중을 조정합니다.',
      '수학 성적이 떨어진 고2도 따라갈 수 있나요?|진단으로 원인이 되는 고1 단원을 찾아 보완하고 현재 진도와 병행해 회복 계획을 세웁니다.',
      '방문 수업이 가능한가요?|거주 위치와 희망 시간을 확인한 뒤 대면 수업 가능 여부를 안내합니다. 이동이 어려운 경우 온라인 수업도 협의할 수 있습니다.'
    )
  },
  [pscustomobject]@{
    Slug = 'high-3'; Name = '고3 수학과외'; En = 'HIGH 3'
    Title = '고3 수학과외 | 경기 고등학교 3학년 수능수학·내신 마무리 1:1'
    Description = '경기 고3 수학과외. 수능수학 기출 분석, 취약 단원 보완, 시간 배분과 실전 모의 훈련, 마지막 내신 관리까지 1:1로 진행합니다. 상담 010-2928-3614'
    Heading = '고3<br>수학과외'
    Hero = '고3은 남은 시간 안에서 점수를 올릴 수 있는 곳에 집중해야 합니다. 모의고사 결과로 우선순위를 정하고 실전에서 흔들리지 않는 풀이를 훈련합니다.'
    IntroTitle = '남은 시간 안에서<br>점수를 올리는 전략'
    Intros = @(
      '고3 수학과외는 최근 모의고사 성적표와 시험지를 분석해 시간이 부족한 것인지, 특정 단원이 비어 있는 것인지, 고난도 문항에서 막히는 것인지를 먼저 구분합니다. 원인에 따라 수업의 우선순위가 달라집니다.',
      '1학기에는 마지막 내신과 수능 개념 완성을 함께 준비하고, 이후에는 기출 분석과 실전 모의 훈련, 시간 배분 연습으로 수능 당일의 실전 점수를 안정시킵니다.'
    )
    Topics = @(
      '모의고사 분석|문항별 정오답과 풀이 시간을 분석해 점수를 올릴 수 있는 단원과 유형을 우선순위로 정합니다.',
      '수능 기출 분석|평가원 기출을 단원별·난이도별로 풀며 출제 의도와 자주 쓰이는 풀이 방법을 정리합니다.',
      '취약 단원 보완|자주 틀리는 단원은 개념부터 다시 정리해 기본 문항에서 놓치는 점수를 줄입니다.',
      '시간 배분 훈련|실전과 같은 시간 안에서 문항별 시간 배분과 검토 순서를 연습합니다.',
      '고난도 문항 접근|고난도 문항의 조건을 해석하는 방법과 풀이 방향을 잡는 연습으로 상위권 점수를 준비합니다.',
      '마지막 내신 관리|수시 지원을 고려하는 학생은 3학년 내신 일정에 맞춰 학교별 기출 중심으로 시험을 준비합니다.'
    )
    Faqs = @(
      '고3인데 지금 시작해도 늦지 않을까요?|남은 기간에 맞춰 점수를 올릴 수 있는 단원과 유형부터 우선순위를 정해 수업합니다.',
      '수능수학 등급을 올리려면 무엇부터 해야 하나요?|모의고사 분석으로 실점 원인을 찾는 것이 먼저입니다. 원인에 따라 개념 보완, 기출 훈련, 시간 배분 연습의 비중을 정합니다.',
      '내신과 수능을 같이 준비할 수 있나요?|내신 기간에는 학교 기출 중심으로, 그 외 기간에는 수능 중심으로 비중을 조정해 함께 준비합니다.',
      '방문 수업이 가능한가요?|거주 위치와 희망 시간을 확인한 뒤 대면 수업 가능 여부를 안내합니다. 이동이 어려운 경우 온라인 수업도 협의할 수 있습니다.'
    )
  },
  [pscustomobject]@{
    Slug = 'naesin'; Name = '수학 내신대비 과외'; En = 'SCHOOL EXAM'
    Title = '수학 내신대비 과외 | 경기 중등·고등 학교별 시험 대비 1:1'
    Description = '경기 수학 내신대비 과외. 학교별 교과서, 프린트, 부교재와 기출 경향을 분석해 중등·고등 수학내신과 서술형을 1:1로 준비합니다. 상담 010-2928-3614'
    Heading = '수학<br>내신대비'
    Hero = '같은 학년이라도 학교마다 시험 범위와 출제 경향이 다릅니다. 학생이 다니는 학교의 자료를 기준으로 시험을 준비합니다.'
    IntroTitle = '학교별 시험에 맞춘<br>내신 준비'
    Intros = @(
      '수학 내신대비는 학교 교과서와 프린트, 부교재, 이전 시험의 출제 경향을 확인하는 것에서 시작합니다. 시험 범위 안에서 자주 나오는 유형과 학생이 자주 틀리는 유형을 함께 정리합니다.',
      '시험 4~5주 전부터 개념 정리, 유형 연습, 실전 모의 풀이, 오답 재풀이 순서로 준비하고, 시험이 끝나면 결과를 분석해 다음 시험 계획을 세웁니다.'
    )
    Topics = @(
      '시험 범위 정리|교과서와 프린트, 부교재를 기준으로 시험 범위를 빠짐없이 정리하고 우선순위를 정합니다.',
      '학교별 기출 경향|학교마다 다른 출제 경향과 배점, 서술형 비중을 확인해 그에 맞게 준비합니다.',
      '서술형 대비|풀이 과정을 논리적으로 쓰는 연습과 감점되는 표현 점검으로 서술형 점수를 지킵니다.',
      '실전 모의 풀이|실제 시험 시간에 맞춰 풀어 보며 시간 배분과 검토 습관을 만듭니다.',
      '오답 재풀이|틀린 문제를 유형별로 다시 풀어 같은 실수를 반복하지 않도록 합니다.',
      '시험 후 분석|시험 결과를 바탕으로 부족했던 단원과 다음 시험의 준비 기간을 다시 계획합니다.'
    )
    Faqs = @(
      '내신대비는 언제부터 시작하나요?|보통 시험 4~5주 전부터 본격적으로 준비하며, 평소에는 학교 진도에 맞춰 개념과 오답을 관리합니다.',
      '학교 프린트도 함께 보나요?|네. 교과서와 프린트, 부교재 등 학교에서 사용하는 자료를 기준으로 준비합니다.',
      '시험 기간에만 수업할 수 있나요?|학생 일정에 맞춰 상담 시 협의하며, 평소 수업과 시험 기간 수업의 비중을 조정할 수 있습니다.',
      '방문 수업이 가능한가요?|거주 위치와 희망 시간을 확인한 뒤 대면 수업 가능 여부를 안내합니다. 이동이 어려운 경우 온라인 수업도 협의할 수 있습니다.'
    )
  },
  [pscustomobject]@{
    Slug = 'suneung'; Name = '수능수학 과외'; En = 'CSAT MATH'
    Title = '수능수학 과외 | 경기 고등학생 수능대비 1:1 수학'
    Description = '경기 수능수학 과외. 모의고사 분석, 평가원 기출, 취약 단원 보완, 시간 배분과 고난도 문항 훈련까지 고1~고3 수능대비를 1:1로 진행합니다. 상담 010-2928-3614'
    Heading = '수능수학<br>과외'
    Hero = '수능수학은 아는 문제를 정해진 시간 안에 정확히 푸는 시험입니다. 모의고사 결과로 실점 원인을 찾고 실전 점수를 올리는 데 집중합니다.'
    IntroTitle = '실점 원인부터 찾는<br>수능 준비'
    Intros = @(
      '수능수학 과외는 최근 모의고사 시험지와 성적표를 함께 분석하는 것에서 시작합니다. 개념이 비어 있는지, 시간이 부족한지, 고난도 문항에서 막히는지에 따라 수업 계획이 달라집니다.',
      '고1·고2는 내신과 함께 수능 기출 유형을 경험하며 기초를 다지고, 고3은 기출 분석과 실전 모의 훈련, 시간 배분 연습으로 남은 기간의 점수 향상에 집중합니다.'
    )
    Topics = @(
      '모의고사 분석|문항별 정오답과 풀이 시간을 분석해 반복되는 실점 원인을 찾습니다.',
      '고1 · 고2 수능 기초|학교 진도에 맞춰 수능 기출 유형을 단원별로 경험해 고3의 부담을 줄입니다.',
      '평가원 기출 분석|기출 문제를 단원별·난이도별로 풀며 출제 의도와 자주 쓰이는 풀이 방법을 정리합니다.',
      '취약 단원 보완|자주 틀리는 단원은 개념부터 다시 정리해 기본 문항에서 놓치는 점수를 줄입니다.',
      '시간 배분 · 고난도|문항별 시간 배분과 검토 순서를 연습하고, 고난도 문항의 조건을 해석하는 방법을 훈련합니다.',
      '실전 모의 훈련|실제 시험과 같은 조건에서 풀어 보고 결과를 분석해 다음 주 학습 계획을 세웁니다.'
    )
    Faqs = @(
      '수능수학은 언제부터 준비하면 좋을까요?|고1·고2부터 내신과 함께 수능 유형을 경험하면 좋습니다. 고3은 남은 기간에 맞춰 우선순위를 정해 진행합니다.',
      '모의고사 성적이 들쭉날쭉해요.|문항별 정오답과 풀이 시간을 분석해 반복되는 실점 원인을 찾고 그에 맞는 훈련을 합니다.',
      '재수생도 수업할 수 있나요?|상담에서 현재 상황과 목표를 확인한 뒤 수업 가능 여부와 계획을 안내합니다.',
      '방문 수업이 가능한가요?|거주 위치와 희망 시간을 확인한 뒤 대면 수업 가능 여부를 안내합니다. 이동이 어려운 경우 온라인 수업도 협의할 수 있습니다.'
    )
  },
  [pscustomobject]@{
    Slug = 'basic-math'; Name = '기초수학 과외'; En = 'BASIC MATH'
    Title = '기초수학 과외 | 경기 초등·중등·고등 수학 기초 다지기 1:1'
    Description = '경기 기초수학 과외. 수학이 어렵게 느껴지는 초등·중등·고등학생의 막힌 지점을 진단하고 이전 학년 단원부터 차근차근 다시 세웁니다. 상담 010-2928-3614'
    Heading = '기초수학<br>과외'
    Hero = '수학이 어려운 이유는 대부분 지금 배우는 단원보다 앞에 있습니다. 막힌 지점을 찾아 이전 학년부터 다시 세우고 현재 진도와 연결합니다.'
    IntroTitle = '막힌 지점부터<br>다시 시작하는 수학'
    Intros = @(
      '기초수학 과외는 학년보다 현재 이해 수준을 기준으로 시작합니다. 간단한 진단으로 연산, 분수, 문자와 식, 함수 중 어디서부터 흔들렸는지 찾아 그 단원부터 차근차근 다시 정리합니다.',
      '기초를 보완하는 동안에도 학교 진도와 시험은 계속되기 때문에, 이전 학년 단원 보완과 현재 학년 진도를 학생 부담에 맞춰 병행합니다.'
    )
    Topics = @(
      '초등 기초수학|구구단, 받아올림·받아내림, 분수와 소수처럼 이후 모든 수학의 바탕이 되는 연산과 개념을 다집니다.',
      '중등 기초수학|정수와 유리수 계산, 문자와 식, 일차방정식처럼 중학 수학에서 자주 흔들리는 단원을 다시 정리합니다.',
      '고등 기초수학|인수분해, 이차방정식, 함수 등 고등 수학에 필요한 중학 단원을 짧고 굵게 보완합니다.',
      '수학 자신감 회복|쉬운 문제부터 스스로 풀어내는 경험을 쌓아 수학에 대한 부담감을 줄입니다.',
      '계산 실수 교정|반복되는 계산 실수를 유형별로 정리하고 검산 습관을 만듭니다.',
      '현재 진도와 병행|이전 학년 보완과 학교 진도를 함께 진행해 시험 성적도 놓치지 않도록 합니다.'
    )
    Faqs = @(
      '학년이 높은데 기초부터 해도 괜찮을까요?|네. 필요한 단원만 골라 짧게 보완하므로 처음부터 모두 다시 하는 것은 아닙니다.',
      '기초를 보완하는 데 얼마나 걸리나요?|비어 있는 단원의 범위와 학생의 학습 속도에 따라 다르며, 진단 후 예상 계획을 안내합니다.',
      '학교 시험 준비는 어떻게 하나요?|시험 기간에는 학교 범위를 우선 준비하고, 그 외 기간에 기초 보완을 진행합니다.',
      '방문 수업이 가능한가요?|거주 위치와 희망 시간을 확인한 뒤 대면 수업 가능 여부를 안내합니다. 이동이 어려운 경우 온라인 수업도 협의할 수 있습니다.'
    )
  },
  [pscustomobject]@{
    Slug = 'advanced'; Name = '수학 선행 과외'; En = 'ADVANCED STUDY'
    Title = '수학 선행 과외 | 경기 초등·중등·고등 학생 맞춤 선행학습 1:1'
    Description = '경기 수학 선행 과외. 현재 학년 개념의 완성도를 먼저 확인하고 학생 속도에 맞춰 다음 학기·다음 학년 수학을 1:1로 준비합니다. 상담 010-2928-3614'
    Heading = '수학 선행<br>과외'
    Hero = '선행은 빠르게 많이 나가는 것보다 이해한 상태로 나가는 것이 중요합니다. 현재 학년 개념을 확인한 뒤 학생에게 맞는 범위와 속도로 진행합니다.'
    IntroTitle = '이해한 만큼<br>앞서가는 선행'
    Intros = @(
      '수학 선행 과외는 현재 학년 개념이 충분히 잡혀 있는지 먼저 진단합니다. 빈틈이 있는 상태에서 진도만 나가면 다음 학년에서 같은 부분을 다시 공부해야 하기 때문입니다.',
      '진단 결과에 따라 다음 학기 예습, 다음 학년 선행, 현재 학년 심화 중 학생에게 맞는 방향을 정하고, 학교 시험 기간에는 내신 준비를 우선합니다.'
    )
    Topics = @(
      '예비중1 선행|초등 과정을 마무리하고 중1 정수와 유리수, 문자와 식을 미리 익힙니다.',
      '중등 선행|현재 학년 개념을 확인한 뒤 다음 학기와 다음 학년 단원을 학생 속도에 맞춰 진행합니다.',
      '예비고1 선행|중학 전 범위를 정리하고 공통수학1·2를 차근차근 준비합니다.',
      '고등 선행|학교 과목 편성과 진도를 확인해 다음 학기 과목을 미리 준비합니다.',
      '선행과 심화의 균형|선행 속도만 높이기보다 현재 학년 심화 문제로 개념을 단단히 하는 시간도 함께 둡니다.',
      '내신 기간 조정|학교 시험 기간에는 선행을 잠시 멈추고 내신 준비에 집중합니다.'
    )
    Faqs = @(
      '선행은 어디까지 하는 것이 좋을까요?|현재 학년 개념의 완성도와 학생의 학습 속도에 따라 다르며, 진단 후 적절한 범위를 안내합니다.',
      '선행과 내신을 같이 할 수 있나요?|평소에는 선행을, 시험 기간에는 내신을 우선하는 방식으로 함께 진행합니다.',
      '선행이 학생에게 부담되지 않을까요?|이해 속도를 확인하며 진도를 조절하고, 필요하면 현재 학년 심화로 방향을 바꿉니다.',
      '방문 수업이 가능한가요?|거주 위치와 희망 시간을 확인한 뒤 대면 수업 가능 여부를 안내합니다. 이동이 어려운 경우 온라인 수업도 협의할 수 있습니다.'
    )
  }
)

$townTopics = @(
  '{P} 초등 수학과외|{P} 초등학생은 연산과 분수, 문장제처럼 자주 흔들리는 기초수학을 먼저 점검하고 스스로 하는 수학공부 습관을 만듭니다.',
  '{P} 중등 수학과외|{P} 중학생은 학교별 시험 범위와 교과서, 프린트를 확인해 수학내신과 서술형을 준비하고 비어 있는 이전 단원을 함께 보완합니다.',
  '{P} 고등 수학과외|{P} 고등학생은 내신 기출과 모의고사 결과로 취약 단원을 찾고 수학내신과 수능수학의 비중을 시기별로 정합니다.',
  '{P} 수학내신 대비|시험 4~5주 전부터 학교별 기출 유형과 부교재를 중심으로 범위를 정리하고 실전처럼 시간을 재며 풀어 봅니다.',
  '{P} 기초수학 보완|학년과 상관없이 막히는 지점을 찾아 이전 학년 단원부터 다시 세운 뒤 현재 진도와 병행합니다.',
  '{P} 예비중1 · 예비고1|학년이 바뀌는 시기에는 이전 과정을 정리하고 다음 학년 핵심 단원을 미리 경험해 첫 시험을 편안하게 준비합니다.'
)

# 주제·생활권 페이지 공통 본문
function Write-ArticlePage {
    param([string]$Path, [string]$Title, [string]$Description, $Crumbs, [string]$Eyebrow, [string]$Heading, [string]$Hero, [string]$En, [string]$IntroTitle, $Intros, $Topics, [string]$TopicHeading, $Faqs, [string]$Name, [string]$Area, $Related, [string]$RelatedHeading)
    $root = Get-Root $Path
    $topicHtml = $Topics | ForEach-Object { $t = $_.Split('|'); "          <article><h3>$($t[0])</h3><p>$($t[1])</p></article>" }
    $introHtml = ($Intros | ForEach-Object { "<p>$_</p>" }) -join ''
    $body = @"
      <section class="location-intro" aria-labelledby="intro-title">
        <div><p class="section-number">$En</p><h2 id="intro-title">$IntroTitle</h2></div>
        <div class="location-intro-copy">$introHtml</div>
      </section>
      <section class="topic-guide" aria-labelledby="topic-title">
        <p class="section-number">CURRICULUM</p><h2 id="topic-title">$TopicHeading</h2>
        <div class="topic-grid">
$($topicHtml -join "`n")
        </div>
      </section>
$lessonFlow
$(Get-FaqHtml "$Name 자주 묻는 질문" $Faqs)
$(Get-LinkGrid 'related-title' 'RELATED' $RelatedHeading $Related $root)
"@
    Write-Page -Path $Path -Title $Title -Description $Description -Crumbs $Crumbs -Eyebrow $Eyebrow -Heading $Heading -Hero $Hero -Body $body -CtaTitle "$Name 상담" -Graph @((Get-ServiceLd $Name $Description $Area $Path), (Get-FaqLd $Faqs))
}

# 시·군·구 페이지에 넣는 생활권 링크
function Get-TownSection([string]$Path, [string]$Root, [string]$Name) {
    $matched = @($towns | Where-Object { $_.Parent.StartsWith($Path) })
    if ($matched.Count -eq 0) { return '' }
    return Get-LinkGrid 'town-title' 'NEIGHBORHOOD' "$Name 인기 생활권 수학과외" @($matched | ForEach-Object { [pscustomobject]@{ Path = "towns/$($_.Slug)/"; Text = "$($_.Name) 수학과외" } }) $Root
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

    $cityDistrictNames = if ($districts.Count -gt 0) { @($districts | ForEach-Object { $_.N }) } else { @('') }

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
$(Get-SchoolSection $city $area.Name $cityDistrictNames @('초등학교', '중학교', '고등학교'))
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
$(Get-TownSection $cityPath '../..' $area.Short)
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
        Write-LevelPage $city $level $related "함께 찾는 $($area.Short) 수학과외" (Get-SchoolSection $city $area.Name $cityDistrictNames @($schoolLevelNames[$level.Slug]))
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
$(Get-SchoolSection $district $area.Name @($district.N) @('초등학교', '중학교', '고등학교'))
      <section class="grade-guide" aria-labelledby="grade-title">
        <p class="section-number">GRADE TRANSITION</p><h2 id="grade-title">다음 학년의 수학을<br>한발 먼저 준비합니다</h2>
        <div class="grade-grid">
          <article><h3>예비중1</h3><p>$($district.N) 예비중1은 초등 연산과 문장제의 빈틈을 확인하고 중학교 문자와 식의 기초를 준비합니다.</p></article>
          <article><h3>예비중2 · 예비중3</h3><p>예비중2와 예비중3은 다음 학년에 이어지는 방정식·함수·도형 개념과 이전 과정의 빈틈을 정리합니다.</p></article>
          <article><h3>예비고1</h3><p>$($district.N) 예비고1은 고등 수학의 바탕이 되는 중학 대수, 함수, 도형을 우선 점검합니다.</p></article>
          <article><h3>예비고2 · 예비고3</h3><p>예비고2와 예비고3은 선택 과목과 학교 진도, 내신·수능 목표에 맞춰 학습 순서를 구체화합니다.</p></article>
        </div>
      </section>
$(Get-TownSection $district.Path '../../..' $district.N)
$(Get-LinkGrid 'nearby-title' 'NEARBY DISTRICT' "$($area.Name) 다른 구 수학과외" $nearby '../../..')
$(Get-FaqHtml "$($district.N) 수학과외 자주 묻는 질문" $districtFaqs)
"@
        $districtTitle = "$($district.N) 수학과외 | $($district.S) 초등·중등·고등 1:1 수업"
        $districtDescription = "$($district.F) 수학과외. $($district.S) 초등 기초수학, 중등 수학내신, 고등 수능수학까지 1:1 진단 후 맞춤 수업합니다. 상담 010-2928-3614"
        Write-Page -Path $district.Path -Title $districtTitle -Description $districtDescription -Crumbs $district.Crumbs -Eyebrow $district.Eyebrow -Heading "$($district.N)<br>수학과외" -Hero $district.Focus -Body $districtBody -CtaTitle "$($district.N) 수학과외 상담" -Graph @((Get-ServiceLd "$($district.N) 수학과외" $districtDescription $district.F $district.Path), (Get-FaqLd $districtFaqs))

        foreach ($level in $levels) {
            $related = @(Get-OtherLevelLinks $district $level) + @([pscustomobject]@{ Path = $district.Path; Text = "$($district.N) 수학과외" }, [pscustomobject]@{ Path = "$cityPath$($level.Slug)/"; Text = "$($area.Short) $($level.Label) 수학과외" })
            $related += @($districts | Where-Object { $_.Slug -ne $district.Slug } | ForEach-Object { [pscustomobject]@{ Path = "$($_.Path)$($level.Slug)/"; Text = "$($_.N) $($level.Label) 수학과외" } })
            Write-LevelPage $district $level $related "함께 찾는 $($district.N) 수학과외" (Get-SchoolSection $district $area.Name @($district.N) @($schoolLevelNames[$level.Slug]))
        }
    }
}

$topicLinks = @($topicPages | ForEach-Object { [pscustomobject]@{ Path = "$($_.Slug)/"; Text = $_.Name } })
$levelHubLinks = @($levels | ForEach-Object { [pscustomobject]@{ Path = "$($_.Slug)/"; Text = "경기 $($_.Label) 수학과외" } })
$townHubLink = [pscustomobject]@{ Path = 'towns/'; Text = '신도시·생활권 수학과외' }

# 주제 페이지
foreach ($topic in $topicPages) {
    $related = @($topicLinks | Where-Object { $_.Path -ne "$($topic.Slug)/" }) + $levelHubLinks + @($townHubLink)
    Write-ArticlePage -Path "$($topic.Slug)/" -Title $topic.Title -Description $topic.Description -Crumbs @($homeCrumb, [pscustomobject]@{ Name = $topic.Name; Path = "$($topic.Slug)/" }) -Eyebrow "GYEONGGI · $($topic.En)" -Heading $topic.Heading -Hero $topic.Hero -En $topic.En -IntroTitle $topic.IntroTitle -Intros $topic.Intros -Topics $topic.Topics -TopicHeading "$($topic.Name)<br>무엇을 배우나요" -Faqs (Expand-Faqs $topic.Faqs $gyeonggi) -Name $topic.Name -Area '경기도' -Related $related -RelatedHeading '함께 찾는 수학과외'
}

# 신도시·생활권 목록 페이지
$townCrumb = [pscustomobject]@{ Name = '신도시·생활권'; Path = 'towns/' }
$townHubFaqs = Expand-Faqs $regionFaqs ([pscustomobject]@{ P = '신도시'; F = ''; N = ''; S = ''; Focus = '' })
Write-ArticlePage -Path 'towns/' -Title '경기 신도시 수학과외 | 광교·동탄·판교·일산·평촌 1:1 수학' -Description '광교, 동탄, 판교, 일산, 평촌, 위례, 미사, 다산, 운정 등 경기 신도시·생활권별 초등·중등·고등 1:1 수학과외 안내. 상담 010-2928-3614' -Crumbs @($homeCrumb, $townCrumb) -Eyebrow 'GYEONGGI · NEIGHBORHOOD' -Heading '신도시·생활권<br>수학과외' -Hero '같은 시·군 안에서도 신도시와 생활권마다 학교 일정과 이동 여건이 다릅니다. 가까운 생활권을 골라 수업 안내를 확인하세요.' -En 'NEIGHBORHOOD' -IntroTitle '생활권에 맞춘<br>수학 수업' -Intros @('신도시는 학교가 새로 생기거나 학생 수가 빠르게 늘면서 학교마다 진도와 시험 범위, 출제 경향이 다양합니다. 학생이 다니는 학교의 일정과 범위를 먼저 확인하는 것이 수업 계획의 출발점입니다.', '각 생활권 페이지에서 초등 기초수학, 중등 수학내신, 고등 수능수학 안내와 상위 시·군·구의 학교급별 수업 정보를 함께 확인할 수 있습니다.') -Topics @($towns | ForEach-Object { "$($_.Name) 수학과외|$($_.CityName) $($_.Spots) 생활권의 초등·중등·고등 1:1 수학 수업을 안내합니다." }) -TopicHeading '생활권별<br>수학과외' -Faqs $townHubFaqs -Name '신도시 수학과외' -Area '경기도' -Related (@($towns | ForEach-Object { [pscustomobject]@{ Path = "towns/$($_.Slug)/"; Text = "$($_.Name) 수학과외" } })) -RelatedHeading '생활권 바로가기'

# 신도시·생활권 페이지
foreach ($town in $towns) {
    $townPath = "towns/$($town.Slug)/"
    $place = [pscustomobject]@{ P = $town.Name; F = "$($town.CityName) $($town.Name)"; N = $town.Name; S = $town.Spots; Focus = $town.Point }
    $parentShort = $town.ParentName
    $related = @([pscustomobject]@{ Path = $town.Parent; Text = "$parentShort 수학과외" }) + @($levels | ForEach-Object { [pscustomobject]@{ Path = "$($town.Parent)$($_.Slug)/"; Text = "$parentShort $($_.Label) 수학과외" } })
    $related += @($towns | Where-Object { $_.Slug -ne $town.Slug -and $_.CityName -eq $town.CityName } | ForEach-Object { [pscustomobject]@{ Path = "towns/$($_.Slug)/"; Text = "$($_.Name) 수학과외" } })
    $related += @($topicLinks | Where-Object { $_.Path -in @('visiting/', 'online/') }) + @($townHubLink)
    $description = "$($town.CityName) $($town.Name) 수학과외. $($town.Spots) 초등 기초수학, 중등 수학내신, 고등 수능수학까지 1:1로 진단하고 수업합니다. 상담 010-2928-3614"
    Write-ArticlePage -Path $townPath -Title "$($town.Name) 수학과외 | $($town.Spots) 초등·중등·고등 1:1 수학" -Description $description -Crumbs (@($homeCrumb) + @($town.ParentCrumbs) + @([pscustomobject]@{ Name = "$($town.Name) 수학과외"; Path = $townPath })) -Eyebrow "GYEONGGI · $($town.CityName) · $($town.Name)" -Heading "$($town.Name)<br>수학과외" -Hero "$($town.CityName) $($town.Spots) 생활권 학생을 위한 초등·중등·고등 1:1 맞춤 수학 수업입니다. 최근 시험과 공부 습관을 진단한 뒤 학교 진도에 맞춰 계획을 세웁니다." -En 'NEIGHBORHOOD' -IntroTitle "$($town.Name) 학생에게<br>맞춘 수학 수업" -Intros @($town.Point, "$($town.Name) 수학과외는 최근 시험지와 교재, 평소 공부 습관을 확인하는 진단에서 시작합니다. 개념 이해, 풀이 순서, 계산 습관 중 어디에서 막혔는지 구분해 1:1 수업 계획을 세우며, 대면 수업 가능 여부는 위치와 시간을 확인한 뒤 안내하고 온라인 수업도 협의할 수 있습니다.") -Topics @($townTopics | ForEach-Object { Fill $_ $place }) -TopicHeading "$($town.Name) 초등·중등·고등<br>수학수업 안내" -Faqs (Expand-Faqs $regionFaqs $place) -Name "$($town.Name) 수학과외" -Area $place.F -Related $related -RelatedHeading "함께 찾는 $($town.Name) 수학과외"
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
