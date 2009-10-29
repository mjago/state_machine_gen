require File.
  expand_path(File.
              join(File.
                   dirname(__FILE__),'..','state','build_state_machine'))

describe 'generate state machine called comms_driver' do
  before(:each) do
    @sm = BuildStateMachine.new('comms_driver_state')
    @s = @sm.state_machine
  end
  after(:each) do
    @sm = nil
    @s = nil
  end
  
  it 'returns a state_machine in the instance variable state_machine' do
    @s.class.should == StateMachine
  end
  
  describe 'init_state' do
    
    it 'is the initial state' do
      @s.state.should == :init_state
    end
    
    it 'changes state to idle state once initialised' do
      @s.initialised!
      @s.state.should == :idle_state
    end
  end
  
  describe 'idle_state' do 
    
    before do
      @s.initialised!
    end
    
    it 'is re-entrant given no_data!' do
      @s.no_data!
      @s.state.should == :idle_state
    end
    
    it 'changes to check_format_state given data_received!' do
      @s.data_received!
      @s.state.should == :check_format_state
    end
  end    
  
  describe 'check_format_state' do 
    
    before do
      @s.initialised!
      @s.data_received!
    end
    
    it 'changes to format_error_state given format_error!' do
      @s.format_error!
      @s.state.should == :format_error_state
    end
    
    it 'changes to check_for_buffer_full_state given no_format_error!' do
      @s.no_format_error!
      @s.state.should == :check_major_scope_state
    end
  end    
  
  describe 'check_major_scope_state' do
    before do
      @s.initialised!
      @s.data_received!
      @s.no_format_error!
    end

    it 'goes to check_minor_scope_state given major_scope_allowed!' do
      @s.major_scope_allowed!
      @s.state.should == :check_minor_scope_state
    end

    it 'goes to invalid_scope_state given major_scope_not_allowed!' do
      @s.major_scope_not_allowed!
      @s.state.should == :invalid_scope_state
    end
  end
  
  describe 'invalid_scope_state' do
    before do
      @s.initialised!
      @s.data_received!
      @s.no_format_error!
      @s.major_scope_not_allowed!
    end

    it 'goes to idle_state given invalid_scope_error_logged' do
      @s.invalid_scope_error_logged!
      @s.state.should == :idle_state
    end
  end

  describe 'check_minor_scope_state' do
    before do
      @s.initialised!
      @s.data_received!
      @s.no_format_error!
      @s.major_scope_allowed!  
    end

    it 'goes to check_for_buffer_full_state given minor_scope_allowed!' do
      @s.minor_scope_allowed!
      @s.state.should == :check_for_buffer_full_state
      
    end
    it 'goes to invalid_scope_state given minor_scope_not_allowed!' do
      @s.minor_scope_not_allowed!
      @s.state.should == :invalid_scope_state
    end
    
  end

  describe 'format_error_state' do 
    
    before do
      @s.initialised!
      @s.data_received!
      @s.format_error!
    end
    
    it 'changes to flush_buffer_state given format_error_logged!' do
      @s.format_error_logged!
      @s.state.should == :flush_buffer_state
    end
  end

  describe 'flush_buffer_state' do 
    
    before do
      @s.initialised!
      @s.data_received!
      @s.format_error!
      @s.format_error_logged!
    end
    
    it 'goes to idle_state given flushed!' do
      @s.flushed!
      @s.state.should == :idle_state
    end
  end

  describe 'check_for_buffer_full_state' do
    before do
      @s.initialised!
      @s.data_received!
      @s.no_format_error!
      @s.major_scope_allowed!
      @s.minor_scope_allowed!
    end
    
    it 'goes to check_buffer_release_timeout_state on buffer_full!' do
      @s.buffer_full!
      @s.
        state.
        should == :check_buffer_release_timeout_state
    end

    it 'goes to store_in_buffer_state given buffer_not_full!' do
      @s.buffer_not_full!
      @s.state.should == :store_in_buffer_state
    end
  end

  describe 'buffer_full_error_state' do
    before do
      @s.initialised!
      @s.data_received!
      @s.no_format_error!
      @s.buffer_full!
    end

  end
  
  describe 'store_in_buffer_state' do
    before do
      @s.initialised!
      @s.data_received!
      @s.no_format_error!
      @s.major_scope_allowed!
      @s.minor_scope_allowed!
      @s.buffer_not_full!
    end

    it 'goes to log_message_sent_state on :stored' do
      @s.stored!
      @s.state.should == :log_message_sent_state
    end
  end

  describe 'log_message_sent_state' do
    before do
      @s.initialised!
      @s.data_received!
      @s.no_format_error!
      @s.major_scope_allowed!
      @s.minor_scope_allowed!
      @s.buffer_not_full!
      @s.stored!
    end

    it 'goes to idle_state on message_logged!' do
      @s.message_logged!
      @s.state.should == :idle_state
    end
  end
end






