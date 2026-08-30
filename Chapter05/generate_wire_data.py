import sys
from pathlib import Path

generated_dir = Path(__file__).parent / "python-generated"
sys.path.insert(0, str(generated_dir))

from calibration_data_pb2 import CalibrationData
from device_info_pb2 import DeviceInfo
from versions_pb2 import FirmwareVersion, HardwareVersion


device_info = DeviceInfo(
    firmware_version=FirmwareVersion(
        major=1,
        minor=4,
        patch=2,
    ),
    hardware_version=HardwareVersion(
        major=2,
        minor=1,
    ),
    calibration_data=CalibrationData(
        offset=10,
        gain=2.44,
    ),
)

wire_data = device_info.SerializeToString()

print(", ".join(f"0x{byte:02x}" for byte in wire_data))