function frk --wraps='hyprctl dispatch -- exec' --description 'alias frk=hyprctl dispatch -- exec'
  hyprctl dispatch -- exec $argv
        
end
