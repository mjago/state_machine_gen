require File.
  expand_path(File.
              join(File.
                   dirname(__FILE__),'..','state','build_state_machine'))

describe 'state machines ' do
  before(:each) do
    @bsm = BuildStateMachine.new('test_state')
    @s = @bsm.state_machine
  end
  
  it '@s should be a state machine ' do
    @s.class.should == StateMachine
  end
end    

# describe 'unconnected_state' do
#   it 'is the initial state' do
#     @s.state.should == :unconnected_state
#   end
  
#   it 'is re-entrant following no_rx_detected!' do
#     @s.no_rx_detected!
#     @s.state.should == :unconnected_state
#   end
  
#   it 'changes state to :tx_only_state following tx_detected!' do
#     @s.tx_detected!
#     @s.state.should == :tx_only_state
#   end
  
#   it 'changes state to :rx_only_state following rx_detected!' do
#     @s.rx_detected!
#     @s.state.should == :rx_only_state
#   end
# end

# describe 'tx_only_state' do
#   before do
#     @s.tx_detected!
#   end

#   it 'is re-entrant following tx_detected!' do
#     @s.tx_detected!
#     @s.state.should == :tx_only_state
#   end
  
#   it 'changes state to full_duplex_state following rx_detected!' do
#     @s.rx_detected!
#     @s.state.should == :full_duplex_state
#   end
  
#   it 'changes state to unconnected_state following tx_dropped!' do
#     @s.tx_dropped!
#     @s.state.should == :unconnected_state
#   end
# end

# describe 'rx_only_state' do
#   before do
#     @s.rx_detected!
#   end

#   it 'is re-entrant following rx_detected!' do
#     @s.rx_detected!
#     @s.state.should == :rx_only_state
#   end
  
#   it 'changes state to full_duplex_state following tx_detected!' do
#     @s.tx_detected!
#     @s.state.should == :full_duplex_state
#   end
  
#   it 'changes state to unconnected_state following rx_dropped!' do
#     @s.rx_dropped!
#     @s.state.should == :unconnected_state
#   end
# end

# describe 'full_duplex_state' do
#   before do
#     @s.rx_detected!
#     @s.tx_detected!
#   end

#   it 'is re-entrant following rx_detected!' do
#     @s.rx_detected!
#     @s.state.should == :full_duplex_state
#   end
  
#   it 'is re-entrant following tx_detected!' do
#     @s.tx_detected!
#     @s.state.should == :full_duplex_state
#   end
  
#   it 'changes state to rx_only_state following tx_dropped!' do
#     @s.tx_dropped!
#     @s.state.should == :rx_only_state
#   end
  
#   it 'changes state to tx_only_state following rx_dropped!' do
#     @s.rx_dropped!
#     @s.state.should == :tx_only_state
#   end
# end

#   #########################
#   # dev_tx_message_states #
#   #########################

# describe "dev_tx_message_states" do
#   it 'should have statemachine called dev_tx_message_states' do
#     @s.dev_tx_message_states.class.should == Statemachine::Statemachine
#   end
  
#   describe 'idle_state' do
#     it 'is the initial state' do
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
    
#     it 'is re-entrant given no_action!' do
#       @s.dev_tx_message_states.no_action!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
    
#     it 'changes state to sending_file_state given send_file!' do
#       @s.dev_tx_message_states.send_file!
#       @s.dev_tx_message_states.state.should == :sending_file_state
#     end
    
#     it 'changes state to deleting_file_state given delete_file!' do
#       @s.dev_tx_message_states.delete_file!
#       @s.dev_tx_message_states.state.should == :deleting_file_state
#     end
    
#     it 'changes state to sending_structure_state given send_structure!' do
#       @s.dev_tx_message_states.send_structure!
#       @s.dev_tx_message_states.state.should == :sending_structure_state
#     end
    
#     it 'changes state to sending_hash_state given send_hash!' do
#       @s.dev_tx_message_states.send_hash!
#       @s.dev_tx_message_states.state.should == :sending_hash_state
#     end
    
#     it 'changes state to sending_tick_state given send_tick!' do
#       @s.dev_tx_message_states.send_tick!
#       @s.dev_tx_message_states.state.should == :sending_tick_state
#     end
#   end

#   describe 'sending_file_state' do
#     before do
#       @s.dev_tx_message_states.send_file!
#     end
    
#     it 'is re-entrant given no_action!' do
#       @s.dev_tx_message_states.no_action!
#       @s.dev_tx_message_states.state.should == :sending_file_state
#     end
    
#     it 'changes state to idle_state following ack_received!' do
#       @s.dev_tx_message_states.ack_received!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
    
#     it 'changes state to idle_state following nak_received!' do
#       @s.dev_tx_message_states.nak_received!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
    
#     it 'changes state to idle_state following rx_timeout!' do
#       @s.dev_tx_message_states.rx_timeout!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
    
#     it 'changes state to idle_state following rx_timeout!' do
#       @s.dev_tx_message_states.rx_timeout!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
#   end
  
#   describe 'deleting_file_state' do
#     before do
#       @s.dev_tx_message_states.delete_file!
#     end
    
#     it 'is re-entrant given no_action!' do
#       @s.dev_tx_message_states.no_action!
#       @s.dev_tx_message_states.state.should == :deleting_file_state
#     end
    
#     it 'changes state to idle_state following ack_received!' do
#       @s.dev_tx_message_states.ack_received!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
    
#     it 'changes state to idle_state following nak_received!' do
#       @s.dev_tx_message_states.nak_received!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
    
#     it 'changes state to idle_state following rx_timeout!' do
#       @s.dev_tx_message_states.rx_timeout!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
    
#     it 'changes state to idle_state following rx_timeout!' do
#       @s.dev_tx_message_states.rx_timeout!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
#   end
  
#   describe 'sending_structure_state' do
#     before do
#       @s.dev_tx_message_states.send_structure!
#     end
    
#     it 'is re-entrant given no_action!' do
#       @s.dev_tx_message_states.no_action!
#       @s.dev_tx_message_states.state.should == :sending_structure_state
#     end
    
#     it 'changes state to idle_state following ack_received!' do
#       @s.dev_tx_message_states.ack_received!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
    
#     it 'changes state to idle_state following nak_received!' do
#       @s.dev_tx_message_states.nak_received!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
    
#     it 'changes state to idle_state following rx_timeout!' do
#       @s.dev_tx_message_states.rx_timeout!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
    
#     it 'changes state to idle_state following rx_timeout!' do
#       @s.dev_tx_message_states.rx_timeout!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
#   end
  
#   describe 'sending_tick_state' do
#     before do
#       @s.dev_tx_message_states.send_tick!
#     end
    
#     it 'is re-entrant given no_action!' do
#       @s.dev_tx_message_states.no_action!
#       @s.dev_tx_message_states.state.should == :sending_tick_state
#     end
    
#     it 'changes state to idle_state following ack_received!' do
#       @s.dev_tx_message_states.ack_received!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
    
#     it 'changes state to idle_state following nak_received!' do
#       @s.dev_tx_message_states.nak_received!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
    
#     it 'changes state to idle_state following rx_timeout!' do
#       @s.dev_tx_message_states.rx_timeout!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
    
#     it 'changes state to idle_state following rx_timeout!' do
#       @s.dev_tx_message_states.rx_timeout!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
#   end
  
#   describe 'sending_hash_state' do
#     before do
#       @s.dev_tx_message_states.send_hash!
#     end
    
#     it 'is re-entrant given no_action!' do
#       @s.dev_tx_message_states.no_action!
#       @s.dev_tx_message_states.state.should == :sending_hash_state
#     end
    
#     it 'changes state to idle_state following ack_received!' do
#       @s.dev_tx_message_states.ack_received!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
    
#     it 'changes state to idle_state following nak_received!' do
#       @s.dev_tx_message_states.nak_received!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
    
#     it 'changes state to idle_state following rx_timeout!' do
#       @s.dev_tx_message_states.rx_timeout!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
    
#     it 'changes state to idle_state following rx_timeout!' do
#       @s.dev_tx_message_states.rx_timeout!
#       @s.dev_tx_message_states.state.should == :idle_state
#     end
#   end
# end

# #########################
# # dev_rx_message_states #
# #########################

# describe "dev_rx_message_states" do
#   it 'should have statemachine called dev_rx_message_states' do
#     @s.dev_rx_message_states.class.should == Statemachine::Statemachine
#   end
  
#   describe 'idle_state' do
#     it 'is the initial state' do
#       @s.dev_rx_message_states.state.should == :idle_state
#     end
    
#     it 'is re-entrant given no_action!' do
#       @s.dev_rx_message_states.no_action!
#       @s.dev_rx_message_states.state.should == :idle_state
#     end
    
#     it 'changes to testing_async_rx_state given test_async_rx!' do
#       @s.dev_rx_message_states.test_async_rx!
#       @s.dev_rx_message_states.state.should == :testing_async_rx_state
#     end
    
#     it 'changes to awaiting_ack_state given await_ack!' do
#       @s.dev_rx_message_states.await_ack!
#       @s.dev_rx_message_states.state.should == :awaiting_ack_state
#     end
#   end
  
#   describe 'testing_async_rx_state' do
#     before do
#       @s.dev_rx_message_states.test_async_rx!
#     end

#     it 'changes to idle_state following no_async_rx_data!' do
#       @s.dev_rx_message_states.no_async_rx_data!
#       @s.dev_rx_message_states.state.should == :idle_state
#     end

#     it 'changes to idle_state following async_rx_data!' do
#       @s.dev_rx_message_states.async_rx_data!
#       @s.dev_rx_message_states.state.should == :idle_state
#     end
#   end
# end

# ############################
# # tester_tx_message_states #
# ############################

# describe "tester_tx_message_states" do
#   it 'should have statemachine called tester_tx_message_states' do
#     @s.tester_tx_message_states.class.should == Statemachine::Statemachine
#   end
  
#   describe 'idle_state' do
#     it 'is the initial state' do
#       @s.tester_tx_message_states.state.should == :idle_state
#     end
    
#     it 'is re-entrant given no_action!' do
#       @s.tester_tx_message_states.no_action!
#       @s.tester_tx_message_states.state.should == :idle_state
#     end
    
#   end
# end


# ############################
# # tester_rx_message_states #
# ############################

# describe "tester_rx_message_states" do
#   it 'should have statemachine called tester_rx_message_states' do
#     @s.tester_rx_message_states.class.should == Statemachine::Statemachine
#   end
  
#   describe 'idle_state' do
#     it 'is the initial state' do
#       @s.tester_rx_message_states.state.should == :idle_state
#     end
    
#     it 'is re-entrant given no_action!' do
#       @s.tester_rx_message_states.no_action!
#       @s.tester_rx_message_states.state.should == :idle_state
#     end
    
#   end
# end

# ###############
# # dev_main_states #
# ###############

# describe "dev_main_states" do
#   it 'should have statemachine called dev_main_states' do
#     @s.dev_main_states.class.should == Statemachine::Statemachine
#   end

#   describe 'init_state' do
#     it 'is the initial state' do
#       @s.dev_main_states.state.should == :init_state
#     end
    
#     it 'is changes to contact_tester_state given initialised!' do
#       @s.dev_main_states.initialised!
#       @s.dev_main_states.state.should == :contact_tester_state
#     end
    
#   end
  
#   describe 'contact_tester_state' do
#     before do
#       @s.dev_main_states.initialised!
#     end
    
#     it 'is re-entrant given tester_not_contacted' do
#       @s.dev_main_states.tester_not_contacted!
#       @s.dev_main_states.state.should == :contact_tester_state
#     end
    
#     it 'changes to listen_for_tester_state given tester_contacted!' do
#       @s.dev_main_states.tester_contacted!
#       @s.dev_main_states.state.should == :listen_for_tester_state
#     end
    
#     it 'changes to init_state given contact_tester_timeout!' do
#       @s.dev_main_states.contact_tester_timeout!
#       @s.dev_main_states.state.should == :init_state
#     end
#   end      
  
#   describe 'listen_for_tester_state' do
#     before do
#       @s.dev_main_states.initialised!
#       @s.dev_main_states.tester_contacted!
#     end
    
#     it 'is re-entrant given tester_unheard' do
#       @s.dev_main_states.tester_unheard!
#       @s.dev_main_states.state.should == :listen_for_tester_state
#     end
    
#     it 'changes to full_duplex_state given tester_heard' do
#       @s.dev_main_states.tester_heard!
#       @s.dev_main_states.state.should == :full_duplex_state
#     end
    
#     it 'changes to contact_tester_state given tester_listening_timeout!' do
#       @s.dev_main_states.tester_listening_timeout!
#       @s.dev_main_states.state.should == :contact_tester_state
#     end
#   end
# end

# ########################
# # dev_scheduler_states #
# ########################

# describe "dev_scheduler_states" do
#   it 'should have statemachine called dev_scheduler_states' do
#     @s.dev_scheduler_states.class.should == Statemachine::Statemachine
#   end

#   describe 'is_tick_due_state' do
#     it 'changes to send_tester_tick-state given tick_due!' do
#       @s.dev_scheduler_states.tick_due!
#       @s.dev_scheduler_states.state.should == :send_tick_state
#     end
    
#     it 'changes to have_files_changed_state given tick_not_due!' do
#       @s.dev_scheduler_states.tick_not_due!
#       @s.dev_scheduler_states.state.should == :have_files_changed_state
#     end
#   end
  
#   describe "have_files_changed_state" do
#     before do
#       @s.dev_scheduler_states.tick_not_due!
#     end
    
#     #~ it do
#     #~ end
#   end
  
#   describe "send_tick_state" do
#     before do
#       @s.dev_scheduler_states.tick_due!
#     end
    
#     it 'changes to await_tick_ack_state given sent_tick!' do
#       @s.dev_scheduler_states.sent_tick!
#       @s.dev_scheduler_states.state.should == :await_tick_ack_state
#     end
    
#   end
  
#   describe 'await_tick_ack_state' do
#     before do
#       @s.dev_scheduler_states.tick_due!
#       @s.dev_scheduler_states.sent_tick!
#     end
    
#     it 'changes to have_files_changed_state given received_tick_ack!' do
#       @s.dev_scheduler_states.received_tick_ack!
#       @s.dev_scheduler_states.state.should == :have_files_changed_state
#     end
    
#     it 'changes to increment_tester_nak_state given received_tick_nak!' do
#       @s.dev_scheduler_states.received_tick_nak!
#       @s.dev_scheduler_states.state.should == :increment_tester_nak_state
#     end
    
#     it 'changes to no_connection_state on await_tick_ack_timeout!' do
#       @s.dev_scheduler_states.await_tick_ack_timeout!
#       @s.dev_scheduler_states.state.should == :no_connection_state
#     end
#   end      
# end      


# ###########################
# # tester_scheduler_states #
# ###########################

# # describe "tester_scheduler_states" do
# #   it 'should have statemachine called tester_scheduler_states' do
# #     @s.tester_scheduler_states.class.should == Statemachine::Statemachine
# #   end

# #   describe 'idle_state' do
# #     it 'is re-entrant given no_action!' do
# #       @s.tester_scheduler_states.no_action!
# #       @s.tester_scheduler_states.state.should == :idle_state
# #     end
# #     it 'changes to send_tick_ack_state given tick_received!' do
# #       @s.tester_scheduler_states.tick_received!
# #       @s.tester_scheduler_states.state.should == :send_tick_ack_state
# #     end
# #   end

# #   describe 'send_tick_ack_state' do
# #     before do
# #       @s.tester_scheduler_states.tick_received!
# #     end

# #     it 'changes to idle_state given tick_ack_sent!' do
# #       @s.tester_scheduler_states.tick_ack_sent!
# #       @s.tester_scheduler_states.state.should == :idle_state
# #     end
# #   end
# # end

