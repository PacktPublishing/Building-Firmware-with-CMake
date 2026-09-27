import argparse
import sys
from pathlib import Path


parser = argparse.ArgumentParser()
parser.add_argument("--python-bindings", required=True)
parser.add_argument("--output-header", required=True)
args = parser.parse_args()

python_bindings = Path(args.python_bindings)
output_header = Path(args.output_header)

sys.path.insert(0, str(python_bindings))

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

bytes_per_line = 8
lines = []

for i in range(0, len(wire_data), bytes_per_line):
    chunk = wire_data[i:i + bytes_per_line]
    lines.append(
        "    " + ", ".join(f"0x{byte:02x}" for byte in chunk)
    )

header = """#pragma once

#include <stdint.h>

static const uint8_t wire_data[] = {
%s
};
""" % ",\n".join(lines)

output_header.parent.mkdir(parents=True, exist_ok=True)
output_header.write_text(header)