require "digest/sha2"

@all_sha2s = []
def get_SHA2(state)
  sha2 = Digest::SHA2.new << state
  sha2 = sha2.to_s.upcase[0..7]
#  sha2 = "duplicate" # test for duplicacy
  if @all_sha2s.include?(sha2)
    puts"ERROR! Duplicate SHA2 flow hash detected when generating for state #{state}"
    exit 1
  end
  @all_sha2s << sha2
  sha2
end

uip_state_data = <<UIP_STATE_DATA
uip_init -> uip_idle (transition_1)
uip_idle -> uip_idle (transition_2)
uip_idle -> uip_process (transition_3)
uip_process -> uip_process (transition_4)
uip_process -> uip_idle  (transition_5)
UIP_STATE_DATA

systick_state_data = <<SYSTICK_STATE_DATA
systick_init -> systick_idle (transition_1)
systick_idle -> systick_idle (transition_2)
systick_idle -> systick_process (transition_3)
systick_process -> systick_process (transition_4)
systick_process -> systick_idle  (transition_5)
SYSTICK_STATE_DATA

usb_state_data = <<USB_STATE_DATA
usb_init -> usb_idle (transition_1)
usb_idle -> usb_idle (transition_2)
usb_idle -> usb_process (transition_3)
usb_process -> usb_process (transition_4)
usb_process -> usb_idle  (transition_5)
USB_STATE_DATA

state_table_c_begin = <<FLOW_VALIDATION_C
const state_t FLOW_validation_table[] =
{
  
FLOW_VALIDATION_C

state_table_c_end = <<FLOW_VALIDATION_C

#pragma code

FLOW_VALIDATION_C

state_table_c_begin = <<STATE_TABLE_C
\\* state_table.c... *\\

#include "state_table.h"
#include "flow.h"
#include "types.h"

#pragma code STATE_TABLE_CODE

state_t state_table(fsm_t fsm, state_t state)
{
    static fsm_t ( * const _state_table[STATE_NUM_OF_STATES])(void) = {
    
STATE_TABLE_C

state_table_c_end = <<STATE_TABLE_C
    }

    VALIDATE_FSM_LIMITS(fsm);
    VALIDATE_STATE_LIMITS(state);
    return(* _state_table[state])();
}

#pragma code 

STATE_TABLE_C

state_table_h_begin = <<STATE_TABLE_H
\\* state_table.h... *\\

#ifndef STATE_TABLE_H
#define STATE_TABLE_H

static state_t state_table( * const _state_table[STATE_NUM_OF_STATES])(void); 

typedef enum
{   
STATE_TABLE_H

state_table_h_end = <<STATE_TABLE_H
} state_t;

#endif
STATE_TABLE_H

state_routines_c_begin = <<STATE_ROUTINES_C
\\* state_routines.c... *\\

#include "state_table.h"
#include "state_routines.h"
#include "flow.h"
#include "types.h"

#pragma code STATE_ROUTINES_CODE

STATE_ROUTINES_C

state_routines_c_end = <<STATE_ROUTINES_C

#pragma code

STATE_ROUTINES_C

state_routines_h_begin = <<STATE_ROUTINES_H
\\* state_routines.h... *\\

#ifndef STATE_ROUTINES_H
#define STATE_ROUTINES_H

#include "types.h"

STATE_ROUTINES_H

state_routines_h_end = <<STATE_ROUTINES_H

#endif
STATE_ROUTINES_H

function_hash_c_begin = <<FUNCTION_HASH_C
#include "function_hash.h"
#include "types.h"

const flow_hash_t FLOW_source_table[] = 
{
FUNCTION_HASH_C

function_hash_c_middle = <<FUNCTION_HASH_C
};

const sint32_t FLOW_source_offset_table[] =
{
FUNCTION_HASH_C

function_hash_c_end = <<FUNCTION_HASH_C
};

#pragma code

FUNCTION_HASH_C

function_hash_h_begin = <<FUNCTION_HASH_H
#ifndef _FUNCTION_HASH_H
#define _FUNCTION_HASH_H

#include "types.h"

typedef enum
{
FUNCTION_HASH_H

function_hash_h_middle = <<FUNCTION_HASH_H
} flow_hash_t;

typedef enum
{
FUNCTION_HASH_H

function_hash_h_end = <<FUNCTION_HASH_H
} flow_t;

extern const FLOW_Hash_t FLOW_hash_table[FLOW_NUM_OF_FUNCTIONS];
extern const sint32_t FLOW_source_table[];
extern const sint32_t FLOW_source_offset_table[];

#endif
FUNCTION_HASH_H










    #~ FLOW_FN1_HASH = 0x12345678,
    #~ FLOW_FN2_HASH = 0x22345678,
    #~ FLOW_FN3_HASH = 0x32345678,
    #~ FLOW_FN4_HASH = 0x42345678,
  #~ } FLOW_Function_Hashes_t;

#~ typedef enum
  #~ {
    #~ FLOW_FN1 = 0,
    #~ FLOW_FN2,
    #~ FLOW_FN3,
    #~ FLOW_FN4,
    #~ FLOW_NUM_OF_FUNCTIONS
  #~ } FLOW_Functions_t;

#~ extern const FLOW_Hash_t FLOW_hash_table[FLOW_NUM_OF_FUNCTIONS];
#~ extern const sint32_t FLOW_source_table[];
#~ extern const sint32_t FLOW_source_offset_table[];

#~ #endif
#~ FUNCTION_HASH_H























#puts @state_data.inspect
@state_data = [uip_state_data]
@state_data += [usb_state_data]
@state_data += [systick_state_data]

@out_state_table_c = state_table_c_begin
@out_state_table_h = state_table_h_begin
@out_state_routines_c = state_routines_c_begin
@out_state_routines_h = state_routines_h_begin
@out_function_hash_c = function_hash_c_begin
@out_function_hash_h = function_hash_h_begin

@line_count = 0
@all_states = []
@fsm_states= []
@from_states = []
@to_states = []
@state_data.to_s.each_line do |line|
  if line.include? '->'
    from_state = line[0..line.index('->') -2].strip
    from_state = 'STATE_' + from_state
    line = line[line.index('->') + 2  .. -1].strip
    to_state = line[0..line.index('(') - 1 ].strip
    to_state = 'STATE_' + to_state
    @fsm_states << from_state
    @fsm_states << to_state
    @fsm_states.uniq!
      
    @all_states << from_state
    @all_states << to_state
    @all_states.uniq!
    
    @from_states[@line_count] = from_state
    @to_states[@line_count] = to_state
    @line_count += 1
  end
end
@fsm_states.each do |state|
  @out_state_routines_c += "\nstate_t #{state}(void)\n"
  @out_state_routines_c += "{\n    FLOW_check(#{state.upcase});\n\n"
  @out_state_routines_c += "    \\* code goes here *\\\n\n"
  @out_state_routines_c += "    return(#{state.upcase});\n"
  @out_state_routines_c += "}\n"
  @out_state_routines_h += "state_t #{state}(void);\n"
  @out_state_table_c += "        #{state},\n"
  @out_state_table_h += "    #{state.upcase},\n"
  @out_function_hash_h += "    #{state.upcase.gsub('STATE_','FLOW_HASH_')} = #{get_SHA2(state)},\n"
end

@out_function_hash_h += function_hash_h_middle

@dest_states = []
@state_positions = []
@current_state = ""
@source_count = 0
@all_states.each do |state|
  source_count_logged = false
  0.upto(@from_states.length - 1) do |count| 
    if state == @from_states[count]
      if not source_count_logged
        @state_positions << count
        source_count_logged = true
      end
      @dest_states << @to_states[count] 
    end
  end
end

@dest_states.each do |state|
  @out_function_hash_c += "    #{state.upcase.gsub('STATE_','FLOW_HASH_')},\n"
end

@out_function_hash_c += function_hash_c_middle

@state_positions.each do |position|
  @out_function_hash_c += "    #{position},\n"
end

@fsm_states.each do |state|
  @out_function_hash_h += "    #{state.upcase.gsub('STATE_','FLOW_')},\n"
end


@out_state_table_h += "\n"
@out_state_table_c +=   "\n"
@out_state_routines_h += "\n"
@out_state_table_c += state_table_c_end   
@out_state_routines_h += state_routines_h_end   
@out_state_table_h += "    STATE_NUM_OF_STATES = #{@all_states.size}\n"
@out_state_table_h += state_table_h_end
@out_function_hash_c += function_hash_c_end
@out_function_hash_h += function_hash_h_end

[
 @out_state_table_c,
 @out_state_table_h,
 @out_state_routines_c,
 @out_state_routines_h
]
































#~ |
#~ @out_state_table_c = state_table_c_begin
#~ @out_state_table_h = state_table_h_begin
#~ @out_state_routines_c = state_routines_c_begin
#~ @out_state_routines_h = state_routines_h_begin

#~ @line_count = 0
#~ @all_states = []
#~ @from_states = []
#~ @to_states = []
#~ @state_data.each do |fsm|
  #~ @fsm_states= []
  #~ fsm.each_line do |line|
    #~ @line_count += 1
    #~ if line.include? '->'
      #~ from_state = line[0..line.index('->') -2].strip
      #~ line = line[line.index('->') + 2  .. -1].strip
      #~ to_state = line[0..line.index('(') - 1 ].strip
      #~ @fsm_states << from_state
      #~ @fsm_states << to_state
      #~ @fsm_states.uniq!
      
      #~ @all_states << from_state
      #~ @all_states << to_state
      #~ @all_states.uniq!
      #~ @from_states[@line_count] = from_state
      #~ @to_states[@line_count] = to_state
    #~ end
  #~ end
  #~ @fsm_states.each do |state|
    #~ @out_state_routines_c += "\nstate_t #{state}(void)\n"
    #~ @out_state_routines_c += "{\n    FLOW_check(#{state.upcase});\n\n"
    #~ @out_state_routines_c += "    \\* code goes here *\\\n\n"
    #~ @out_state_routines_c += "    return(#{state.upcase});\n"
    #~ @out_state_routines_c += "}\n"
    #~ @out_state_routines_h += "state_t #{state}(void);\n"
    #~ @out_state_table_c += "        #{state},\n"
    #~ @out_state_table_h += "    #{state.upcase} = #{get_SHA2(state)},\n"
  #~ end
  #~ @out_state_table_h += "\n"
  #~ @out_state_table_c +=   "\n"
  #~ @out_state_routines_h += "\n"
#~ end
#~ @out_state_table_c += state_table_c_end   
#~ @out_state_routines_h += state_routines_h_end   
#~ @out_state_table_h += "    STATE_NUM_OF_STATES = #{@all_states.size}\n"
#~ @out_state_table_h += state_table_h_end

puts

#~ 16.times { print '-   '}; puts
#~ puts @out_state_table_c

#~ 16.times { print '-   '}; puts
#~ puts @out_state_table_h

#~ 16.times { print '-   '}; puts
#~ puts @out_state_routines_c

#~ 16.times { print '-   '}; puts
#~ puts @out_state_routines_h

16.times { print '-   '}; puts
puts @out_function_hash_c

16.times { print '-   '}; puts



