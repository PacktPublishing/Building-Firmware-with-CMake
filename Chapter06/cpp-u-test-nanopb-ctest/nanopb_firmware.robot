*** Settings ***
Resource          ${RENODEKEYWORDS}

*** Test Cases ***
Nanopb Firmware Test Should Pass
    Execute Command    mach create
    Execute Command    machine LoadPlatformDescription @platforms/boards/stm32f072b_discovery.repl
    Execute Command    machine LoadPlatformDescriptionFromString "semihosting: CPU.SemihostingHandler @ cpu\nsemihostingUart: UART.SemihostingUart @ semihosting"

    Execute Command    sysbus LoadELF @${ELF}

    Create Terminal Tester    sysbus.usart2
    Create Log Tester    5

    Start Emulation

    Wait For Log Entry    Program exited with reason ADP_Stopped_ApplicationExit

    ${summary}=    Wait For Line On Uart    .*(OK|Errors).*    treatAsRegex=true
    Log To Console    ${summary.Line}

    ${exit_code}=    Execute Command    sysbus.cpu.semihosting ExitCode
    Should Be Equal As Integers    ${exit_code}    0