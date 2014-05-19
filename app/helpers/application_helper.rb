module ApplicationHelper

  def arrow(direction)
    button_to(run_serial_path(command: direction), remote: true, class: 'btn btn-success btn-lg') do
      tag(:span, class: "glyphicon glyphicon-arrow-#{direction}")
    end
  end

  def laser_toggle
    button_to(run_serial_path(command: 'x'), remote: true, class: 'btn btn-success btn-lg') do
      tag(:span, class: "glyphicon glyphicon-certificate")
    end
  end

end
