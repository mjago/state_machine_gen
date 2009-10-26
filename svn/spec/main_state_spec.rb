require File.
  expand_path(File.
              join(File.
                   dirname(__FILE__),'..','state','build_state_machine'))


describe 'generate state machine called main_state' do
  before do
    @main_state = nil
    @main_state = BuildStateMachine.new.build_state_machine('main_state_data')
  end
  
  it 'returns a state machine when passed a state machine data name' do
    @main_state = BuildStateMachine.new.build_state_machine('main_state_data')
    @main_state.class.should == Statemachine::Statemachine
  end
  
  describe 'init_state' do
    
    it 'is the initial state' do
      @main_state.state.should == :init_state
    end
    
    it 'changes state to idle state once initialised' do
      @main_state.initialised!
      @main_state.state.should == :check_timers_state
    end
    
    it 'goes to system_failure_state on critical_initialisation_error!' do
      @main_state.critical_initialisation_error!
      @main_state.state.should == :system_failure_state
    end
    
    it 'goes to queue_init_warning_state on initialisation_warning!' do
      @main_state.initialisation_warning!
      @main_state.state.should == :queue_init_warning_state
    end
  end
  
  describe 'system_failure_state' do
    before do
      @main_state.critical_initialisation_error!
    end

    it ' stays in system failure state while await_off!' do
      @main_state.await_off!
      @main_state.state.should == :system_failure_state
    end
  end
  
  describe 'queue_init_warning_state' do
    before do
      @main_state.initialisation_warning!
    end

    it 'changes to check_timers_state given init_warning_queued!' do
      @main_state.init_warning_queued!
      @main_state.state.should == :check_timers_state
    end
  end
  
  describe 'check_timers_state' do
    before do
      @main_state.initialised!
    end

    it 'goes to check_comms_state given timers_processed!' do
      @main_state.timers_processed!
      @main_state.state.should == :check_comms_state
    end
    
    it 'goes to queue_timer_warning_state given timer_warning!' do
      @main_state.timer_warning!
      @main_state.state.should == :queue_timer_warning_state
    end
  end
  
  describe 'queue_comms_warning_state' do
    before do
      @main_state.initialised!
      @main_state.timers_processed!
      @main_state.comms_warning!
    end

    it 'should change to process_warnings_state given comms_warning_queued!' do
      @main_state.comms_warning_queued!
      @main_state.state.should == :process_alarms_state
    end
  end
  
  describe 'check_comms_state' do
    before do
      @main_state.initialised!
      @main_state.timers_processed!
    end

    it 'goes to check_timers_state given comms_processed!' do
      @main_state.comms_processed!
      @main_state.state.should == :process_alarms_state
    end

    it 'goes to queue_comms_warning_state given comms_warning!' do
      @main_state.comms_warning!
      @main_state.state.should == :queue_comms_warning_state
    end
  end
  
  describe 'queue_comms_warning_state' do
    before do
      @main_state.initialised!
      @main_state.timers_processed!
      @main_state.comms_warning!
    end
    
    it 'goes to process_alarms_state after comms_warning_queued!' do
      @main_state.comms_warning_queued!
      @main_state.state.should == :process_alarms_state
    end
  end
  
  describe 'process_alarms_state' do
    before do
      @main_state.initialised!
      @main_state.timers_processed!
      @main_state.comms_processed!
    end
    
    it 'goes to process_warnings_state after alarms_processed!' do
      @main_state.alarms_processed!
      @main_state.state.should == :process_warnings_state
    end
  end
  
  describe 'process_warnings_state' do
    before do
      @main_state.initialised!
      @main_state.timers_processed!
      @main_state.comms_processed!
      @main_state.alarms_processed!
    end
    
    it 'goes to check_timers_state after warnings_processed!' do
      @main_state.warnings_processed!
      @main_state.state.should == :check_timers_state
    end
  end
  
end






