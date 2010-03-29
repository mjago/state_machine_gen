
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
