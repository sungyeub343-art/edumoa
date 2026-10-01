$ErrorActionPreference = 'Stop'

$siteUrl = 'https://edumoa.kr'
$utf8 = New-Object System.Text.UTF8Encoding($false)

$areas = @(
  [pscustomobject]@{ Slug = 'suwon-si'; Name = '수원시'; Focus = '영통·광교·장안·권선 생활권의 학교별 진도와 시험 일정을 함께 살핍니다.'; Districts = @('gwonseon-gu|권선구|호매실·금곡·권선·세류 생활권의 학교 진도와 학습 이동을 고려합니다.','yeongtong-gu|영통구|영통·망포·광교 생활권의 학교별 내신 일정과 학습 목표를 반영합니다.','jangan-gu|장안구|정자·천천·조원·연무 생활권의 학교 진도와 취약 단원을 확인합니다.','paldal-gu|팔달구|인계·매교·화서·우만 생활권의 내신 범위와 학생별 진도를 살핍니다.') },
  [pscustomobject]@{ Slug = 'seongnam-si'; Name = '성남시'; Focus = '분당·판교와 수정·중원 지역의 학습 환경을 고려해 학생별 계획을 세웁니다.'; Districts = @('bundang-gu|분당구|분당·판교 생활권의 학교별 진도와 내신 일정을 바탕으로 계획합니다.','sujeong-gu|수정구|위례·신흥·태평·수진 생활권의 학교 일정과 취약 개념을 함께 점검합니다.','jungwon-gu|중원구|성남·금광·은행·하대원 생활권의 학습 환경과 학생별 진도를 반영합니다.') },
  [pscustomobject]@{ Slug = 'goyang-si'; Name = '고양시'; Focus = '일산동구·일산서구·덕양구의 학교 진도와 통학 여건에 맞춰 수업을 조정합니다.'; Districts = @('deogyang-gu|덕양구|화정·행신·삼송·원흥 생활권의 학교 진도와 이동 여건을 고려합니다.','ilsandong-gu|일산동구|백석·마두·정발산·식사 생활권의 내신 일정과 학습 목표를 반영합니다.','ilsanseo-gu|일산서구|주엽·대화·탄현·가좌 생활권의 학교별 시험 범위와 취약점을 확인합니다.') },
  [pscustomobject]@{ Slug = 'yongin-si'; Name = '용인시'; Focus = '수지·기흥·처인 지역의 학교별 진도와 학생의 이동 여건을 함께 고려합니다.'; Districts = @('giheung-gu|기흥구|보정·동백·구갈·영덕 생활권의 학교 진도와 학습 목표를 살핍니다.','suji-gu|수지구|죽전·풍덕천·상현·성복 생활권의 학교별 내신 일정과 진도를 반영합니다.','cheoin-gu|처인구|김량장·역북·고림과 읍면 지역의 이동 여건과 학교 진도를 고려합니다.') },
  [pscustomobject]@{ Slug = 'bucheon-si'; Name = '부천시'; Focus = '원미·소사·오정 생활권의 내신 일정과 현재 학습 수준을 기준으로 수업합니다.'; Districts = @('sosa-gu|소사구|소사본·범박·옥길·괴안 생활권의 학교 진도와 취약 단원을 점검합니다.','ojeong-gu|오정구|원종·고강·오정·삼정 생활권의 학교 일정과 학생별 목표를 반영합니다.','wonmi-gu|원미구|중동·상동·심곡·역곡 생활권의 내신 범위와 현재 학습 수준을 살핍니다.') },
  [pscustomobject]@{ Slug = 'ansan-si'; Name = '안산시'; Focus = '상록구와 단원구의 학교별 진도 차이를 확인해 필요한 단원부터 정리합니다.'; Districts = @('danwon-gu|단원구|고잔·초지·선부·와동 생활권의 학교별 진도와 내신 일정을 확인합니다.','sangnok-gu|상록구|본오·사동·성포·일동 생활권의 취약 개념과 학습 목표를 함께 살핍니다.') },
  [pscustomobject]@{ Slug = 'anyang-si'; Name = '안양시'; Focus = '동안구와 만안구의 학습 환경, 학교 일정과 학생의 목표를 함께 반영합니다.'; Districts = @('dongan-gu|동안구|평촌·호계·비산·관양 생활권의 학교별 내신 일정과 진도를 반영합니다.','manan-gu|만안구|안양·석수·박달 생활권의 학교 진도와 학생별 취약 단원을 확인합니다.') },
    [pscustomobject]@{ Slug = 'namyangju-si'; Name = '남양주시'; Focus = '다산·별내·호평·평내 등 생활권별 이동 시간과 학교 진도를 고려합니다.' },
    [pscustomobject]@{ Slug = 'hwaseong-si'; Name = '화성시'; Focus = '동탄·병점·향남·봉담 등 넓은 생활권의 수업 가능 시간과 학습 목표를 조율합니다.'; Districts = @('dongtan-gu|동탄구|동탄 생활권의 학교별 진도와 내신 일정, 학생의 학습 목표를 반영합니다.','manse-gu|만세구|향남·남양·마도·송산 생활권의 이동 여건과 학교 진도를 함께 고려합니다.','byeongjeom-gu|병점구|병점·진안·반월·동탄 서부 생활권의 학교 일정과 취약 단원을 점검합니다.','hyohaeng-gu|효행구|봉담·정남·매송 생활권의 학교별 진도와 수업 가능 시간을 조율합니다.') },
    [pscustomobject]@{ Slug = 'pyeongtaek-si'; Name = '평택시'; Focus = '비전·고덕·송탄·안중 생활권의 학교 일정과 학생별 진도를 세심하게 확인합니다.' },
    [pscustomobject]@{ Slug = 'uijeongbu-si'; Name = '의정부시'; Focus = '민락·신곡·호원·가능 생활권의 내신 진도와 취약 단원을 함께 점검합니다.' },
    [pscustomobject]@{ Slug = 'siheung-si'; Name = '시흥시'; Focus = '배곧·정왕·은행·목감 등 지역별 학교 일정과 학습 환경에 맞춰 계획합니다.' },
    [pscustomobject]@{ Slug = 'paju-si'; Name = '파주시'; Focus = '운정·교하·금촌·문산 생활권의 이동 여건과 학교별 진도를 함께 살핍니다.' },
    [pscustomobject]@{ Slug = 'gimpo-si'; Name = '김포시'; Focus = '한강신도시와 사우·풍무·고촌 지역의 학교 진도와 학습 목표를 연결합니다.' },
    [pscustomobject]@{ Slug = 'gwangmyeong-si'; Name = '광명시'; Focus = '철산·하안·소하·광명 생활권의 내신 일정과 학생별 취약점을 반영합니다.' },
    [pscustomobject]@{ Slug = 'gwangju-si'; Name = '광주시'; Focus = '경안·태전·오포·곤지암 생활권의 이동 여건과 학교 진도를 고려합니다.' },
    [pscustomobject]@{ Slug = 'gunpo-si'; Name = '군포시'; Focus = '산본·당동·부곡 생활권의 학교별 시험 범위와 현재 학습 수준을 확인합니다.' },
    [pscustomobject]@{ Slug = 'hanam-si'; Name = '하남시'; Focus = '미사·감일·위례·신장 생활권의 학교 진도와 학생의 목표를 함께 반영합니다.' },
    [pscustomobject]@{ Slug = 'osan-si'; Name = '오산시'; Focus = '세교·원동·오산 생활권의 학교 일정에 맞춰 개념과 내신 준비를 연결합니다.' },
    [pscustomobject]@{ Slug = 'icheon-si'; Name = '이천시'; Focus = '증포·부발·창전과 읍면 지역의 이동 여건을 고려해 꾸준한 학습 계획을 세웁니다.' },
    [pscustomobject]@{ Slug = 'anseong-si'; Name = '안성시'; Focus = '공도·아양·대덕과 읍면 지역의 학교 진도, 수업 가능 시간을 함께 조율합니다.' },
    [pscustomobject]@{ Slug = 'uiwang-si'; Name = '의왕시'; Focus = '내손·포일·오전·고천 생활권의 학교 일정과 학습 수준에 맞춰 수업합니다.' },
    [pscustomobject]@{ Slug = 'yangpyeong-gun'; Name = '양평군'; Focus = '양평읍과 각 면 지역의 이동 거리, 온라인 수업 가능 여부를 함께 고려합니다.' },
    [pscustomobject]@{ Slug = 'yeoju-si'; Name = '여주시'; Focus = '여주 도심과 읍면 지역의 학교 진도, 수업 가능 시간에 맞춰 계획을 조정합니다.' },
    [pscustomobject]@{ Slug = 'dongducheon-si'; Name = '동두천시'; Focus = '지행·송내·생연 생활권의 학교별 진도와 취약 단원을 중심으로 학습합니다.' },
    [pscustomobject]@{ Slug = 'gwacheon-si'; Name = '과천시'; Focus = '중앙·별양·원문 생활권의 학교 일정과 학생별 목표를 바탕으로 수업합니다.' },
    [pscustomobject]@{ Slug = 'gapyeong-gun'; Name = '가평군'; Focus = '가평읍과 각 면 지역의 이동 여건을 살피고 대면·온라인 수업을 협의합니다.' },
    [pscustomobject]@{ Slug = 'yeoncheon-gun'; Name = '연천군'; Focus = '전곡·연천과 각 면 지역의 거리, 학교 진도를 고려해 현실적인 계획을 세웁니다.' },
    [pscustomobject]@{ Slug = 'pocheon-si'; Name = '포천시'; Focus = '소흘·신읍과 읍면 지역의 이동 시간, 학교별 진도를 함께 확인합니다.' },
    [pscustomobject]@{ Slug = 'yangju-si'; Name = '양주시'; Focus = '옥정·회천·고읍·백석 생활권의 학교 일정과 학생의 현재 단계를 반영합니다.' },
    [pscustomobject]@{ Slug = 'guri-si'; Name = '구리시'; Focus = '갈매·인창·수택·교문 생활권의 내신 일정과 취약 개념을 함께 점검합니다.' }
)

function Write-Utf8File([string]$Path, [string]$Content) {
    $directory = Split-Path -Parent $Path
    if (-not (Test-Path $directory)) { New-Item -ItemType Directory -Path $directory -Force | Out-Null }
    [System.IO.File]::WriteAllText($Path, $Content, $utf8)
}

function Get-Head([string]$Title, [string]$Description, [string]$Canonical, [string]$AssetPath) {
    return @"
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>$Title</title>
  <meta name="description" content="$Description">
  <meta name="theme-color" content="#123c43">
  <meta property="og:type" content="website">
  <meta property="og:title" content="$Title">
  <meta property="og:description" content="$Description">
  <meta property="og:url" content="$Canonical">
  <link rel="canonical" href="$Canonical">
  <link rel="icon" href="$AssetPath/favicon.svg" type="image/svg+xml">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@700&family=Pretendard:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="$AssetPath/styles.css">
"@
}

$urls = [System.Collections.Generic.List[string]]::new()
$urls.Add("$siteUrl/")

foreach ($area in $areas) {
    $canonical = "$siteUrl/areas/$($area.Slug)/"
    $urls.Add($canonical)
    $title = "$($area.Name) 수학과외 | 경기 초중고 1:1 맞춤 수업"
    $description = "경기 $($area.Name) 초중고 수학과외. 예비중1, 예비중2, 예비중3, 예비고1, 예비고2, 예비고3 학생별 진단과 계획으로 수업합니다."
    $head = Get-Head $title $description $canonical '../..'
    $districtSection = ''
    if ($area.PSObject.Properties.Name -contains 'Districts') {
        $districtLinks = $area.Districts | ForEach-Object {
            $districtParts = $_.Split('|')
            "          <a href=`"$($districtParts[0])/`"><span>$($districtParts[1]) 수학과외</span><span aria-hidden=`"true`">→</span></a>"
        }
        $districtSection = @"
      <section class="local-list" aria-labelledby="district-title">
        <p class="section-number">DISTRICT GUIDE</p><h2 id="district-title">$($area.Name) 구별 수학과외</h2>
        <div class="area-links">$($districtLinks -join "`n")</div>
      </section>
"@
    }
    $html = @"
<!doctype html>
<html lang="ko">
<head>
$head</head>
<body class="location-page">
  <a class="skip-link" href="#main">본문으로 바로가기</a>
  <header class="site-header">
    <a class="brand" href="../../" aria-label="경기 수학과외 홈"><span class="brand-mark" aria-hidden="true">∑</span><span>경기 수학과외</span></a>
    <nav class="desktop-nav" aria-label="주요 메뉴"><a href="../../#approach">수업 방식</a><a href="../../#program">학년별 수업</a><a href="../../#area">수업 지역</a></nav>
    <a class="header-cta" href="tel:010-2928-3614" aria-label="010-2928-3614로 전화하기">010-2928-3614</a>
  </header>
  <main class="location-main" id="main">
    <section class="location-hero">
      <nav class="breadcrumbs" aria-label="현재 위치"><a href="../../">경기도</a><span>/</span><strong>$($area.Name)</strong></nav>
      <p class="eyebrow">GYEONGGI · $($area.Name)</p>
      <h1>$($area.Name)<br>수학과외</h1>
      <p>$($area.Focus)</p>
    </section>
    <div class="location-layout">
      <section class="location-intro" aria-labelledby="intro-title">
        <div><p class="section-number">LOCAL TUTORING</p><h2 id="intro-title">학교 진도와<br>학생의 속도를 함께</h2></div>
        <div class="location-intro-copy"><p>경기 $($area.Name) 수학과외는 최근 시험지와 사용하는 교재, 평소 공부 시간을 확인하는 진단에서 시작합니다. 같은 학년이라도 개념의 빈틈과 목표가 다르므로 설명 방식과 과제량을 학생별로 조정합니다.</p><p>초등 수학의 개념과 연산, 중등 내신의 서술형 풀이, 고등 수학의 개념 연결과 문제 해석까지 지금 필요한 단계에 집중합니다.</p><p>$($area.Focus) 대면 수업 가능 여부와 시간은 상담 후 안내하며, 학습 상황에 따라 온라인 수업도 협의할 수 있습니다.</p></div>
      </section>
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
      <section class="lesson-flow" aria-labelledby="flow-title">
        <p class="section-number">LESSON FLOW</p><h2 id="flow-title">진단에서 복습까지</h2>
        <ol><li><strong>학습 상담</strong><span>학년과 목표, 최근 고민을 확인합니다.</span></li><li><strong>취약점 진단</strong><span>개념·풀이·계산 중 막힌 지점을 찾습니다.</span></li><li><strong>맞춤 수업</strong><span>학교 진도와 학생 속도에 맞춰 설명합니다.</span></li><li><strong>주간 점검</strong><span>오답과 과제를 바탕으로 계획을 조정합니다.</span></li></ol>
      </section>
    $districtSection
      <section class="location-cta"><div><p class="section-number">CONTACT</p><h2>$($area.Name) 수학과외 상담</h2></div><a class="button" href="tel:010-2928-3614">전화 상담 010-2928-3614</a></section>
    </div>
  </main>
  <footer><a class="brand footer-brand" href="../../"><span class="brand-mark" aria-hidden="true">∑</span><span>경기 수학과외</span></a><p>학생의 이해에서 시작하는 1:1 맞춤 수업</p><p class="copyright">© 2026 경기 수학과외</p></footer>
</body>
</html>
"@
    Write-Utf8File (Join-Path $PSScriptRoot "areas\$($area.Slug)\index.html") $html

    if ($area.PSObject.Properties.Name -contains 'Districts') {
        foreach ($districtEntry in $area.Districts) {
            $districtParts = $districtEntry.Split('|')
            $districtSlug = $districtParts[0]
            $districtName = $districtParts[1]
            $districtFocus = $districtParts[2]
            $districtCanonical = "$canonical$districtSlug/"
            $urls.Add($districtCanonical)
            $districtTitle = "$districtName 수학과외 | 경기 $($area.Name) 초중고 1:1 수업"
            $districtDescription = "경기 $($area.Name) $districtName 초중고 수학과외. 예비중1, 예비중2, 예비중3, 예비고1, 예비고2, 예비고3 학생별 맞춤 수업을 안내합니다."
            $districtHead = Get-Head $districtTitle $districtDescription $districtCanonical '../../..'
            $nearbyLinks = $area.Districts | Where-Object { $_ -ne $districtEntry } | ForEach-Object {
                $nearbyParts = $_.Split('|')
                "          <a href=`"../$($nearbyParts[0])/`"><span>$($nearbyParts[1]) 수학과외</span><span aria-hidden=`"true`">→</span></a>"
            }
            $districtHtml = @"
<!doctype html>
<html lang="ko">
<head>
$districtHead</head>
<body class="location-page">
  <a class="skip-link" href="#main">본문으로 바로가기</a>
  <header class="site-header">
    <a class="brand" href="../../../" aria-label="경기 수학과외 홈"><span class="brand-mark" aria-hidden="true">∑</span><span>경기 수학과외</span></a>
    <nav class="desktop-nav" aria-label="주요 메뉴"><a href="../../../#approach">수업 방식</a><a href="../../../#program">학년별 수업</a><a href="../../../#area">수업 지역</a></nav>
    <a class="header-cta" href="tel:010-2928-3614" aria-label="010-2928-3614로 전화하기">010-2928-3614</a>
  </header>
  <main class="location-main" id="main">
    <section class="location-hero">
      <nav class="breadcrumbs" aria-label="현재 위치"><a href="../../../">경기도</a><span>/</span><a href="../">$($area.Name)</a><span>/</span><strong>$districtName</strong></nav>
      <p class="eyebrow">GYEONGGI · $($area.Name) · $districtName</p>
      <h1>$districtName<br>수학과외</h1>
      <p>$districtFocus</p>
    </section>
    <div class="location-layout">
      <section class="location-intro" aria-labelledby="intro-title">
        <div><p class="section-number">LOCAL TUTORING</p><h2 id="intro-title">가까운 곳에서<br>꾸준히 배우는 수학</h2></div>
        <div class="location-intro-copy"><p>경기 $($area.Name) $districtName 수학과외는 최근 시험지와 교재, 평소 공부 습관을 먼저 확인합니다. 정답 개수만 보지 않고 개념 이해, 풀이 순서, 계산 습관 중 어디에서 막혔는지 구분해 수업 계획을 세웁니다.</p><p>$districtFocus 대면 수업 가능 여부와 시간은 학생의 학년과 위치에 따라 상담 후 안내하며 온라인 수업도 협의할 수 있습니다.</p></div>
      </section>
      <section class="grade-guide" aria-labelledby="grade-title">
        <p class="section-number">GRADE TRANSITION</p><h2 id="grade-title">다음 학년의 수학을<br>한발 먼저 준비합니다</h2>
        <div class="grade-grid">
          <article><h3>예비중1</h3><p>$districtName 예비중1은 초등 연산과 문장제의 빈틈을 확인하고 중학교 문자와 식의 기초를 준비합니다.</p></article>
          <article><h3>예비중2 · 예비중3</h3><p>예비중2와 예비중3은 다음 학년에 이어지는 방정식·함수·도형 개념과 이전 과정의 빈틈을 정리합니다.</p></article>
          <article><h3>예비고1</h3><p>$districtName 예비고1은 고등 수학의 바탕이 되는 중학 대수, 함수, 도형을 우선 점검합니다.</p></article>
          <article><h3>예비고2 · 예비고3</h3><p>예비고2와 예비고3은 선택 과목과 학교 진도, 내신·수능 목표에 맞춰 학습 순서를 구체화합니다.</p></article>
        </div>
      </section>
      <section class="local-list" aria-labelledby="nearby-title"><p class="section-number">NEARBY DISTRICT</p><h2 id="nearby-title">$($area.Name) 다른 구 수학과외</h2><div class="area-links">$($nearbyLinks -join "`n")</div></section>
      <section class="location-cta"><div><p class="section-number">CONTACT</p><h2>$districtName 수학과외 상담</h2></div><a class="button" href="tel:010-2928-3614">전화 상담 010-2928-3614</a></section>
    </div>
  </main>
  <footer><a class="brand footer-brand" href="../../../"><span class="brand-mark" aria-hidden="true">∑</span><span>경기 수학과외</span></a><p>학생의 이해에서 시작하는 1:1 맞춤 수업</p><p class="copyright">© 2026 경기 수학과외</p></footer>
</body>
</html>
"@
            Write-Utf8File (Join-Path $PSScriptRoot "areas\$($area.Slug)\$districtSlug\index.html") $districtHtml
        }
    }
}

$sitemapEntries = $urls | ForEach-Object { "  <url><loc>$_</loc><lastmod>2026-10-01</lastmod></url>" }
$sitemap = @"
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
$($sitemapEntries -join "`n")
</urlset>
"@
Write-Utf8File (Join-Path $PSScriptRoot 'sitemap.xml') $sitemap
$districtCount = ($areas | Where-Object { $_.PSObject.Properties.Name -contains 'Districts' } | ForEach-Object { $_.Districts.Count } | Measure-Object -Sum).Sum
Write-Output "Generated $($areas.Count) city and county pages and $districtCount district pages."