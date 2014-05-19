module SerialService

  PORT = '/dev/tty.usbmodem1421'
  BAUD_RATE = 9600
  DATA_BITS = 8
  STOP_BITS = 1
  PARITY = SerialPort::NONE

  def self.move(command)

    SerialPort.open(PORT, BAUD_RATE, DATA_BITS, STOP_BITS, PARITY) do |serial_port|
      serial_port.write(command.first)
    end

  end

end
