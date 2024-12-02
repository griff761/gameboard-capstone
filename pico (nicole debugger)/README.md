Pico files from jack.....Get and Pull requests, example 2-d array, 
handles such things as youll see running it... m
ake sure to move files over to Pico when running...

Runs off my hotspot, feel free to change ip (in android studio) and thonny to yours. thats SSID as the name, password as password, 
and any ip you see to your hotspot's ip


places to change network stuff:

ssid (name of hotspot) and password (of hotspot): in jacks_folder-->wifi_connect.py
ip (of android device, located under wifi/hotspot when selected on android device)
ip: change it to this in send_get_request.py and send_post_request.py 
            (make sure it has its tails it already had, like /config, etc).
            
ip (android studio code): change ip in server.dart


For running this config, you need to enter all 80 indices (separated by a space) for the 8x10 array manually.
Below, i've included two demo ones to enter:

Example 1 (beginning of game):
How the array will look:
[1, 1, 1, 1, 1, 1, 1, 1, 0, 0]
[1, 1, 1, 1, 1, 1, 1, 1, 0, 0]
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
[1, 1, 1, 1, 1, 1, 1, 1, 0, 0]
[1, 1, 1, 1, 1, 1, 1, 1, 0, 0]

What to enter into user input (copy/paste whole line below, then press enter):
1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 0 0



Example (all chess tiles occupied):
How the array will look:
[1, 1, 1, 1, 1, 1, 1, 1, 0, 0]
[1, 1, 1, 1, 1, 1, 1, 1, 0, 0]
[1, 1, 1, 1, 1, 1, 1, 1, 0, 0]
[1, 1, 1, 1, 1, 1, 1, 1, 0, 0]
[1, 1, 1, 1, 1, 1, 1, 1, 0, 0]
[1, 1, 1, 1, 1, 1, 1, 1, 0, 0]
[1, 1, 1, 1, 1, 1, 1, 1, 0, 0]
[1, 1, 1, 1, 1, 1, 1, 1, 0, 0]

What to enter into user input (copy/paste whole line below, then press enter):
1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 0 0




