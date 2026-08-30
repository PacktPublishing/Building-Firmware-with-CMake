#include <stdio.h>
#include <pb_decode.h>

#include "wire_data.h"
#include "device_info.pb.h"

int main()
{
    DeviceInfo device_info = DeviceInfo_init_zero;

    pb_istream_t stream = pb_istream_from_buffer(wire_data, sizeof(wire_data));

    bool status = pb_decode(
        &stream,
        DeviceInfo_fields,
        &device_info
    );

    if (!status)
    {
        printf("Decoding failed: %s\n", PB_GET_ERROR(&stream));
        return 1;
    }

    printf(
        "Firmware version: %u.%u.%u\n",
        (unsigned int)device_info.firmware_version.major,
        (unsigned int)device_info.firmware_version.minor,
        (unsigned int)device_info.firmware_version.patch
    );

    printf(
        "Hardware version: %u.%u\n",
        (unsigned int)device_info.hardware_version.major,
        (unsigned int)device_info.hardware_version.minor
    );

    int gain_x100 = (int)(device_info.calibration_data.gain * 100.0f);

    printf(
        "Calibration data: offset %d, gain %d.%02d\n",
        (int)device_info.calibration_data.offset,
        gain_x100 / 100,
        gain_x100 % 100
    );

    return 0;
}