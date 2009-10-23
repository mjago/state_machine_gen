
 class StateData
   attr_reader :main_state_data

   def self.main_state_data
     [
      [:init_state, :initialised!, :check_timers_state],
      [:init_state, :critical_initialisation_error!, :system_failure_state],
      [:init_state, :initialisation_warning!, :system_warning_state],
      
      [:check_timers_state, :timers_processed!, :check_comms_state],
      [:check_comms_state, :comms_processed!, :check_timers_state],
      
      [:system_failure_state, :await_off!,:system_failure_state],
     ]
   end

 end


