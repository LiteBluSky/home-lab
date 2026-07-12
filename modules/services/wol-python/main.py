import os
import socket
import re
from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel, field_validator, Field

app = FastAPI(title="Tailscale WoL API", version="1.0")

# Fetch the MAC address from the environment, defaulting to an empty string if not found
DEFAULT_MAC = os.getenv("TARGET_MAC_ADDRESS", "")

class WakeRequest(BaseModel):
    # Field(default=...) tells FastAPI Swagger UI what to auto-fill in the box
    mac_address: str = Field(
        default=DEFAULT_MAC, 
        description="The MAC address of the target PC to wake up.",
        examples=["AA:BB:CC:DD:EE:FF"]
    )

    @field_validator('mac_address')
    @classmethod
    def validate_mac(cls, v: str) -> str:
        mac_regex = re.compile(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$')
        if not mac_regex.match(v):
            raise ValueError('Invalid MAC address format. Use AA:BB:CC:DD:EE:FF')
        return v

def send_magic_packet(mac_address: str):
    clean_mac = mac_address.replace(':', '').replace('-', '')
    mac_bytes = bytes.fromhex(clean_mac)
    magic_packet = b'\xff' * 6 + mac_bytes * 16
    
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
        sock.sendto(magic_packet, ('255.255.255.255', 9))

@app.post("/wake", status_code=status.HTTP_200_OK)
async def wake_pc(payload: WakeRequest):
    try:
        send_magic_packet(payload.mac_address)
        return {"status": "success", "message": f"Magic packet sent to {payload.mac_address}"}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to send magic packet: {str(e)}"
        )
