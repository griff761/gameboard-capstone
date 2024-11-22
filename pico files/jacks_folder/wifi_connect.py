import network
import time

def connect_wifi():
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)

    # Replace with your Wi-Fi credentials
    ssid = "ShamWoW"
    password = "Magnolia1302"

    if not wlan.isconnected():
        print(f"Connecting to Wi-Fi network {ssid}...")
        wlan.connect(ssid, password)
        while not wlan.isconnected():
            time.sleep(1)
        print(f"Connected to Wi-Fi network {ssid}. IP address: {wlan.ifconfig()[0]}")
    else:
        print("Already connected to Wi-Fi.")

def disconnect_wifi():
    wlan = network.WLAN(network.STA_IF)
    if wlan.isconnected():
        print("Disconnecting from previous Wi-Fi connection...")
        wlan.disconnect()
        while wlan.isconnected():
            pass  # Wait until disconnected
        print("Disconnected from previous Wi-Fi.")
    else:
        print("No active Wi-Fi connection to disconnect.")
