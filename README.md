 #전기화학센서 계측용 소형 리드아웃 회로

 프로젝트 개요
- 바이오센서(전기화학센서)의 미세 신호를 안정적으로 계측하기 위해 소형 리드아웃 회로를 개발
- FPGA 기반 파형 생성 및 제어, TIA·ADC 기반 신호 증폭 및 변환, 소형 4-layer PCB 설계 수행



 사용 기술
- 회로 시뮬레이션: PSPICE, LTSPICE
- PCB 설계: PADS, 4-layer 설계
- FPGA/HDL: Verilog, Vivado (UART, RAMP, ADC 제어 모듈 구현)
- 데이터 처리: Python (Moving Average, EWMA 필터 적용)


성과
- 신호 잡음30% 감소 및 전기화학센서 산화 환원 임피던스 측정 (Moving Average + EWMA 필터 적용)
- 저전력 특성 확보 및 안정적인 계측 성능 달성
- 학술대회 발표: 2025 한국정보기술학회 하계 학술대회 포스터 발표


📂 Repository Structure
- `vivado code/` : Verilog 소스코드,
- `python code/` 데이터 처리 코드
- `docs/` : 논문 PDF, 포스터, 발표 자료
- `pcb/` : PADS PCB 설계 파일


 📎 자료 링크
- [논문 PDF](docs/kics_paper.pdf)  
- [최종 포스터 PDF](docs/final_poster.pdf)  
- [발표자료 PPT](docs/readout_circuit_presentation.pdf)


#저작 웨어러블 모니터링 장비 및 어플리케이션 개발

프로젝트 개요
- 턱에 착용하는 장력(스트레인) 기반 웨어러블 센서를 이용해 저작 활동을 직접 측정
- 테이블 매트(식탁보) 형태의 압력 센서를 통해 음식 섭취량(무게 변화)을 계측하는 이중 센싱 기반 모니터링 시스템 개발
- 센서 데이터를 실시간으로 수집하여 모바일 어플리케이션에서 저작 횟수, 저작 속도, 섭취량을 시각화
- 신호 노이즈 제거 및 이벤트 검출을 위해 신호 필터링 및 저작 검출 알고리즘 적용


사용 기술

- PCB 설계 (ALTIUM)
- 턱 착용형 장력 센서(저항 변화 기반)를 이용해 저작 시 발생하는 근육 움직임 측정
- 테이블 매트 형태 압력 센서를 이용해 음식 무게 변화 측정
- MCU 기반 ADC 샘플링 및 센서 데이터 수집
- BLE 통신을 통한 모바일 어플리케이션 데이터 전송

펌웨어
- 센서 데이터 실시간 샘플링 및 전처리
- 이동 평균 기반 노이즈 제거
- 임계값 기반 저작 이벤트 검출 및 카운팅

알고리즘 / 데이터 처리
- Python 기반 신호 처리 및 데이터 분석
- Moving Average / EWMA 필터 적용
- 피크 검출 기반 저작 이벤트 분리
- 저작 속도 및 저작 패턴 분석

성과
- 신호 필터링 적용을 통해 빠른 작은 저작까지 판별
- 턱 착용형 센서를 활용한 직접 측정 방식으로 저작 이벤트 검출 안정성 확보
- 압력 센서를 결합하여 음식 섭취량(무게 변화) 측정 기능 구현
- 웨어러블 센서 데이터를 기반으로 모바일 어플리케이션 실시간 시각화 시스템 구현


📂 Repository Structure
- algorithm/ : 저작 검출 및 신호 처리 알고리즘(Python)
- docs/ : 설계 문서, 발표자료, 보고서
- PCB/ : ALTIUM 설계 사진


- 자료 링크
- 프로젝트 발표자료 : docs/presentation.pdf
- 프로젝트 보고서 : docs/report.pdf


- Contact
- GitHub : https://github.com/wayoon-03
- GitHub: [코드 저장소 바로가기](https://github.com/wayoon-03/-/tree/main)

