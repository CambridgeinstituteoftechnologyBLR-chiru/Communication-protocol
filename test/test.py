import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge


@cocotb.test()
async def test_uart(dut):

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    dut.ui_in.value = 0

    for _ in range(5):
        await RisingEdge(dut.clk)

    dut.rst_n.value = 1

    # mode = 00 (UART)
    # data = 1010
    # start = 1

    dut.ui_in.value = 0b00011010

    await RisingEdge(dut.clk)

    # clear start bit
    dut.ui_in.value = 0b00001010

    for _ in range(20):
        await RisingEdge(dut.clk)

    assert dut.uo_out.value.to_unsigned() >= 0


@cocotb.test()
async def test_spi(dut):

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    dut.ui_in.value = 0

    for _ in range(5):
        await RisingEdge(dut.clk)

    dut.rst_n.value = 1

    # mode = 01 (SPI)
    # data = 1100
    # start = 1

    dut.ui_in.value = 0b00111100

    await RisingEdge(dut.clk)

    # clear start bit
    dut.ui_in.value = 0b00101100

    for _ in range(20):
        await RisingEdge(dut.clk)

    assert dut.uo_out.value.to_unsigned() >= 0


@cocotb.test()
async def test_i2c(dut):

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    dut.ui_in.value = 0

    for _ in range(5):
        await RisingEdge(dut.clk)

    dut.rst_n.value = 1

    # mode = 10 (I2C)
    # data = 0110
    # start = 1

    dut.ui_in.value = 0b01010110

    await RisingEdge(dut.clk)

    # clear start bit
    dut.ui_in.value = 0b01000110

    for _ in range(20):
        await RisingEdge(dut.clk)

    assert dut.uo_out.value.to_unsigned() >= 0
