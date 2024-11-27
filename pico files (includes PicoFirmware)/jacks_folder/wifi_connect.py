import network
import time

def connect_wifi():
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)

    ssid = "ShamWoW"  # Replace with your Wi-Fi SSID
    password = "Magnolia1302"  # Replace with your Wi-Fi password

    if not wlan.isconnected():
        print(f"Connecting to Wi-Fi network {ssid}...")
        wlan.connect(ssid, password)

        max_retries = 10
        retries = 0

        while not wlan.isconnected() and retries < max_retries:
            print(f"Connecting... Attempt {retries + 1}/{max_retries}")
            time.sleep(1)
            retries += 1

        if wlan.isconnected():
            print(f"Connected to Wi-Fi: {wlan.ifconfig()}")
        else:
            print("Failed to connect to Wi-Fi after multiple attempts.")
            raise RuntimeError("Wi-Fi connection failed.")
    else:
        print(f"Already connected to Wi-Fi: {wlan.ifconfig()}")

def disconnect_wifi():
    wlan = network.WLAN(network.STA_IF)
    if wlan.isconnected():
        print("Disconnecting from Wi-Fi...")
        wlan.disconnect()
        while wlan.isconnected():
            pass  # Wait until disconnected
        print("Disconnected from Wi-Fi.")
    else:
        print("No active Wi-Fi connection to disconnect.")
