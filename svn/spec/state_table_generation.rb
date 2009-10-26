

require File.
  expand_path(File.
              join(File.
                   dirname(__FILE__),'..','state','build_state_machine'))

require File.
  expand_path(File.
              join(File.
                   dirname(__FILE__),'..','state','climb_to'))

describe "state_table_generation" do
  before do
  end

  it 'is a public method of BuildStateMachine' do
    BuildStateMachine.public_methods.include?(state_table_generation).should == true
  end
  
end


