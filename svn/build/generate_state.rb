
HERE = File.expand_path(File.join(File.dirname(__FILE__)))

@name = "main"

@c_source_path = File.expand_path(File.join(HERE,"..","pri","lib","states","#{@name}_state.c"))
@h_source_path = File.expand_path(File.join(HERE,"..","pri","lib","states","#{@name}_state.h"))
@c_validate_source_path = File.expand_path(File.join(HERE,"..","pri","lib","states","#{@name}_state_validation.c"))
@h_validate_source_path = File.expand_path(File.join(HERE,"..","pri","lib","states","#{@name}_state_validation.h"))
@spec_source_path = File.expand_path(File.join(HERE,"..","pri","build","states","spec","#{@name}_state_spec.rb"))
@spec_doc_output_path = File.expand_path(File.join(HERE,"..","pri","build","states","output","doc","#{@name}_state_spec.doc"))
@spec_html_output_path = File.expand_path(File.join(HERE,"..","pri","build","states","output","html","#{@name}_state_spec.html"))
@spec_svg_output_path = File.expand_path(File.join(HERE,"..","pri","build","states","output","svg","#{@name}_state_spec.svg"))
@spec_svg_output_path = File.expand_path(File.join(HERE,"..","pri","build","states","output","pdf","#{@name}_state_spec.pdf"))
@spec_yaml_data_path = File.expand_path(File.join(HERE,"..","pri","build","states","data","#{@name}_state_data.yml"))

puts @c_source_path
puts @h_source_path
puts @c_validate_source_path
puts @h_validate_source_path
puts @spec_source_path
puts @spec_doc_output_path
puts @spec_html_output_path
puts @spec_svg_output_path
puts @spec_svg_output_path
puts @spec_yaml_data_path
