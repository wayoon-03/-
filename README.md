# Biomedical & Embedded Systems Projects

전자회로 설계, FPGA 기반 신호처리, 바이오센서 계측 및 웨어러블 시스템 개발 프로젝트를 정리한 저장소입니다.

센서 인터페이스 회로 설계, FPGA 제어 로직 구현, PCB 설계, 임베디드 센서 시스템 개발 및 데이터 분석을 중심으로 프로젝트를 수행했습니다.


---

# Tech Stack

- **FPGA / HDL** : Verilog, Vivado  
- **Circuit Simulation** : PSPICE, LTSPICE  
- **PCB Design** : PADS (4-layer PCB)  
- **Embedded System** : Arduino, BLE Sensor Interface  
- **Sensor System** : IMU, Load Cell, Electrochemical Sensor  
- **Data Processing** : Python (Signal Filtering, Data Analysis)  


---

# Projects


## Electrochemical Sensor Readout Circuit

바이오센서의 미세 전기화학 신호를 안정적으로 계측하기 위한 **소형 리드아웃 회로 시스템 개발**

### Key Features

- FPGA 기반 Ramp / DC 파형 생성 및 제어
- TIA 기반 전류-전압 변환 회로 설계
- ADC 기반 신호 계측 시스템 구현
- Python 기반 데이터 필터링 (Moving Average, EWMA)
- 4-layer PCB 설계 및 노이즈 저감 구조 설계

📂 Project Folder  
[electrochemical_readout_circuit](electrochemical_readout_circuit/)


---

## Chewing Wearable Monitoring System

턱 착용형 장력 센서를 활용한 **저작 활동 모니터링 웨어러블 시스템 개발**

음식 섭취량과 저작 활동 데이터를 결합하여 식습관 분석을 위한 시스템을 구현했습니다.

### Key Features

- 턱 장력 센서를 이용한 저작 이벤트 감지
- 음식 섭취량 측정을 위한 압력 센서(Load Cell) 시스템
- BLE 기반 데이터 전송
- 저작 데이터 분석 알고리즘 구현
- 어플리케이션 기반 데이터 시각화

📂 Project Folder  
[chewing_wearable_monitoring_system](chewing_wearable_monitoring_system/)


---

## Jibbitz Gait Monitoring System

크록스 액세서리 **지비츠(Jibbitz) 형태의 센서 모듈을 활용한 어린이 보행 모니터링 시스템 개발**

기존 보행 분석 장치의 착용 불편 문제를 해결하기 위해 신발 장식 형태의 센서 모듈을 설계했습니다.

### Key Features

- IMU 센서 기반 보행 각도 측정
- BLE 기반 실시간 데이터 전송
- 지수평활 필터 기반 노이즈 제거
- 스마트폰 GUI 기반 보행 데이터 시각화
- 정상 / 내반 / 외반 보행 패턴 분석

📂 Project Folder  
[jibbitz_gait_monitoring_system](jibbitz_gait_monitoring_system/)


---

# Author

GitHub : https://github.com/wayoon-03
