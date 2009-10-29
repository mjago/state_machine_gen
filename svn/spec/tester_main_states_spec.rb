
require File.
  expand_path(File.
              join(File.
                   dirname(__FILE__),'..','state','build_state_machine'))

require File.
  expand_path(File.
              join(File.
                   dirname(__FILE__),'..','state','stateData','state_data'))

describe StateData do
  before(:each) do
    @s = BuildStateMachine.new('tester_main_state')
  end
  
  describe 'buildstatemachine' do
    
    it "exists as a class" do
      @s.class.should == BuildStateMachine
    end
    
    it 'has a method called build_state_machine' do
      @s.methods.include?('build_state_machine').should == true
    end
    
    it 'returns a state machine when passed a state machine data name' do
      @s.build_state_machine('tester_main_state_data').class.should == Statemachine::Statemachine
    end

    ######################
    # tester_main_states #
    ######################
    
    describe "tester_main_states" do
      it 'should have statemachine called tester_main_states' do
        pending
        @s.tester_main_states.class.should == Statemachine::Statemachine
      end

      describe 'init_state' do
        it 'is the initial state' do
          pending
          @s.tester_main_states.state.should == :init_state
        end
        
        it 'changes to listen_for_dev_state given initialised!' do
          pending
          @s.tester_main_states.initialised!
          @s.tester_main_states.state.should == :listen_for_dev_state
        end
      end
      
      describe 'listen_for_dev_state' do
        before do
          pending
          @s.climb_to :listen_for_dev_state  
          @s.tester_main_states.initialised!
        end
        
        it 'is re-entrant given dev_unheard' do
          @s.tester_main_states.dev_unheard!
          @s.tester_main_states.state.should == :listen_for_dev_state
        end
        
        it 'changes to contact_dev_state given dev_heard!' do
          @s.tester_main_states.dev_heard!
          @s.tester_main_states.state.should == :contact_dev_state
        end
        
        it 'changes to init_state given listen_for_dev_timeout!' do
          @s.tester_main_states.listen_for_dev_timeout!
          @s.tester_main_states.state.should == :init_state
        end
      end      
      
      describe 'contact_dev_state' do
        before do
          pending
          @s.climb_to :listen_for_dev_state
        end
        
        it 'is re-entrant given dev_not_contacted' do
          pending
          @s.tester_main_states.dev_not_contacted!
          @s.tester_main_states.state.should == :contact_dev_state
        end
        
        it 'changes to full_duplex_state given dev_contacted!' do
          pending
          @s.tester_main_states.dev_contacted!
          @s.tester_main_states.state.should == :full_duplex_state
        end
        
        it 'changes to listen_for_dev_state given dev_contact_timeout!' do
          pending
          @s.tester_main_states.dev_contact_timeout!
          @s.tester_main_states.state.should == :listen_for_dev_state
        end
      end
    end
  end
end

