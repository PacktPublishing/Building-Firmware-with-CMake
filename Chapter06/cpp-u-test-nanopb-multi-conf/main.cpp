#include "CppUTest/TestHarness.h"
#include "CppUTest/CommandLineTestRunner.h"

#include <pb_decode.h>

#include "wire_data.h"
#include "device_info.pb.h"

TEST_GROUP(WireDataDecode)
{
};

TEST(WireDataDecode, DecodesHostGeneratedDeviceInfo)
{
    DeviceInfo device_info = DeviceInfo_init_zero;

    pb_istream_t stream =
        pb_istream_from_buffer(wire_data, sizeof(wire_data));

    bool status = pb_decode(
        &stream,
        DeviceInfo_fields,
        &device_info
    );

    CHECK_TRUE_TEXT(status, PB_GET_ERROR(&stream));

    LONGS_EQUAL(1, device_info.firmware_version.major);
    LONGS_EQUAL(4, device_info.firmware_version.minor);
    LONGS_EQUAL(2, device_info.firmware_version.patch);

    LONGS_EQUAL(2, device_info.hardware_version.major);
    LONGS_EQUAL(1, device_info.hardware_version.minor);

    LONGS_EQUAL(10, device_info.calibration_data.offset);
    DOUBLES_EQUAL(2.44, device_info.calibration_data.gain, 0.001);
}

int main()
{
    const char* argv[] = {"cpp_u_test_nanopb"};

    CommandLineTestRunner::RunAllTests(1, argv);

    return 0;
}