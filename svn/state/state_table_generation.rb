
class BuildStateMachine
  
  def is_node_format?(node)
    return false if not node.class == Array
    node.each do |n|
      if not n.class == Symbol
        return false
      end
    end
    transition = node[STATE_TRANSITION].to_s
    return false if not transition[-1..-1] == '!'
    true  
  end
  
  def does_node_exist?
    
  end

  def state_table_generation(node)
    @node = node
    return false if not is_node_format?(@node)
    true
  end

  
end


