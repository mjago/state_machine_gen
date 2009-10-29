
require 'statemachine'
 require File.expand_path(File.join(File.dirname(__FILE__),'climb_to'))

class StateMachine
  @sm = nil
  attr_accessor :state_machine
  
  def initialize(state_machine)
    @state_machine = state_machine
  end
  
  def state
    @state_machine.state 
  end
  
  def is_transition?(transition)
    transition.to_s[-1..-1] == '!'
  end
    
  def does_node_exist?(node)
    state_found = false
    $data.size.times do |e|
      if $data[e] == node
        return true
      end
    end
    false
  end
  
  def check_node_format node
    if not node.to_s[-6..-1] == '_state'
      raise "the #{m} state  is required to end in _state!"
    end
  end
 
  def is_node_format?(node)
    return false if not node.class == Array
    node.each do |n|
      return false if not n.class == Symbol
    end
    return false if not is_transition? node[STATE_TRANSITION].to_s
    check_node_format node[FROM_STATE]
    check_node_format node[TO_STATE]
  end
  
  def add_node(from_state,transition,to_state)
    node = [from_state, transition, to_state]
    if is_node_format? node
      if not does_node_exist?(node)
        $data.push node
        self.save
      end
    end
  end
  
  def delete_node(from_state, transition, to_state)
    node = [from_state, transition, to_state]
    if is_node_format? node
      if does_node_exist? node
        $data.delete node 
        self.save
      end
    end
  end
  
  def save
    File.open(File.
              expand_path(File.
                          join(File.
                               dirname(__FILE__),'stateData',"#{$working_table}.yml")),'w') do |out|
      YAML.dump($data, out)
  #    puts $data
    end
  end
  
  def method_missing(m, *args, &block)
    if is_transition?(m)
      @state_machine.send("#{m}")
    else
      raise "the transition #{m} is required to end in an exclamation mark!"
    end
  end
end

class BuildStateMachine
  attr_accessor :state_machine
  attr_accessor :data
  
  def initialize(state_machine_name)
    $working_table = "#{state_machine_name}_data"
    BuildStateMachine.class.send(:define_method,
                                 "#{state_machine_name.gsub('state_data','states')}",
                                 proc { build_state_machine(state_machine_name) } )
    @state_machine = self.
      build_state_machine("#{state_machine_name.gsub('state_data','states')}")
    @state_machine = StateMachine.new(@state_machine)
  end
  
  def build_state_machine(statemachine_to_build)
    begin
#      puts "loading #{File.expand_path(File.join(File.dirname(__FILE__),'stateData',"#{$working_table}.yml"))}"
      $data = YAML::load(File.
                        read(File.
                             expand_path(File.
                                       join(File.
                                            dirname(__FILE__),'stateData',"#{$working_table}.yml"))))
    sm = Statemachine.build do
      $data.each do |st|
        trans st[0].to_s.to_sym, st[1].to_s.to_sym, st[2].to_s.to_sym
      end
    end
      sm
    rescue
      puts "ERROR! non-existant table #{$working_table}.yml"
      nil
    end
  end
  
end
  
