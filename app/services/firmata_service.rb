class FirmataService

  PORT = '/dev/tty.usbmodem1421'
  VERTICAL_SERVO_PIN = 2
  HORIZONTAL_SERVO_PIN = 3
  LASER_PIN = 4

  attr_accessor :arduino

  def initialize
    @arduino = FirmataService.connect
  end

  def self.connect
    Rails.configuration.arduino ||= Firmata::Board.new(FirmataService::PORT)
    arduino = Rails.configuration.arduino
    arduino.connect unless arduino.connected?
    arduino.set_pin_mode(VERTICAL_SERVO_PIN, Firmata::Board::SERVO)
    arduino.set_pin_mode(HORIZONTAL_SERVO_PIN, Firmata::Board::SERVO)
    arduino.set_pin_mode(LASER_PIN, Firmata::Board::OUTPUT)
    arduino
  end

  def self.connected?
    Rails.configuration.arduino.connected? if Rails.configuration.arduino
  end

  def stop
    arduino.digital_write LASER_PIN, Firmata::Board::LOW
    Thread.kill(Rails.configuration.arduino_thread) if Rails.configuration.arduino_thread.present?
  end

  def run(command)
    stop
    arduino.digital_write LASER_PIN, Firmata::Board::HIGH
    Rails.configuration.arduino_thread = Thread.new { send(command) }
  end

  def circle
    r = 30
    set_servos_position(x: 90 + r, y: 90)
    loop do
      360.times do |degrees|
        gamma = radians(degrees)
        set_servos_position(x: calculate_x(gamma, r), y: calculate_y(gamma, r))
        arduino.delay 0.01
      end
    end
  end

  def rose
    k = 6
    loop do
      360.times do |degrees|
        gamma = radians(degrees)
        r = 45 * Math.cos(k * gamma)
        set_servos_position(x: calculate_x(gamma, r), y: calculate_y(gamma, r))
        arduino.delay 0.01
      end
    end
  end

  def spiral
    set_servos_position(x: 90, y: 90)
    loop do
      (3 * 360).times do |degrees|
        gamma = radians(degrees)
        r = gamma
        set_servos_position(x: calculate_x(gamma, r), y: calculate_y(gamma, r))
        arduino.delay 0.01
      end
      (3 * 360).downto(0) do |degrees|
        gamma = radians(degrees)
        r = gamma
        set_servos_position(x: calculate_x(gamma, r), y: calculate_y(gamma, r))
        arduino.delay 0.01
      end
    end
  end

  private

  def calculate_x(gamma, r)
    90 + (r * Math.cos(gamma).to_f).to_i
  end

  def calculate_y(gamma, r)
    90 + (r * Math.sin(gamma).to_f).to_i
  end

  def radians(degrees)
    (degrees * Math::PI) / 180
  end

  def set_servos_position(params)
    arduino.servo_write HORIZONTAL_SERVO_PIN, params.fetch(:x)
    arduino.servo_write VERTICAL_SERVO_PIN, params.fetch(:y)
  end

end