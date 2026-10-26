"""전국초중등학교위치표준데이터(.xls)에서 경기도 운영 학교만 뽑아 data/gyeonggi-schools.csv로 저장합니다.

사용법: python tools/extract-schools.py <전국초중등학교위치표준데이터.xls>
"""
import csv
import os
import sys

import xlrd

LEVELS = ('초등학교', '중학교', '고등학교')


def main(source):
    sheet = xlrd.open_workbook(source, encoding_override='cp949').sheet_by_index(0)
    header = sheet.row_values(1)
    col = {name: header.index(name) for name in ('학교명', '학교급구분', '운영상태', '소재지도로명주소', '시도교육청명', '데이터기준일자')}
    rows = set()
    base_date = ''
    for r in range(2, sheet.nrows):
        v = sheet.row_values(r)
        if v[col['시도교육청명']] != '경기도교육청' or v[col['운영상태']] != '운영' or v[col['학교급구분']] not in LEVELS:
            continue
        parts = v[col['소재지도로명주소']].split()
        district = parts[2] if parts[2].endswith('구') else ''
        rows.add((parts[1], district, v[col['학교급구분']], v[col['학교명']].strip()))
        base_date = max(base_date, v[col['데이터기준일자']])
    target = os.path.join(os.path.dirname(__file__), '..', 'data', 'gyeonggi-schools.csv')
    with open(target, 'w', encoding='utf-8', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(['City', 'District', 'Level', 'Name', 'BaseDate'])
        for city, district, level, name in sorted(rows, key=lambda x: (x[0], x[1], LEVELS.index(x[2]), x[3])):
            writer.writerow([city, district, level, name, base_date])
    print(f'{len(rows)} schools, base date {base_date}')


if __name__ == '__main__':
    main(sys.argv[1])
