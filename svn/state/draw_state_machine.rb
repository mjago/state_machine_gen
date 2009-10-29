
=begin rdoc
= generate tertiary_state_machine
=end

FROM_STATE = 0
TRANSITION = 1
TO_STATE = 2

require File.expand_path(File.join(File.dirname(__FILE__),'graph_lib','graph_lib'))

class String
  def titlecase
    non_capitalized = %w{of etc and by the for on is at to but nor or a via}
    gsub(/\b[a-z]+/){ |w| non_capitalized.include?(w) ? w : w.capitalize  }.sub(/^[a-z]/){|l| l.upcase }.sub(/\b[a-z][^\s]*?$/){|l| l.capitalize }
  end
end

def draw_state_machine(state_machine_name)

  @state_data_path = File.basename(state_machine_name).gsub('state_machine','state_data.yml')
  @state_data_path = File.expand_path(File.join(File.dirname(__FILE__),'..','state','stateData',@state_data_path))
  @state_machine_name = state_machine_name
                                     
  gvr = GraphvizR.new @state_machine_name
  
   gvr.graph[:label => "\n\n#{@state_machine_name.gsub('_',' ').to_s.titlecase}",
             :bgcolor => :white, 
             :rankdir => "UD"
            ]
  gvr.graph[:label => "This is a test label",
            :bgcolor => :white, 
            :rankdir => "UD"
           ]
  gvr.edge [
#	:color=>:midnightblue, 
            :color=>:green, 
            :fontname => 'verdana',
            :fontsize => '16',
            :fontcolor => :darkgreen,
            :url => 'http://google.com'
           ]
  gvr.node [:color=>:black, 
            :fontcolor => :white,
            :fontname => 'verdana',
            :fontsize => '16',
            :style=>:filled,
            :fillcolor=>:red,
            :shape=>:circle,#:box, 
            :url => 'http://google.com'
           ]
  
  data = YAML::load(File.
                    read(File.
                         expand_path(File.
                                     join(File.
                                          dirname(__FILE__),'stateData',"#{state_machine_name}.yml"))))
  @node_colour = 'red'
	match_found = false
  data.each do |st|
		data.each do |d|
			if d[FROM_STATE] == st[TO_STATE]
				match_found = true
				break
			end
		end
		if match_found == true 
			puts match_found
			@node_colour = :cadetblue
			@text_colour = :black
			else
				puts match_found
			@node_colour = :red
			@text_colour = :white
		end
		
    gvr[st[FROM_STATE].to_s.to_sym] [:label => st[FROM_STATE].to_s.gsub("_","\n"),
		:color => @node_colour, :fontcolor => @text_colour, :fillcolor => @node_colour]
    (gvr[st[FROM_STATE].to_s.to_sym] >> gvr[st[TO_STATE].to_s.to_sym])[:label => st[TRANSITION].to_s.gsub("_","\n")]
  end		
  generate_graph(gvr, File.
                 expand_path(File.
                             join(File.
                                  dirname(__FILE__), '..','state','output',"temp_#{@state_machine_name}")),'svg')
  generate_graph(gvr, File.
                 expand_path(File.
                             join(File.
                                  dirname(__FILE__), '..','state','output',@state_machine_name)) ,'pdf')

  @command  = "C:\\libxslt\\bin\\xsltproc "
  @command += File.expand_path(File.join(File.dirname(__FILE__),'..','state','state_machine_format.xsl'))
  @command += ' '
  @command += File.expand_path(File.join(File.dirname(__FILE__),'..','state','output', "temp_#{@state_machine_name}.svg "))
  @command += ' > '
  @command += File.expand_path(File.join(File.dirname(__FILE__),'..','state','output', "#{@state_machine_name}.svg"))
  system @command
end	

if $0 ==__FILE__
  draw_state_machine('test_state_data') 
#  display_graph(File.expand_path(File.join(File.dirname(__FILE__), 'output','test_state_data.pdf'))) 
else
  ARGV.each do |sn|
    puts "drawing #{sn}"
    draw_state_machine(sn)
  end
end	
