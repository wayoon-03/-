# Jibbitz Gait Monitoring System

IMU 센서를 활용한 **지비츠(Jibbitz) 형태의 어린이 보행 모니터링 시스템** 개발 프로젝트입니다.  

기존 보행 분석 장치는 착용 불편으로 장기간 사용이 어려운 문제가 있습니다.  
본 프로젝트에서는 **신발 장식 형태의 센서 모듈**을 설계하여 사용자 거부감을 줄이고  
실시간 보행 데이터를 수집·분석하는 시스템을 구현했습니다.

---

# System Overview

본 시스템은 IMU 센서를 이용하여 발의 **Yaw 각도 변화를 측정**하고  
BLE 통신을 통해 보행 데이터를 실시간으로 전송합니다.

수집된 데이터를 기반으로 정상 보행, 내반 보행, 외반 보행 패턴을 분석합니다.

---

# Key Features

- IMU 기반 보행 각도(Yaw) 측정
- BLE 기반 실시간 데이터 전송
- Gyroscope 기반 보행 각도 계산
- Exponential smoothing 기반 노이즈 제거
- Drift compensation 적용
- 보행 패턴 분석 (Normal / In-toeing / Out-toeing)

---

# System Architecture

```

IMU Sensor
↓
Gyroscope Data Acquisition
↓
Yaw Angle Calculation
↓
Noise Filtering & Drift Compensation
↓
BLE Transmission
↓
Application / Data Visualization

```

---

# Algorithm

보행 각도 계산은 Gyroscope 데이터를 기반으로 수행됩니다.

Yaw 각도 계산

```

yawAngle = yawAngle + gZ * deltaTime

```

Noise filtering (Exponential smoothing)

```

yawAngle = α * previous + (1-α) * measurement

```

Drift compensation

```

if(abs(yawAngle) < threshold) yawAngle = 0

```

알고리즘 코드  
📂 [algorithm](algorithm/)

---

# Documents

프로젝트 관련 논문 및 발표 자료

📂 [docs](docs/)

---

# Tech Stack

Embedded System  
- BLE
- BMI270 IMU

Sensor  
- IMU (Gyroscope)

Communication  
- Bluetooth Low Energy (BLE)

Programming  
- C++ (Arduino)

---

# Author

GitHub  
https://github.com/wayoon-03

