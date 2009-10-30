
FROM_STATE = 0
STATE_TRANSITION = 1
TO_STATE = 2

class StateMachine
  
  def initial_state
    $data[0][0]
  end
  
  def check_TO_STATE?(state)
    state_found = false
    $data.size.times do |e|
      if $data[e][TO_STATE] == state
        return true
      end
    end
    false
  end
  
  def fetch_node_leading_to(to_state)
    $data.size.times do |x|
      if not $data[x][FROM_STATE] == to_state
        if($data[x][TO_STATE]== to_state)
          return $data[x]
        end
      end
    end
    false
  end
    
  def climb_to state_to_climb_to
    @state_to_climb_to = state_to_climb_to
    return false if @state_to_climb_to.class != Symbol
    return false if not check_TO_STATE?(@state_to_climb_to)
    ary = []
    loop do
      node = fetch_node_leading_to(@state_to_climb_to)
      if not node == false
        ary << node[STATE_TRANSITION]
        if node[FROM_STATE] == self.initial_state
          ary.reverse.each do |t|
            @state_machine.send(t)
          end
          return ary.reverse
        end
        @state_to_climb_to = node[FROM_STATE]
      else
        return false
      end
    end
  end
  
end
