
 class StateData
   attr_reader :comms_driver_state_data

   def self.comms_driver_state_data
     [
      [:init_state, :initialised!, :idle_state],
      
      [:idle_state, :no_data!, :idle_state],
      [:idle_state, :data_received!, :check_format_state],
      
      [:check_format_state, :format_error!, :format_error_state],
      [:check_format_state, :no_format_error!, :check_major_scope_state],

      [:check_major_scope_state, :major_scope_allowed!, :check_minor_scope_state],
      [:check_major_scope_state, :major_scope_not_allowed!, :invalid_scope_state],
      
      [:check_minor_scope_state, :minor_scope_allowed!, :check_for_buffer_full_state],
      [:check_minor_scope_state, :minor_scope_not_allowed!, :invalid_scope_state],

      [:invalid_scope_state, :invalid_scope_error_logged!, :idle_state],
      
      [:format_error_state, :format_error_logged!, :flush_buffer_state],

      [:flush_buffer_state, :flushed!, :idle_state],
      
      [:check_for_buffer_full_state, :buffer_full!, :check_buffer_release_timeout_state],
      [:check_for_buffer_full_state, :buffer_not_full!, :store_in_buffer_state],
      
      [:buffer_full_error_state, :buffer_full_logged!, :flush_buffer_state],

      [:check_buffer_release_timeout_state, :buffer_timeout!,
       :buffer_full_error_state],
      [:check_buffer_release_timeout_state, :buffer_not_timed_out!,
       :check_for_buffer_full_state],
      
      [:store_in_buffer_state, :stored!, :log_message_sent_state],
      
      [:log_message_sent_state, :message_logged!, :idle_state],
      
      
      
     ]
   end

 end

