
 class StateData
   attr_reader :main_state_data

   def self.main_state_data
     [
      [:init_state, :initialised!, :check_timers_state],
      [:init_state, :critical_initialisation_error!, :system_failure_state],
      [:init_state, :initialisation_warning!, :queue_init_warning_state],
      
      [:queue_init_warning_state, :init_warning_queued!, :check_timers_state],
      
      [:check_timers_state, :timers_processed!, :check_comms_state],
      [:check_timers_state, :timer_warning!, :queue_timer_warning_state],
      
      [:queue_timer_warning_state, :timer_warning_queued!, :check_comms_state],
      
      [:check_comms_state, :comms_processed!, :process_alarms_state],
      [:check_comms_state, :comms_warning!, :queue_comms_warning_state],
      
      [:queue_comms_warning_state, :comms_warning_queued!, :process_alarms_state],

      [:process_alarms_state, :alarms_processed!, :process_warnings_state],
      
      [:process_warnings_state, :warnings_processed!, :check_timers_state],
      
      [:system_failure_state, :await_off!,:system_failure_state],
      
     ]
   end

 end


