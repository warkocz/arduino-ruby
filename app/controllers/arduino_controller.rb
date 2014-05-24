class ArduinoController < ApplicationController

  def serial
  end

  def run_serial
    SerialService.move(params[:command])
    render json: {}
  end

  def firmata
  end

  def connect_firmata
    FirmataService.instance.connect
    redirect_to :back
  end

  def run_firmata
    FirmataService.instance.run(params[:command])
    redirect_to :back
  end

end

