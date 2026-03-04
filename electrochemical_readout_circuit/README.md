## Electrochemical Sensor Readout Circuit
전기화학센서 계측용 소형 리드아웃 회로

---

### 프로젝트 개요
- 바이오센서(전기화학센서)의 **미세 신호를 안정적으로 계측하기 위한 소형 리드아웃 회로** 개발
- **FPGA 기반 파형 생성 및 제어**
- **TIA + ADC 기반 신호 증폭 및 변환**
- **소형 4-layer PCB 설계**

---

### 사용 기술

**Circuit / Hardware**
- PSPICE, LTSPICE (회로 시뮬레이션)
- PADS (4-layer PCB 설계)

**FPGA / Digital**
- Verilog, Vivado
- UART 통신 모듈
- RAMP 파형 생성 모듈
- ADC 제어 로직

**Data Processing**
- Python 기반 데이터 처리
- Moving Average Filter
- EWMA Filter

---

### 성과
- 신호 필터링을 통해 **노이즈 약 30% 감소**
- 전기화학센서 **산화·환원 임피던스 측정 구현**
- **저전력 특성 확보 및 안정적인 계측 성능 달성**
- **2025 한국정보기술학회 하계 학술대회 포스터 발표**

---

### Repository Structure
electrochemical_readout_circuit/
│
├ vivado/ : Verilog source code
├ python/ : 데이터 처리 및 필터링 코드
├ pcb/ : PADS PCB 설계 파일
└ docs/ : 논문, 포스터, 발표자료


---

### 자료 링크
- [논문 PDF](docs/kics_paper.pdf)
- [최종 포스터 PDF](docs/final_poster.pdf)
- [발표자료 PPT](docs/readout_circuit_presentation.pdf)

---

### Project Repository
[electrochemical_readout_circuit](electrochemical_readout_circuit/)
