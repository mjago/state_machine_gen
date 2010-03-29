
text =  "init_state -> init_state (starting_up)    \n"
text += "init_state - idle_state initialised    \n"
text += "init_state -> idle_state (initialised)    \n"
text += "idle_state -> idle_state (do_nothing)    \n"
text += "idle_state -> processing_state (process)    \n"
text += "processing_state -> processing_state (processing)    \n"
text += "processing_state -> idle_state (finished_processing)    \n"

out_string = "edge[color = green, fontcolor = darkgreen, fontname = \"verdana\", fontsize = \"16\", URL = \"http://google.com\"];\n"
out_string += "node[color = black, fillcolor = cadetblue, fontcolor = white, fontname = \"verdana\", fontsize = \"16\", shape = circle, style = filled, URL = \"http://google.com\"];\n"

@line_count = 0
text.each_line do |line, i|
  nodes = []
  @line_count += 1
  puts @line_count
  if line.include? '->'
    if line.include? '('
      if line.include? ')'
        from_state = line[0..line.index('->') -2].strip
        puts "from_state = #{from_state}"
        line = line[line.index('->') + 2  .. -1].strip
        to_state = line[0..line.index('(') - 1 ].strip
        puts "to_state = #{to_state}"
        puts "nodes = #{nodes.inspect}"
        transition = line[line.index('(') + 1 .. line.index(')') - 1].strip
        puts "transition = #{transition}\n\n"
        if not nodes.include? from_state
          nodes << from_state
          out_string += "#{from_state} [label = \"  #{from_state.gsub('_','  \n  ')}  \"]\n"
        end
        if not nodes.include? to_state
          nodes << to_state
          out_string += "#{to_state} [label = \"  #{to_state.gsub('_','  \n  ')}  \"]\n"
        end
        
        nodes.uniq!
        out_string += "#{from_state} -> #{to_state} [#{from_state == to_state ? 'dir = back, ' : ''}label = \"  #{transition.gsub('_','  \n  ')}  \"]\n"
        next
      end
    end
  end
  puts "ERROR: Syntax error on line #{@line_count}: \"#{line.gsub("\n",'').strip}\""
  exit 1
end

puts "\n",out_string

