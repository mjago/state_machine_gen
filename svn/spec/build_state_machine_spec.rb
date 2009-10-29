
require File.
  expand_path(File.
              join(File.
                   dirname(__FILE__),'..','state','build_state_machine'))

describe 'StateMachine' do
  before(:each) do
    @s = BuildStateMachine.new('test_state').state_machine
  end
  
  it "exists as a class" do
    BuildStateMachine.new('test_state').class.should == BuildStateMachine
  end
  
  it 'returns a instance variable state_machine' do
    BuildStateMachine.new('test_state').state_machine.class.should == StateMachine
  end
  
  it 'state data is available via the instance variable data' do
    @data = BuildStateMachine.new('test_state').data
  end

  # test StateMachine#climb_to method

  describe 'StateMachine.climb_to :init_state' do
    it 'climb_to exists as a public_method of StateMachine' do
      @s.public_methods.include?('climb_to').should == true
    end

    describe 'climb_to :init_state' do
      it 'climbs to init_state when passed init_state' do
        @s.climb_to :init_state
        @s.state.should == :init_state
      end

      it 'climbs to idle_state when passed idle_state' do
        @s.climb_to :idle_state
        @s.state.should == :idle_state
      end
      
      it 'climbs to check_comms_state when passed check_comms_state' do
        @s.climb_to :check_comms_state
        @s.state.should == :check_comms_state
      end
    end
  end
  
  # do some states with test_state_machine...
  
  describe 'init_state' do
    before do
      @s.climb_to :init_state
    end
    
    it 'is the initial state' do
      @s.add_node :init_state, :initialised!, :idle_state
      @s.state.should == :init_state
    end
    
    it 'changes state to :idle_state given initialised!' do
      @s.initialised!
      @s.state.should == :idle_state
    end
  end
  
  describe 'idle_state' do
    before do
      @s.climb_to :idle_state
    end

    it ' remove test_timed_event' do
      @s.delete_node :idle_state, :test_timed_event!, :test_state
    end
    
    it 'is reentrant given no_data!' do
      @s.no_data!
      @s.state.should == :idle_state
    end
    
    it 'changes state to :process_state given data_received!' do
      @s.data_received!
      @s.state.should == :process_state
    end

    it 'changes to shutdown_state given shutdown_request! ' do
      @s.shutdown_request!
      @s.state.should == :shutdown_state
    end
    
    it 'changes to log_changes_state given log_changes_timed_event! ' do
      @s.log_changes_timed_event!
      @s.state.should == :log_changes_state
    end
    
    it 'changes to check_comms_state given check_comms_timed_event!' do
      @s.check_comms_timed_event!
      @s.state.should == :check_comms_state
    end
    
    it 'changes to run_tests_state given run_tests_timed_event!' do
      @s.add_node :idle_state, :run_tests_timed_event!, :run_tests_state
      @s.run_tests_timed_event!
      @s.state.should == :run_tests_state
    end
    
    it 'becomes check_calculations_state given check_calculations_timed_event!' do
      @s.check_calculations_timed_event!
      @s.state.should == :check_calculations_state
    end

    it 'requires check_calculations_timed_event! to be added' do
      @s.add_node :idle_state, :check_calculations_timed_event!, :check_calculations_state
    end
    
  end

  describe 'check_calculations_state' do
    before do
      @s.climb_to :check_calculations_state
    end
    
    it 'becomes check_rate_state given check_rate! ' do
      @s.check_rate!
      @s.state.should == :check_rate_state
    end

    it 'requires check_rate_state' do
      @s.add_node :check_calculations_state, :check_rate!, :check_rate_state
    end
  end
  
  describe 'check_rate_state' do
    before do
      @s.climb_to :check_rate_state
    end

    it 'becomes check_volume_state given rate_checked!' do
      @s.rate_checked!
      @s.state.should == :check_volume_state
    end
    
    it 'requires the check_volume_state' do
      @s.add_node :check_rate_state, :rate_checked!, :check_volume_state
    end
  end
  
  describe 'check_volume_state' do
    before do
      @s.climb_to :check_volume_state
    end
    
    it 'becomes idle_state given volume_checked' do
      @s.volume_checked!
      @s.state.should == :idle_state
    end

    it 'requires volume_checked transition' do
      @s.add_node :check_volume_state, :volume_checked!, :idle_state
    end
    
  end
    
  describe 'run_tests_state' do
    before do
      @s.climb_to :run_tests_state
    end
    
    it 'remove unwanted node test_state' do
      @s.delete_node :test_state, :test_running!, :test_state
    end
      
    it 'is reentrant given test_running!' do
      @s.add_node :run_tests_state, :test_running!, :run_tests_state
      @s.test_running!
      @s.state.should == :run_tests_state
    end
    
    it' becomes idle_state given tests completed' do
      @s.tests_completed!
      @s.state.should == :idle_state
    end
    
    it 'requires event tests_completed! ' do
      @s.add_node :run_tests_state, :tests_completed!, :idle_state
    end
    
  end
  
  describe 'process_state' do
    before do
      @s.climb_to :process_state
    end
    
    it 'changes to idle_state given processed!' do
      @s.processed!
      @s.state.should == :idle_state
    end
    
  end
  
  describe 'log_changes_state' do
    before do
      @s.climb_to :log_changes_state
    end
    
    it 'changes to idle_state given changes_logged!' do
      @s.changes_logged!
      @s.state.should == :idle_state
    end
    
  end
  
  describe 'check_comms_state' do
    before do
      @s.climb_to :check_comms_state
    end
    
    it 'changes to check_comms_state given processing_comms!' do
      @s.processing_comms!
      @s.state.should == :check_comms_state
    end
    
    it 'changes to idle_state given comms_processed!' do
      @s.comms_processed!
      @s.state.should == :idle_state
    end
    
  end
  
  describe 'shutdown_state' do
    before do
      @s.climb_to :shutdown_state
    end
    
    it 'is reentrant given shutting_down!' do
      @s.shutting_down!
      @s.state.should == :shutdown_state
     end

  end
end







