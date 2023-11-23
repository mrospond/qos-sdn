import csv
from datetime import datetime
import sys

def analyze_traffic(file_path):
    inter_arrival_times = []
    previous_timestamp = None

    with open(file_path, 'r') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            timestamp_str, _, packet_length_str = row
            timestamp = datetime.strptime(timestamp_str, "%Y-%m-%d %H:%M:%S.%f")

            if previous_timestamp is not None:
                inter_arrival_time = (timestamp - previous_timestamp).total_seconds()
                inter_arrival_times.append(inter_arrival_time)

            previous_timestamp = timestamp

    return inter_arrival_times

# Replace with the path to your captured CSV file
file_path = sys.argv[1]
inter_arrival_times = analyze_traffic(file_path)

# Perform further analysis and calculations as needed
average_inter_arrival_time = sum(inter_arrival_times) / len(inter_arrival_times)
jitter = sum(abs(x - average_inter_arrival_time) for x in inter_arrival_times) / len(inter_arrival_times)

print(f"Average Inter-Arrival Time: {average_inter_arrival_time} seconds")
print(f"Jitter: {jitter} seconds")
