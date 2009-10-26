
require File.
  expand_path(File.
              join(File.
                   dirname(__FILE__),'..','state','build_state_machine'))

require File.
  expand_path(File.
              join(File.
                   dirname(__FILE__),'..','state','climb_to'))

describe 'FROM_STATE' do it do
  FROM_STATE.should == 0
end end

describe 'TO_STATE' do it do
    TO_STATE.should == 2
end end

describe 'STATE_TRANSITION' do it do
  STATE_TRANSITION.should == 1
end end

describe StateData do
  before do
    @state_data = StateData.new
  end
  
  it 'exists as a class' do
    @state_data.class.should == StateData
  end
  
  it 'has a method called test_state_data' do
    @state_data.methods.include?('test_state_data').should == true
  end
  
  it 'has a method called connection_state_data' do
    @state_data.methods.include?('connection_state_data').should == true
  end
  
  it 'has a method called tx_messaging_states_data' do
    @state_data.methods.include?('dev_tx_messaging_state_data').should == true
  end
  
  it 'has a method called main_state_data' do
    @state_data.methods.include?('main_state_data').should == true
  end
end

describe BuildStateMachine do 
    
  it 'should be a public method of BuildStateMachine class' do
    @bs = BuildStateMachine.new
    @bs.public_methods.include?('climb_to').should == true
  end
end

describe 'State data access' do
  
  before do
    @d = StateData.main_state_data
  end

  after do
    @d = nil
  end
    
  it 'StateData.main_state_data should be an Array' do
    @d.class.should == Array
  end

  it'main_state_data includes :init_state as a FROM_STATE' do
    state_found = false
    @d.size.times do |e|
      state_found = true if @d[e][FROM_STATE] == :init_state
      state_found.should == true
    end
  end
  
  it'main_state_data doesnt include :init_state as a TO_STATE' do
    state_found = false
    @d.size.times do |e|
      state_found = true if @d[e][TO_STATE] == :init_state
    end
    state_found.should == false
  end
  
  it'main_state_data includes :system_failure_state as a TO_STATE' do
    state_found = false
    @d.size.times do |e|
      state_found = true if @d[e][TO_STATE] == :system_failure_state
    end
    state_found.should == true
  end

  it'main_state_data includes :warnings_processed! as a STATE_TRANSITION' do
    state_found = false
    @d.size.times do |e|
      state_found = true if @d[e][STATE_TRANSITION] == :warnings_processed!
    end
    state_found.should == true
  end
  
end
  
#     StateData.main_state_data.include?(:init_state).should == true


describe 'BuildStateMachine' do
  
 before do
    @bsm = BuildStateMachine.new
    @d = StateData.new
    end
  
  after do
    @bsm = nil
    @d = nil
  end
  
  it 'has a public method called data' do
    @bsm.public_methods.include?('data').should == true
  end

  it 'data returns an Array' do
    @bsm.data('main_state_data').class.should == Array
  end
  
  it 'returns init_state as the initial state' do
    @bsm.data('main_state_data')[0][0].should == :init_state
  end
  
  it 'initial_state is init_state' do
    @bsm.initial_state.should == :init_state
  end
  
  it 'returns false if passed a state that is not a TO_STATE' do
    @bsm.climb_to(:not_a_to_state).should == false
  end
    
  it 'returns critical_initialisation_error! if passed :system_failure_state' do
    @bsm.climb_to(:system_failure_state).should == [:critical_initialisation_error!]
  end

  it 'returns initialisation_warning! if passed :queue_init_warning_state' do
    @bsm.climb_to(:queue_init_warning_state).should == [:initialisation_warning!]
  end
  
  it 'returns initialised! if passed :check_timers_state' do
    @bsm.climb_to(:check_timers_state).should == [:initialised!]
  end

  it 'returns initialised! if passed :check_timers_state' do
    @bsm.climb_to(:check_timers_state).should == [:initialised!]
  end
  
  describe 'check_TO_STATE?' do
    it 'should return false if state passed in is not a TO_STATE' do
      @bsm.check_TO_STATE?(:init_state).should == false
    end
    
    it 'should return true if state passed in is a TO_STATE' do
      @bsm.check_TO_STATE?(:system_failure_state).should == true
    end
  end
  
  describe 'fetch_node_leading_to' do
    it 'returns false if passed a state that isnt a TO_STATE' do
      @bsm.fetch_node_leading_to(:doesnt_exist).should == false
    end
  
    it 'passing :queue_init_warning_state should return [:init_state,:initialisation_warning!,:queue_init_warning_state]' do
      @bsm.fetch_node_leading_to(:queue_init_warning_state).should == [:init_state,:initialisation_warning!,:queue_init_warning_state]      
    end
    
    it 'passing :system_failure_state should return [:init_state,:critical_initialisation_error!,:system_failure_state]' do
      @bsm.fetch_node_leading_to(:queue_init_warning_state).should == [:init_state,:initialisation_warning!,:queue_init_warning_state]      
    end
    
    it 'passing :check_timers_state should return [:init_state,:initialised!,:check_timers_state]' do
      @bsm.fetch_node_leading_to(:queue_init_warning_state).should == [:init_state,:initialisation_warning!,:queue_init_warning_state]      
    end
    
    it 'queue_timer_warning_state should return [:check_timers_state, :timer_warning!, :queue_timer_warning_state]' do
      @bsm.fetch_node_leading_to(:queue_init_warning_state).should == [:init_state,:initialisation_warning!,:queue_init_warning_state]      
    end
  end
  
  describe 'climb_to' do
    it 'returns false if not passed a symbol' do
      @bsm.climb_to('string').should == false
    end
    
    it 'returns an array if passed a symbol exists as a STATE_TO element' do
      @bsm.climb_to(:system_failure_state).class.should == Array
    end
    
    it 'returns [:critical_initialisation_error!] if passed :system_failure_state' do
      @bsm.climb_to(:system_failure_state).should ==  [:critical_initialisation_error!]
    end
    
    it 'returns [:initialised!] if passed :check_timers_state' do
      @bsm.climb_to(:check_timers_state).should ==  [:initialised!]
    end
    
    it 'returns  [:initialised!,:timers_processed!] if passed :check_comms_state' do
      @bsm.climb_to(:check_comms_state).should ==  [:initialised!,:timers_processed!]
    end
    
    it 'returns  [:initialised!,:timers_processed!,:comms_processed!] if passed :process_alarms_state' do
      @bsm.climb_to(:process_alarms_state).should ==  [:initialised!,:timers_processed!,:comms_processed!]
    end
    
    it 'returns false if passed state that isnt a child of initial state ' do
      @bsm.climb_to(:unconnected_state).should == false
    end
    
    it 'progresses state to system_failure_state when passed system_failure_state' do
      @sm = @bsm.build_state_machine('main_state_data')
      transitions = @bsm.climb_to(:queue_comms_warning_state)
#      transitions.each do |t|
#        @sm.send(t)
#      end
      @sm.state.should == :queue_comms_warning_state
    end
  end

  
  
end






