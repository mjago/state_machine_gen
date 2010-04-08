
class StatesController < ApplicationController
  
  DATA_DIR = File.join(File.dirname(__FILE__),'..','..', "graph_data")
  
  def initialize
    @state = State.new
    @state.graph = "new test"
    @state.check_data_loaded
    @devices = ["Select Device","Controller","Safety","GUI"]
    @selected_device = @devices[0]
    @current_device = @selected_device
    @modules = ["Select Module","uip","usb"]
    @selected_module = @modules[0]
    @graph_types = ["State       ","Flow        "]
    @selected_graph = @graph_types[0]
    @current_graph = @selected_graph
  end

#   def show
#     @state = State.find(params[:id])
#   end
  
  def index
    File.open("uip.state","r") do |f|
    end
    @code = "hello world"
  end
  
  def state_data
    @state_data = "this is a test"
  end

  def update_dotsvg
    if not $selected_device == params[:selected_device][:id]
      if not params[:selected_device][:id] == "Select Device"
        $selected_device = params[:selected_device][:id]
        flash.now[:notice] = "NOTICE: device changed to #{$selected_device}"
      else
        @gvsvg = State.new.draw_svg_notice(:select_device)
        parse_svg=REXML::Document.new(@gvsvg)
        @svg_width=parse_svg.root.attributes["width"].gsub(/pt$/,'').to_i
        @svg_height=parse_svg.root.attributes["height"].gsub(/pt$/,'').to_i
        return
      end
    end
    
    if not $selected_module == params[:selected_module][:id]
      if not params[:selected_module][:id] == "Select Module"
        $selected_module = params[:selected_module][:id]
        flash.now[:notice] = "NOTICE: module changed to #{$selected_module}"
      else
        @gvsvg = State.new.draw_svg_notice(:select_module)
        parse_svg=REXML::Document.new(@gvsvg)
        @svg_width=parse_svg.root.attributes["width"].gsub(/pt$/,'').to_i
        @svg_height=parse_svg.root.attributes["height"].gsub(/pt$/,'').to_i
        return
      end
    end
    
    File.open(File.join(DATA_DIR,"uip.state"),"w") do |f|
      f.write params[:graph].to_s
    end
    
    temp = State.new.generate_dot( params )
    gv=IO.popen("C:/graphviz/bin/dot -q -Tsvg", "w+")
    gv.puts "digraph G{", temp , "}"
    gv.close_write
    @gvsvg=gv.read
    parse_svg=REXML::Document.new(@gvsvg)
    @svg_width=parse_svg.root.attributes["width"].gsub(/pt$/,'').to_i
    @svg_height=parse_svg.root.attributes["height"].gsub(/pt$/,'').to_i
    
    if params[:display_source]
      temp = generate_code( params )
      @state_table_c = temp[0]
      @state_table_h = temp[1]
      @state_routines_c = temp[2]
      @state_routines_h = temp[3]
      @function_hash_c = temp[4]
      @function_hash_h = temp[5]
    end
  end
  

  



























































  
  #   @out_state_table_c = state_table_c_begin
  #   @out_state_table_h = state_table_h_begin
  #   @out_state_routines_c = state_routines_c_begin
  #   @out_state_routines_h = state_routines_h_begin

  #   @line_count = 0
  #   @all_states = []
  #   @fsm_states= []
  #   @from_states = []
  #   @to_states = []
  #   @state_data.each do |line|
  #     @line_count += 1
  #     if line.include? '->'
  #       from_state = line[0..line.index('->') -2].strip
  #       from_state = 'STATE_' + from_state
  #       line = line[line.index('->') + 2  .. -1].strip
  #       to_state = line[0..line.index('(') - 1 ].strip
  #       to_state = 'STATE_' + to_state
  #       @fsm_states << from_state
  #       @fsm_states << to_state
  #       @fsm_states.uniq!
  
  #       @all_states << from_state
  #       @all_states << to_state
  #       @all_states.uniq!
  #       @from_states[@line_count] = from_state
  #       @to_states[@line_count] = to_state
  #     end
  #   end
  #   @fsm_states.each do |state|
  #     @out_state_routines_c += "\nstate_t #{state}(void)\n"
  #     @out_state_routines_c += "{\n    FLOW_check(#{state.upcase});\n\n"
  #     @out_state_routines_c += "    \\* code goes here *\\\n\n"
  #     @out_state_routines_c += "    return(#{state.upcase});\n"
  #     @out_state_routines_c += "}\n"
  #     @out_state_routines_h += "state_t #{state}(void);\n"
  #     @out_state_table_c += "        #{state},\n"
  #     @out_state_table_h += "    #{state.upcase} = #{get_SHA2(state)},\n"
  #   end
  #   @out_state_table_h += "\n"
  #   @out_state_table_c +=   "\n"
  #   @out_state_routines_h += "\n"
  #   @out_state_table_c += state_table_c_end   
  #   @out_state_routines_h += state_routines_h_end   
  #   @out_state_table_h += "    STATE_NUM_OF_STATES = #{@all_states.size}\n"
  #   @out_state_table_h += state_table_h_end
  #   [
  #    @out_state_table_c,
  #    @out_state_table_h,
  #    @out_state_routines_c,
  #    @out_state_routines_h
  #   ]
  #end
end
