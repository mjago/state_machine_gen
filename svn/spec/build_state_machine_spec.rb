
require File.
  expand_path(File.
              join(File.
                   dirname(__FILE__),'..','state','build_state_machine'))

describe 'StateMachine' do
  before(:each) do
    @s = BuildStateMachine.new('test_state').state_machine
  end
  
  after(:each) do
    @s = nil
  end
  
  describe 'should be an instance of StateMachine' do
    it  do
      @s.class.should == StateMachine
    end
  end
  
  describe 'state method' do
    it 'a method called state should be available' do
      @s.methods.include?('state').should == true
    end

    it 'should accept .send and return current state' do
      @s.state.should == :init_state
    end  
  end
  
  describe 'states' do    
    describe 'init_state' do
      it 'becomes idle_state given initialised!' do  
         @s.initialised!
        @s.state.should == :idle_state
      end
    end

    describe 'idle_state' do
      before do
        @s.climb_to :idle_state
      end
      
      it 'becomes process_state given data_received!' do
        @s.data_received!
        @s.state.should == :process_state
      end
      
      it 'requires the data_received! event' do
        @s.add :idle_state, :data_received!, :process_state
      end

      it 'becomes "timers_state given timers_event!' do
        @s.timers_event!
        @s.state.should == :timers_state
      end
      it 'requires the timers_event! event' do
        @s.add :idle_state, :timers_event!, :timers_state
      end
      
      it 'becomes "comms_state given comms_event!' do
        @s.comms_event!
        @s.state.should == :comms_state
      end
      it 'requires the comms_event! event' do
        @s.add :idle_state, :comms_event!, :comms_state
      end
      
      it 'becomes "shutdown_state given shutdown_event!' do
        @s.shutdown_event!
        @s.state.should == :shutdown_state
      end
      it 'requires the shutdown_event! event' do
        @s.add :idle_state, :shutdown_event!, :shutdown_state
      end
    end
        
    describe 'process_state' do
      before { @s.climb_to :process_state}
      
      it 'becomes idle_state given data_processed!' do
        @s.data_processed!
        @s.state.should == :idle_state
      end

      it 'requires the data_processed! event' do
        @s.add :process_state, :data_processed!, :idle_state
      end
    end
    
    describe 'timers_state' do
      before { @s.climb_to :timers_state}
      
      it 'becomes idle_state given timers_processed!' do
        @s.timers_processed!
        @s.state.should == :idle_state
      end
      it 'requires the timers_processed! event' do
        @s.add :timers_state, :timers_processed!, :idle_state
      end
    end
    
    describe 'comms_state' do
      before { @s.climb_to :comms_state}
      
      it 'becomes idle_state given comms_processed!' do
        @s.comms_processed!
        @s.state.should == :idle_state
      end
      it 'requires the comms_processed! event' do
        @s.add :comms_state, :comms_processed!, :idle_state
      end
    end
    
    describe 'shutdown_state' do
      before { @s.climb_to :shutdown_state}
      
      it 'is reentrant given shutting_down!' do
        @s.shutting_down!
        @s.state.should == :shutdown_state
      end
       it 'requires the shutting_down! event' do
         @s.add :shutdown_state, :shutting_down!, :shutdown_state
       end
     end
  end
end
