
class GraphvizController < ApplicationController
  def index
  end
  
  def update_dotsvg
#    flash[:notice] = "ERROR: Syntax error"
#     flash[:notice] = "ERROR: Syntax error on line #{line_count}: \"#{line.gsub("\n",'').strip}\""
#      redirect_to :action => 'index' 
    temp = generate_dot( params[:graph].to_s )
    gv=IO.popen("C:/graphviz/bin/dot -q -Tsvg", "w+")
    gv.puts "digraph G{", temp , "}"
    gv.close_write
    @gvsvg=gv.read
    parse_svg=REXML::Document.new(@gvsvg)
    @svg_width=parse_svg.root.attributes["width"].gsub(/pt$/,'').to_i
    @svg_height=parse_svg.root.attributes["height"].gsub(/pt$/,'').to_i

    temp = generate_code(params[:graph].to_s )
    @state_data = temp[0]
  end
  
  def generate_dot text
    nodes = []
    from_states = []
    to_states = []
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
            from_states << from_state
            line = line[line.index('->') + 2  .. -1].strip
            to_state = line[0..line.index('(') - 1 ].strip
            to_states << to_state
            transition = line[line.index('(') + 1 .. line.index(')') - 1].strip
            if not nodes.include? from_state
              nodes << from_state
              out_string += "#{from_state} [label = \"  #{from_state.gsub('_','  \n  ')}  \"]\n"
            end
            if not nodes.include? to_state
              nodes << to_state
              out_string += "#{to_state} [label = \"  #{to_state.gsub('_','  \n  ')}  \"]\n"
            end
            out_string += "#{from_state} -> #{to_state}"
            out_string += " [#{from_state == to_state ? 'dir = back, ' : ''}label = \"  #{transition.gsub('_','  \n  ')}!  \"]\n"
            next
          else
            flash[:notice] = "ERROR: line #{line_count}, missing \")\": #{line.strip} "
          end
        else
            flash[:notice] = "ERROR: line #{line_count}, missing \"(\": #{line.strip} "
#            flash[:notice] = "ERROR: Syntax error on line #{line_count}: \"#{line.strip}\" - missing \"(\""
        end
      else
            flash[:notice] = "ERROR: line #{line_count}, missing \"->\": #{line.strip} "
#            flash[:notice] = "ERROR: Syntax error on line #{line_count}: \"#{line.strip}\" - missing \"->\""
      end
#          flash[:notice] = "ERROR: Syntax error"
#     flash[:notice] = "ERROR: Syntax error on line #{line_count}: \"#{line.gsub("\n",'').strip}\""
#      redirect_to :action => 'index' 
    end
    nodes.uniq!
    nodes.each do |node|
      if not from_states.include?(node) or not to_states.include?(node)
        out_string += "#{node} [fillcolor = red, label = \"  #{node.gsub('_','  \n  ')}  \"]\n"
      end
      if node == 'init_state' or node == 'start_state'
        out_string += "#{node} [fillcolor = cadetblue, label = \"  #{node.gsub('_','  \n  ')}  \"]\n"
      end  
    end
    out_string += "\n"
    out_string
  end
end

def generate_code state_data
  require "digest/sha2"
  
  @all_sha2s = []
  def get_SHA2(state)
    sha2 = Digest::SHA2.new << state
    sha2 = sha2.to_s.upcase[0..7]
    #  sha2 = "duplicate" # test for duplicacy
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


  #puts @state_data.inspect
#   @state_data = [uip_state_data]
#   @state_data += [usb_state_data]
#  @state_data += [systick_state_data]
  
  @state_data = state_data
  @out_state_table_c = state_table_c_begin
  @out_state_table_h = state_table_h_begin
  @out_state_routines_c = state_routines_c_begin
  @out_state_routines_h = state_routines_h_begin

  @line_count = 0
  @all_states = []
  @from_states = []
  @to_states = []
  @state_data.each do |fsm|
    @fsm_states= []
    fsm.each_line do |line|
      @line_count += 1
      if line.include? '->'
        from_state = line[0..line.index('->') -2].strip
        line = line[line.index('->') + 2  .. -1].strip
        to_state = line[0..line.index('(') - 1 ].strip
        @fsm_states << from_state
        @fsm_states << to_state
        @fsm_states.uniq!
        
        @all_states << from_state
        @all_states << to_state
        @all_states.uniq!
        @from_states[@line_count] = from_state
        @to_states[@line_count] = to_state
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
      @out_state_table_h += "    #{state.upcase} = #{get_SHA2(state)},\n"
    end
    @out_state_table_h += "\n"
    @out_state_table_c +=   "\n"
    @out_state_routines_h += "\n"
  end
  @out_state_table_c += state_table_c_end   
  @out_state_routines_h += state_routines_h_end   
  @out_state_table_h += "    STATE_NUM_OF_STATES = #{@all_states.size}\n"
  @out_state_table_h += state_table_h_end
  [
   @out_state_table_c,
   @out_state_table_h,
   @out_state_routines_h,
   @out_state_routines_h
  ]
end
