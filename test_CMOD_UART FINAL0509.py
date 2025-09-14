import serial
import numpy as np
import random
import csv
import os
import matplotlib.pyplot as plt
import time

##main_test_menu_v6_3singal
ser = serial.Serial(
    port='COM6',
    baudrate=115200,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS
)
folder_path = "C:/Users/USER-PC/Desktop/verilog_porject/UART_test_ASIC/UART_test_ASIC/test" ## 파일 경로

def get_available_filename(base_path, base_filename, extension):
    index = 1
    while True:
        filename = f"{base_filename}_{index}.{extension}"
        file_path = os.path.join(base_path, filename)
        if not os.path.exists(file_path):
            return file_path
        index += 1

def save_2d_to_csv(data, base_path, base_filename, extension):
    output_file_path = get_available_filename(base_path, base_filename, extension)
    with open(output_file_path, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(["Row", *range(len(data[0]))])  # CSV file header
        for idx, row in enumerate(data):
            writer.writerow([idx, *row])
    print(f"Data saved to {output_file_path}")

def save_to_csv(data, base_path, base_filename, extension):
    output_file_path = get_available_filename(base_path, base_filename, extension)
    with open(output_file_path, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(["Index", "Value"])  # CSV file header
        for idx, value in enumerate(data):
            writer.writerow([idx, value])
    print(f"Data saved to {output_file_path}")



def adc_to_current(adc_value, adc_max=4095, current_range=(-100e-6, 100e-6)):
    min_current, max_current = current_range
    scale = (max_current - min_current) / adc_max  # 단위: A/LSB
    current = adc_value * scale + min_current
    return current



while True:
    try:
        menu = []
        while menu != 9 :
            print('##########################################')
            print('################# Menu ###################')
            print('##########################################')
            print('1. Ping FPGA')
            print('2. Set min')
            print('3. Set max')
            print('4. Set DC Input')
            print('5. Run Ramp')
            print('6. Run DC')
            print('7. Read Data Ramp')
            print('8. Read Data DC')
            print('9. Exit')

            menu = int(input("Choose number: "))

            if menu == 1:
                print("1. Ping FPGA")
                input_data = 1
                tx_data = input_data.to_bytes(1, 'little')
                ser.write(tx_data)
                input_data = random.randrange(1, 10)
                tx_data = input_data.to_bytes(1, 'little')
                ser.write(tx_data)
                print("ping: ", input_data)
                pong = None
                while pong is None:
                    if ser.in_waiting > 0:
                        bytes_data = ser.read(2)
                        value = (bytes_data[1] << 8) | bytes_data[0]
                        pong = value
                print('pong: ', pong)
                input("Press Enter")

            elif menu == 2:
                print("Set min")
                input_data = 2
                tx_data = input_data.to_bytes(1, 'little')
                ser.write(tx_data)
                set_min = int(input("set minimum value 16-bit integer: "))
                ser.write(set_min.to_bytes(2, 'little'))

            elif menu == 3:
                print("Set max")
                input_data = 3
                tx_data = input_data.to_bytes(1, 'little')
                ser.write(tx_data)
                set_max = int(input("set maximum value 16-bit integer: "))
                ser.write(set_max.to_bytes(2, 'little'))

            elif menu == 4:
                print("Set DC Input")
                input_data = 4
                tx_data = input_data.to_bytes(1, 'little')
                ser.write(tx_data)

                dc_input = int(input("Enter DC input value (16-bit integer): "))
                ser.write(dc_input.to_bytes(2, 'little'))



                print(f"DC input {dc_input}  sent to FPGA")

            elif menu == 5:
                print("Run Ramp")
                input_data = 5
                tx_data = input_data.to_bytes(1, 'little')
                ser.write(tx_data)

            elif menu == 6:
                print("Run DC")
                input_data = 6
                tx_data = input_data.to_bytes(1, 'little')
                ser.write(tx_data)

            elif menu == 7:
                print("Read Data Ramp")
                input_data = 7
                tx_data = input_data.to_bytes(1, 'little')
                ser.write(tx_data)
                set_length = int(input("set data length 16-bit integer: "))
                ser.write(set_length.to_bytes(2, 'little'))
                result_data = []
                num_samples = set_length
                while len(result_data) < num_samples:
                    if ser.in_waiting > 0:
                        bytes_data = ser.read(2)
                        value = (bytes_data[1] << 8) | bytes_data[0]
                        result_data.append(value)

                result_data = np.array(result_data)


                def moving_average_filter(data, window_size=20):
                    return np.convolve(data, np.ones(window_size) / window_size, mode='valid')


                def exponential_moving_average(data, alpha=0.2):
                    filtered_data = np.zeros_like(data, dtype=float)
                    filtered_data[0] = data[0]
                    for i in range(1, len(data)):
                        filtered_data[i] = alpha * data[i] + (1 - alpha) * filtered_data[i - 1]
                    return filtered_data


                filtered_data = moving_average_filter(result_data, window_size=20)
                filtered_data_ewma = exponential_moving_average(result_data, alpha=0.1)

                plt.figure(figsize=(12, 6))
                plt.plot(result_data, label="Original Data", alpha=0.5)
                plt.plot(filtered_data, label="Moving Average Filtered", linewidth=2)
                plt.plot(filtered_data_ewma, label="EWMA Filtered", linewidth=2, linestyle="dashed")
                plt.legend()
                plt.title("Filtered Data Comparison")
                plt.legend()
                plt.grid(True)
                plt.tight_layout()
                plt.show()
                base_path = "C:/Users/tlsgh/Desktop/ICLAB/2025-1/pycharm/filter result"
                extension = "csv"

                save_file = input("Save the data (y/n): ")
                if save_file.lower() == "y":
                    save_to_csv(result_data, base_path, "adc_out_raw", extension)
                    save_to_csv(filtered_data, base_path, "adc_out_filtered", extension)
                    save_to_csv(filtered_data_ewma, base_path, "adc_out_filtered_ewma", extension)

            elif menu == 8:
                print("Read Data DC")
                input_data = 8
                tx_data = input_data.to_bytes(1, 'little')
                ser.write(tx_data)
                set_length = int(input("set data length 16-bit integer: "))
                ser.write(set_length.to_bytes(2, 'little'))

                result_data = []  # 데이터를 저장할 리스트

                # UART로부터 set_length 개수만큼 데이터 받기
                num_samples = set_length
                while len(result_data) < num_samples:
                    if ser.in_waiting > 0:
                        bytes_data = ser.read(2)
                        value = (bytes_data[1] << 8) | bytes_data[0]  # 1바이트를 16비트 정수로 변환
                        result_data.append(value)

                result_data = np.array(result_data)  # 리스트를 NumPy 배열로 변환


                # 필터링 적용
                def moving_average_filter(data, window_size=20):  # 입력된 data를 window_size 크기의 이동 평균 필터를 적용하여 평활화
                    """이동 평균 필터 (Moving Average Filter)"""
                    return np.convolve(data, np.ones(window_size) / window_size, mode='valid')
                    # 크기가 window_size인 배열을 만들고, 각각 1/window_size로 나눠서 평균을 구하는 커널을 생성


                def exponential_moving_average(data, alpha=0.4):
                    ema = [data[0]]  # 첫 값은 그대로 사용
                    for val in data[1:]:
                        ema.append(alpha * val + (1 - alpha) * ema[-1])
                    return np.array(ema)

                # 시간축 생성
                time_step = 1.734e-6
                time_axis = np.arange(0, len(result_data)) * time_step

                # 원시 데이터로부터 전류 계산
                current_data = np.array([adc_to_current(adc_value) * 1e6 for adc_value in result_data])  # A → µA

                # 각 필터 적용
                filtered_current_ma = moving_average_filter(current_data, window_size=20)
                filtered_current_ewma = exponential_moving_average(current_data, alpha=0.4)

                # 시각화
                plt.figure(figsize=(12, 6))
                plt.plot(time_axis, current_data, label="Raw Current (A)", alpha=0.5)
                plt.plot(time_axis[:len(filtered_current_ma)], filtered_current_ma, label="Moving Average")
                #plt.plot(time_axis, filtered_current_ewma, label="EWMA", linestyle="dashed")
                plt.xlabel("Time (s)")
                plt.ylabel("Current (µA)")  # 단위 변경
                plt.title("Current Signal - Filter Comparison")
                plt.legend()
                plt.grid(True)
                plt.tight_layout()
                plt.show()

                base_path = "C:/Users/tlsgh/Desktop/ICLAB/2025-1/pycharm/filter result"
                extension = "csv"

                save_file = input("Save the data (y/n): ")
                if save_file.lower() == "y":
                    save_to_csv(current_data, base_path, "adc_out_current_dataw", extension)
                    save_to_csv(filtered_current_ma, base_path, "adc_out_filtered_current_ma", extension)
                   # save_to_csv(filtered_current_ewma, base_path, "adc_out_filtered_current_ewma", extension)
    except KeyboardInterrupt:
        break

ser.close()