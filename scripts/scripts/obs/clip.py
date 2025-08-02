#!/usr/bin/env python3
from obswebsocket import obsws, requests
import sys

def save_replay_buffer():
    try:
        # Connect to OBS WebSocket
        client = obsws('localhost', 4455, 'VkX1loL3d3wgbxxd')
        client.connect()

        # Save the replay buffer
        client.call(requests.SaveReplayBuffer())
        print("Replay buffer saved!")
        
        client.disconnect()
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    save_replay_buffer()
