# 경기 수학과외

`edumoa.kr`에 배포하는 경기 지역 1:1 수학과외 홈페이지입니다.

## 구성

- 학생별 수업 방식과 학년별 프로그램 안내
- 예비중1, 예비중2, 예비중3, 예비고1, 예비고2, 예비고3 과정 소개
- 경기도 31개 시·군별 수학과외 페이지
- 고양·부천·성남·수원·안산·안양·용인·화성 24개 구별 수학과외 페이지
- 경기 전체와 각 시·군·구별 초등·중등·고등 수학과외 페이지
- 구조화 데이터(JSON-LD), 네이버 서치어드바이저 제출용 `rss.xml`
- GitHub Pages용 `CNAME`, 사이트맵, robots 설정

GitHub Pages에서 별도 빌드 없이 정적 파일을 직접 배포합니다.

지역·학교급 페이지와 `sitemap.xml`, `rss.xml`은 `generate-location-pages.ps1`로 생성합니다. 페이지 내용을 바꿀 때는 생성된 HTML이 아니라 스크립트를 수정한 뒤 다시 실행하세요.

```powershell
powershell -ExecutionPolicy Bypass -File .\generate-location-pages.ps1
```