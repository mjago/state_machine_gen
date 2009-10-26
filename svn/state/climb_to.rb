# require File.
#   expand_path(File.
#               join(File.
#                    dirname(__FILE__),'..','state','build_state_machine'))
FROM_STATE = 0
STATE_TRANSITION = 1
TO_STATE = 2

class BuildStateMachine

  CURRENT_DATA = 'main_state_data'
  
  def initial_state
    StateData.send(CURRENT_DATA)[0][0]
  end
  
  def data(data_name)
    d = StateData.send(data_name.to_s)
    return d
  end
  
  def check_TO_STATE?(state)
    d = data(CURRENT_DATA)
    state_found = false
    d.size.times do |e|
      if d[e][TO_STATE] == state
        return true
      end
    end
    false
  end
  
  def fetch_node_leading_to(to_state)
    d = data(CURRENT_DATA)
    d.size.times do |x|
      if(d[x][TO_STATE]== to_state)
        return d[x]
      end
    end
    false
  end
    
  def climb_to state_to_climb_to
    puts "state_to_climb_to"
    @state_to_climb_to = state_to_climb_to
    return false if @state_to_climb_to.class != Symbol
    return false if not check_TO_STATE?(@state_to_climb_to)
    ary = []
    false
    loop do
      node = fetch_node_leading_to(@state_to_climb_to)
      if not node == false
        puts node.inspect
        ary << node[STATE_TRANSITION]
        puts "ary = #{ary}"
        if node[FROM_STATE] == self.initial_state
          ary.reverse.each do |t|
            @current_states.send(t)
          end
          
            
          return ary.reverse
          
          
        end
        @state_to_climb_to = node[FROM_STATE]
      else
        return false
      end
    end
  end
  
#   def climb_to state_to_climb_to
#     puts "state_to_climb_to"
#     @state_to_climb_to = state_to_climb_to
#     return false if @state_to_climb_to.class != Symbol
#     return false if not check_TO_STATE?(@state_to_climb_to)
#     ary = []
#     false
#     loop do
#       node = fetch_node_leading_to(@state_to_climb_to)
#       if not node == false
#         puts node.inspect
#         ary << node[STATE_TRANSITION]
#         puts "ary = #{ary}"
#         if node[FROM_STATE] == self.initial_state
#           return ary.reverse
#         end
#         @state_to_climb_to = node[FROM_STATE]
#       else
#         return false
#       end
#     end
#   end


  
end



