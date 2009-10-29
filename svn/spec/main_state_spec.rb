
require File.
  expand_path(File.
              join(File.
                   dirname(__FILE__),'..','state','build_state_machine'))

describe 'generate state machine called main_state' do
  before(:each) do
    @bsm = BuildStateMachine.new('main_state_data')
    @s = @bsm.build_state_machine('main_state_data')
  end
  
  after(:each) do
    @bsm = nil
    @s = nil
  end
  
  it 'returns a state machine when passed a state machine data name' do
    @s.class.should == Statemachine::Statemachine
  end
  
  describe 'init_state' do
    
    it 'is the initial state' do
      @s.state.should == :init_state
    end
    
    it 'changes state to idle state once initialised' do
      @s.initialised!
      @s.state.should == :check_timers_state
    end
    
    it 'goes to system_failure_state on critical_initialisation_error!' do
      @s.critical_initialisation_error!
      @s.state.should == :system_failure_state
    end
    
    it 'goes to queue_init_warning_state on initialisation_warning!' do
      @s.initialisation_warning!
      @s.state.should == :queue_init_warning_state
    end
  end
  
  describe 'system_failure_state' do
    before do
      @bsm.climb_to :system_failure_state
    end

    it ' stays in system failure state while await_off!' do
      @s.await_off!
      @s.state.should == :system_failure_state
    end
  end
  
  describe 'queue_init_warning_state' do
    before do
      @bsm.climb_to :queue_init_warning_state
    end

    it 'changes to check_timers_state given init_warning_queued!' do
      @s.init_warning_queued!
      @s.state.should == :check_timers_state
    end
  end
  
  describe 'check_timers_state' do
    before do
      @bsm.climb_to :check_timers_state
      
    end

    it 'goes to check_comms_state given timers_processed!' do
      @s.timers_processed!
      @s.state.should == :check_comms_state
    end
    
    it 'goes to queue_timer_warning_state given timer_warning!' do
      @s.timer_warning!
      @s.state.should == :queue_timer_warning_state
    end
  end
  
  describe 'queue_comms_warning_state' do
    before do
      @bsm.climb_to :queue_comms_warning_state
    end

    it 'should change to process_warnings_state given comms_warning_queued!' do
      @s.comms_warning_queued!
      @s.state.should == :process_alarms_state
    end
  end
  
  describe 'check_comms_state' do
    before do
      @bsm.climb_to :check_comms_state
    end

    it 'goes to check_timers_state given comms_processed!' do
      @s.comms_processed!
      @s.state.should == :process_alarms_state
    end

    it 'goes to queue_comms_warning_state given comms_warning!' do
      @s.comms_warning!
      @s.state.should == :queue_comms_warning_state
    end
  end
  
  describe 'queue_comms_warning_state' do
    before do
      @bsm.climb_to :queue_comms_warning_state
    end
    
    it 'goes to process_alarms_state after comms_warning_queued!' do
      @s.comms_warning_queued!
      @s.state.should == :process_alarms_state
    end
  end
  
  describe 'process_alarms_state' do
    before do
      @bsm.climb_to :process_alarms_state
    end
    
    it 'goes to process_warnings_state after alarms_processed!' do
      @s.alarms_processed!
      @s.state.should == :process_warnings_state
    end
  end
  
  describe 'process_warnings_state' do
    before do
      @bsm.climb_to :process_warnings_state
    end
    
    it 'goes to check_timers_state after warnings_processed!' do
      @s.warnings_processed!
      @s.state.should == :check_timers_state
    end
  end
end






