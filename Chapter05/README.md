# Generate wire_data

## Generated Python bindings

```shell
ubuntu@86604219f507:/workspace/Chapter05$ mkdir python-generated
ubuntu@86604219f507:/workspace/Chapter05$ protoc --proto_path=proto --python_out python-generated device_info.proto versions.proto calibration_data.proto
ubuntu@86604219f507:/workspace/Chapter05$ ls -l python-generated/
total 12
-rw-r--r-- 1 ubuntu ubuntu 1030 Aug 30 12:30 calibration_data_pb2.py
-rw-r--r-- 1 ubuntu ubuntu 1288 Aug 30 12:30 device_info_pb2.py
-rw-r--r-- 1 ubuntu ubuntu 1188 Aug 30 12:30 versions_pb2.py
```

## Use Python to generate wire_data
```shell
ubuntu@86604219f507:/workspace/Chapter05$ python3 generate_wire_data.py 
0x0a, 0x06, 0x08, 0x01, 0x10, 0x04, 0x18, 0x02, 0x12, 0x04, 0x08, 0x02, 0x10, 0x01, 0x1a, 0x07, 0x08, 0x0a, 0x15, 0xf6, 0x28, 0x1c, 0x40
```