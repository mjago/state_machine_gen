# == Schema Information
# Schema version: 20100408122353
#
# Table name: states
#
#  id         :integer         not null, primary key
#  project    :string(255)
#  device     :string(255)
#  module     :string(255)
#  from       :string(255)
#  to         :string(255)
#  transition :string(255)
#  date       :datetime
#  created_at :datetime
#  updated_at :datetime
#

class State < ActiveRecord::Base
  State_Regex = /^[a-z]\w*$/
  Project_Regex = /^[a-z][a-z][0-9][0-9]$/
  Module_Device_Regex = /^[a-z]\w*$/

  attr_accessor :graph
  attr_accessible :project, :device, :module, :from, :to, :transition
  validates_presence_of :project, :device, :module, :from, :to, :transition
  validates_length_of   :project, :device, :module, :from, :to, :transition, :within  => 2..20
  validates_length_of   :project, :is => 4
  validates_format_of   :project, :with => Project_Regex
  validates_format_of   :device, :with => Module_Device_Regex
  validates_format_of   :module, :with => Module_Device_Regex
  validates_format_of   :from, :with => State_Regex
  validates_format_of   :to,   :with => State_Regex
  
  def check_data_loaded
    if not $loaded_data
      @graph = "This is a test"
      puts "INITIALISING!!!!"
      $loaded_data = true
    end
  end

  def graph g
    @graph = g
  end
  
  def test_method
    puts "Test Method"
  end
  
  def generate_dot params
    text = params[:graph].to_s
    @state = State.new
    @state.test_method
    nodes = []
    from_states = []
    to_states = []
    transitions = []
    from_state = ""
    to_state = ""
    out_string = "edge[color = green, fontcolor = darkgreen, fontname = \"verdana\", "
    out_string += "fontsize = \"16\", URL = \"http://google.com\"];\n"
    out_string += "node[color = black, fillcolor = cadetblue, fontcolor = white, "
    out_string += "fontname = \"verdana\", fontsize = \"16\", shape = circle, style = filled];\n"
    line_count = 0
    
    text.each_line do |line, i|
      line_count += 1
      next if line.strip! == ''
      if line.include? '->'
        if line.include? '('
          if line.include? ')'
            from_state = line[0..line.index('->') -2].strip
            from_state = 'STATE_' + params[:selected_module][:id].to_s.upcase + '_' + from_state
            @state.from = from_state
            from_states << from_state
            line = line[line.index('->') + 2  .. -1].strip
            to_state = line[0..line.index('(') - 1 ].strip
            to_state = 'STATE_' + params[:selected_module][:id].to_s.upcase + '_' + to_state
            @state.to = to_state
            to_states << to_state
            transition = line[line.index('(') + 1 .. line.index(')') - 1].strip
            if transitions.include? transition
              #              flash.now[:notice] = "ERROR: line #{line_count}, missing \")\": #{line.strip} "
            else
              transitions << transition
            end
            @state.transition = transition
            @state.date = Time.now
            if not nodes.include? from_state 
              nodes << from_state
              out_string += "#{from_state} [label = \"  #{from_state.gsub("STATE_","").gsub('_','  \n  ')}  \"]\n"
            end
            if not nodes.include? to_state
              nodes << to_state
              out_string += "#{to_state} [label = \"  #{to_state.gsub("STATE_","").gsub('_','  \n  ')}  \"]\n"
            end
            out_string += "#{from_state} -> #{to_state}"
            out_string += " [#{from_state == to_state ? 'dir = back, ' : ''}label = \"  #{transition.gsub('_','  \n  ').gsub(' ','  \n  ')}!  \"]\n"
            @state.project = "ff04"
            @state.device = @current_device
            @state.module = @current_module
            @state.save
            next
          else
          #  flash.now[:notice] = "ERROR: line #{line_count}, missing \")\": #{line.strip} "
          end
        else
        #  flash.now[:notice] = "ERROR: line #{line_count}, missing \"(\": #{line.strip} "
          #            flash[:notice] = "ERROR: Syntax error on line #{line_count}: \"#{line.strip}\" - missing \"(\""
        end
      else
      #  flash.now[:notice] = "ERROR: line #{line_count}, missing \"->\": #{line.strip} "
        #            flash[:notice] = "ERROR: Syntax error on line #{line_count}: \"#{line.strip}\" - missing \"->\""
      end
    end
    nodes.uniq!
    nodes.each do |node|
      if not from_states.include?(node) or not to_states.include?(node)
        out_string += "#{node} [fillcolor = red, label = \"  #{node.gsub("STATE_","").gsub('_','  \n  ')}  \"]\n"
      end
      if node.include?('startup')
        out_string += "#{node} [fillcolor = black, label = \"X\"]\n"
      end  
    end
    out_string += "\n"
    out_string
  end
  
  def draw_svg_notice(notice)
    gv=IO.popen("C:/graphviz/bin/dot -q -Tsvg", "w+")
    case notice
    when :select_device
      gv.puts "digraph G{", " \"Select\"[style=filled,fillcolor=red,fontsize=30,fontcolor=white] \"Device!\"[style=filled,fillcolor=red,fontsize=30,fontcolor=white]",  "}"
    when :select_notice
      gv.puts "digraph G{", " \"Select\"[style=filled,fillcolor=red,fontsize=30,fontcolor=white] \"Module!\"[style=filled,fillcolor=red,fontsize=30,fontcolor=white]",  "}"
    end
    gv.close_write
    gv.read
    #     @gvsvg=gv.read
#     parse_svg=REXML::Document.new(@gvsvg)
#     @svg_width=parse_svg.root.attributes["width"].gsub(/pt$/,'').to_i
#     @svg_height=parse_svg.root.attributes["height"].gsub(/pt$/,'').to_i
  end
  
  def generate_code params
    require "digest/sha2"

    @state_data = params[:graph].to_s
    @all_sha2s = []
    def get_SHA2(state)
      sha2 = Digest::SHA2.new << state
      sha2 = sha2.to_s.upcase[0..7]
      if @all_sha2s.include?(sha2)
        #      puts"ERROR! Duplicate SHA2 flow hash detected when generating for state #{state}"
        #      exit 1
      end
      @all_sha2s << sha2
      sha2
    end

    #   uip_state_data = <<UIP_STATE_DATA
    # STATE_uip_init -> STATE_uip_idle (transition_1)
    # STATE_uip_idle -> STATE_uip_idle (transition_2)
    # STATE_uip_idle -> STATE_uip_process (transition_3)
    # STATE_uip_process -> STATE_uip_process (transition_4)
    # STATE_uip_process -> STATE_uip_idle  (transition_5)
    # UIP_STATE_DATA

    #   systick_state_data = <<SYSTICK_STATE_DATA
    # STATE_systick_init -> STATE_systick_idle (transition_1)
    # STATE_systick_idle -> STATE_systick_idle (transition_2)
    # STATE_systick_idle -> STATE_systick_process (transition_3)
    # STATE_systick_process -> STATE_systick_process (transition_4)
    # STATE_systick_process -> STATE_systick_idle  (transition_5)
    # SYSTICK_STATE_DATA

    #   usb_state_data = <<USB_STATE_DATA
    # STATE_usb_init -> STATE_usb_idle (transition_1)
    # STATE_usb_idle -> STATE_usb_idle (transition_2)
    # STATE_usb_idle -> STATE_usb_process (transition_3)
    # STATE_usb_process -> STATE_usb_process (transition_4)
    # STATE_usb_process -> STATE_usb_idle  (transition_5)
    #USB_STATE_DATA

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
    
    #  puts "params = #{params.inspect}"
    #  puts "selected device = #{params[:selected_device][:id].inspect}"
    #  puts "selected_module = #{params[:selected_module][:id].inspect}"
    #puts @state_data.inspect
    #   @state_data = [uip_state_data]
    #   @state_data += [usb_state_data]
    #  @state_data += [systick_state_data]
    
    @state_data = state_data

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
        from_state = 'STATE_' + params[:selected_module][:id].to_s.upcase + '_' + from_state
        line = line[line.index('->') + 2  .. -1].strip
        to_state = line[0..line.index('(') - 1 ].strip
        to_state = 'STATE_' + params[:selected_module][:id].to_s.upcase + '_' + to_state
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
     @out_state_routines_h,
     @out_function_hash_c,
     @out_function_hash_h
    ]

  end 
end



