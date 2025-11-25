import sys
import time
import statistics
from concurrent.futures import ThreadPoolExecutor, as_completed

import requests

def send_request(session, url, idx):
    start = time.perf_counter()       # 고정밀, 단조 증가, sec 단위
    resp = session.get(url)
    elapsed = time.perf_counter() - start   # sec 단위
    return idx, resp.status_code, elapsed

def main():
    if len(sys.argv) < 2:
        print("Usage: python load_test.py <URL> [NUM_REQUESTS] [CONCURRENCY]")
        sys.exit(1)

    url = sys.argv[1]
    num_requests = int(sys.argv[2]) if len(sys.argv) > 2 else 100
    concurrency = int(sys.argv[3]) if len(sys.argv) > 3 else 50

    print(f"Target URL      : {url}")
    print(f"Total requests  : {num_requests}")
    print(f"Concurrency     : {concurrency}")

    latencies = []

    start_all = time.perf_counter()   # 전체 시작 시각
    with requests.Session() as session:
        with ThreadPoolExecutor(max_workers=concurrency) as executor:
            futures = [
                executor.submit(send_request, session, url, i)
                for i in range(num_requests)
            ]

            for f in as_completed(futures):
                idx, status, elapsed = f.result()
                latencies.append(elapsed)

    total_time = time.perf_counter() - start_all   # 전체 걸린 시간(sec)

    print("\n==== RESULT ====")
    print(f"Total time           : {total_time:.6f} s")                  # sec
    print(f"Avg latency          : {statistics.mean(latencies):.6f} s")  # sec
    print(f"Median latency       : {statistics.median(latencies):.6f} s")# sec
    print(f"Max latency          : {max(latencies):.6f} s")              # sec
    print(f"Min latency          : {min(latencies):.6f} s")              # sec
    print(f"Requests per second  : {num_requests / total_time:.2f} req/s")

if __name__ == "__main__":
    main()

