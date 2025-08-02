#!/usr/bin/env python3
from obswebsocket import obsws, requests
import time
import sys
import subprocess
import socket

def is_obs_running():
    """Check if OBS is running by looking for the process"""
    try:
        result = subprocess.run(['pgrep', '-f', 'obs'], capture_output=True, text=True)
        return len(result.stdout.strip()) > 0
    except:
        return False

def is_websocket_available():
    """Check if OBS WebSocket server is responding"""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(1)
        result = sock.connect_ex(('localhost', 4455))
        sock.close()
        return result == 0
    except:
        return False

def restart_replay_buffer():
    if not is_obs_running():
        print(f"{time.strftime('%H:%M:%S')} - OBS not running, skipping restart")
        return
    
    if not is_websocket_available():
        print(f"{time.strftime('%H:%M:%S')} - OBS WebSocket not available, skipping restart")
        return
    
    try:
        # Connect to OBS WebSocket
        client = obsws('localhost', 4455, 'VkX1loL3d3wgbxxd')
        client.connect()
        
        # Restart the replay buffer
        client.call(requests.StopReplayBuffer())
        time.sleep(2)
        client.call(requests.StartReplayBuffer())
        
        client.disconnect()
        print(f"Replay buffer restarted at {time.strftime('%H:%M:%S')}")
        
    except Exception as e:
        print(f"Error restarting buffer: {e}")

def main():
    print("OBS Replay Buffer Auto-Restart started")
    
    while True:
        try:
            time.sleep(1200)  # Wait 20 minutes (1200 seconds)
            restart_replay_buffer()
        except KeyboardInterrupt:
            print("\nStopping auto-restart service")
            break
        except Exception as e:
            print(f"Unexpected error: {e}")
            time.sleep(60)  # Wait 1 minute before retrying

if __name__ == "__main__":
    main()
