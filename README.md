 전기화학센서 계측용 소형 리드아웃 회로

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
- [Verilog 코드](vivado_code/test_CMOD_UART FINAL0509.py)  
- [Python 코드](python_code/)  


📬 Contact

- GitHub: [저장소 바로가기](https://github.com/wayoon-03/-/tree/main)

