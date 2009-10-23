require File.
  expand_path(File.
              join(File.
                   dirname(__FILE__),'..','state','build_state_machine'))


describe 'generate state machine called comms_driver' do
  before do
    @comms_driver_state = nil
  end
  
  
  it 'returns a state machine when passed a state machine data name' do
    @comms_driver_state = BuildStateMachine.new.build_state_machine('comms_driver_state_data')
    @comms_driver_state.class.should == Statemachine::Statemachine
  end
  
  describe 'init_state' do
    
    before do
      @comms_driver_state = BuildStateMachine.new.build_state_machine('comms_driver_state_data')
    end
    
    it 'is the initial state' do
      @comms_driver_state.state.should == :init_state
    end
    
    it 'changes state to idle state once initialised' do
      @comms_driver_state.initialised!
      @comms_driver_state.state.should == :idle_state
    end
  end
  
  describe 'idle_state' do 
    
    before do
      @comms_driver_state = BuildStateMachine.new.build_state_machine('comms_driver_state_data')
      @comms_driver_state.initialised!
    end
    
    it 'is re-entrant given no_data!' do
      @comms_driver_state.no_data!
      @comms_driver_state.state.should == :idle_state
    end
    
    it 'changes to check_format_state given data_received!' do
      @comms_driver_state.data_received!
      @comms_driver_state.state.should == :check_format_state
    end
  end    
  
  describe 'check_format_state' do 
    
    before do
      @comms_driver_state = BuildStateMachine.new.build_state_machine('comms_driver_state_data')
      @comms_driver_state.initialised!
      @comms_driver_state.data_received!
    end
    
    it 'changes to format_error_state given format_error!' do
      @comms_driver_state.format_error!
      @comms_driver_state.state.should == :format_error_state
    end
    
    it 'changes to check_for_buffer_full_state given no_format_error!' do
      @comms_driver_state.no_format_error!
      @comms_driver_state.state.should == :check_major_scope_state
    end
  end    
  
  describe 'check_major_scope_state' do
    before do
      @comms_driver_state =
        BuildStateMachine.
        new.
        build_state_machine('comms_driver_state_data')
      @comms_driver_state.initialised!
      @comms_driver_state.data_received!
      @comms_driver_state.no_format_error!
    end

    it 'goes to check_minor_scope_state given major_scope_allowed!' do
      @comms_driver_state.major_scope_allowed!
      @comms_driver_state.state.should == :check_minor_scope_state
    end

    it 'goes to invalid_scope_state given major_scope_not_allowed!' do
      @comms_driver_state.major_scope_not_allowed!
      @comms_driver_state.state.should == :invalid_scope_state
    end
  end
  
  describe 'invalid_scope_state' do
    before do
      @comms_driver_state =
        BuildStateMachine.
        new.
        build_state_machine('comms_driver_state_data')
      @comms_driver_state.initialised!
      @comms_driver_state.data_received!
      @comms_driver_state.no_format_error!
      @comms_driver_state.major_scope_not_allowed!
    end

    it 'goes to idle_state given invalid_scope_error_logged' do
      @comms_driver_state.invalid_scope_error_logged!
      @comms_driver_state.state.should == :idle_state
    end
  end
  
  describe 'check_minor_scope_state' do
    before do
      @comms_driver_state =
        BuildStateMachine.
        new.
        build_state_machine('comms_driver_state_data')
      @comms_driver_state.initialised!
      @comms_driver_state.data_received!
      @comms_driver_state.no_format_error!
      @comms_driver_state.major_scope_allowed!  
    end

    it 'goes to check_for_buffer_full_state given minor_scope_allowed!' do
      @comms_driver_state.minor_scope_allowed!
      @comms_driver_state.state.should == :check_for_buffer_full_state
      
    end
    it 'goes to invalid_scope_state given minor_scope_not_allowed!' do
      @comms_driver_state.minor_scope_not_allowed!
      @comms_driver_state.state.should == :invalid_scope_state
    end
    
  end

  describe 'format_error_state' do 
    
    before do
      @comms_driver_state =
        BuildStateMachine.
        new.
        build_state_machine('comms_driver_state_data')
      @comms_driver_state.initialised!
      @comms_driver_state.data_received!
      @comms_driver_state.format_error!
    end
    
    it 'changes to flush_buffer_state given format_error_logged!' do
      @comms_driver_state.format_error_logged!
      @comms_driver_state.state.should == :flush_buffer_state
    end
    
    describe 'flush_buffer_state' do 
      
      before do
        @comms_driver_state =
          BuildStateMachine.
          new.
          build_state_machine('comms_driver_state_data')
        @comms_driver_state.initialised!
        @comms_driver_state.data_received!
        @comms_driver_state.format_error!
        @comms_driver_state.format_error_logged!
      end
      
      it 'goes to idle_state given flushed!' do
        @comms_driver_state.flushed!
        @comms_driver_state.state.should == :idle_state
      end
    end

    describe 'check_for_buffer_full_state' do
      before do
        @comms_driver_state =
          BuildStateMachine.
          new.
          build_state_machine('comms_driver_state_data')
        @comms_driver_state.initialised!
        @comms_driver_state.data_received!
        @comms_driver_state.no_format_error!
        @comms_driver_state.major_scope_allowed!
        @comms_driver_state.minor_scope_allowed!
      end
      
      it 'goes to check_buffer_release_timeout_state on buffer_full!' do
        @comms_driver_state.buffer_full!
        @comms_driver_state.
          state.
          should == :check_buffer_release_timeout_state
      end

      it 'goes to store_in_buffer_state given buffer_not_full!' do
        @comms_driver_state.buffer_not_full!
        @comms_driver_state.state.should == :store_in_buffer_state
      end
    end

    describe 'buffer_full_error_state' do
      before do
        @comms_driver_state =
          BuildStateMachine.
          new.
          build_state_machine('comms_driver_state_data')
        @comms_driver_state.initialised!
        @comms_driver_state.data_received!
        @comms_driver_state.no_format_error!
        @comms_driver_state.buffer_full!
      end

    end
    
    describe 'store_in_buffer_state' do
      before do
        @comms_driver_state =
          BuildStateMachine.
          new.
          build_state_machine('comms_driver_state_data')
        @comms_driver_state.initialised!
        @comms_driver_state.data_received!
        @comms_driver_state.no_format_error!
        @comms_driver_state.major_scope_allowed!
        @comms_driver_state.minor_scope_allowed!
        @comms_driver_state.buffer_not_full!
      end

      it 'goes to log_message_sent_state on :stored' do
        @comms_driver_state.stored!
        @comms_driver_state.state.should == :log_message_sent_state
      end
    end

    describe 'log_message_sent_state' do
      before do
        @comms_driver_state =
          BuildStateMachine.
          new.
          build_state_machine('comms_driver_state_data')
        @comms_driver_state.initialised!
        @comms_driver_state.data_received!
        @comms_driver_state.no_format_error!
        @comms_driver_state.major_scope_allowed!
        @comms_driver_state.minor_scope_allowed!
        @comms_driver_state.buffer_not_full!
        @comms_driver_state.stored!
      end

      it 'goes to idle_state on message_logged!' do
        @comms_driver_state.message_logged!
        @comms_driver_state.state.should == :idle_state
      end
    end
    
  end
end





