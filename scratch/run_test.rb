File.open('D:/PHOTO DESIGNING/scratch/skp_startup_log.txt', 'w') do |f|
  f.puts 'Hello from SketchUp RubyStartup!'
  f.puts 'Sketchup version: ' + Sketchup.version
  f.puts 'Active model: ' + Sketchup.active_model.to_s
end
Sketchup.quit
