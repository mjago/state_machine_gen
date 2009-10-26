
require File.
  expand_path(File.
              join(File.
                   dirname(__FILE__),'..','state','build_state_machine'))

require File.
  expand_path(File.
              join(File.
                   dirname(__FILE__),'..','state','state_table_generation'))

describe 'STATE_TRANSITION' do it do
  STATE_TRANSITION.should == 1
end end


describe BuildStateMachine do 
  before(:each) do
    @bsm = BuildStateMachine.new
  end
  after(:each) do
    @bsm = nil
  end
  
  
  it 'state_table_generation should be a public method of BuildStateMachine class' do
    @bsm = BuildStateMachine.new
    @bsm.public_methods.include?('state_table_generation').should == true
  end

  describe "is_node_format?" do

    it 'is a public method of BuildStateMachine' do
      @bsm.methods.include?('is_node_format?').should == true
    end
    
    it 'is passed a node containing [STATE_FROM, STATE_TRANSITION, STATE_TO]' do
      @bsm.is_node_format?([:from_state,:transition!,:to_state]).should == true
    end

    it 'returns false if array doesnt contain three symbols ie a string' do 
      @bsm.state_table_generation([:from_state,:transition!,"to_state"]).should == false
      @bsm.state_table_generation([:from_state,"transition!",:to_state]).should == false
    end

    it 'returns false if transition doesnt end in !' do
      @bsm.state_table_generation([:from,:transition,:to]).should == false
      end
  end
  
  describe "state_table_generation" do

    it 'is a public method of BuildStateMachine' do
      @bsm.public_methods
      @bsm.methods.include?('state_table_generation').should == true
    end
    
    it 'is passed a node containing [STATE_FROM, STATE_TRANSITION, STATE_TO]' do
      @bsm.state_table_generation([:from_state,:transition!,:to_state]).should == true
    end

    it 'returns false if array doesnt contain three symbols ie a string' do 
      @bsm.state_table_generation([:from_state,:transition!,"to_state"]).should == false
      @bsm.state_table_generation([:from_state,"transition!",:to_state]).should == false
    end

    it 'returns false if not passed an array' do
      @bsm.state_table_generation(:some_rubbish).should == false
    end  
  end

  describe "does_node_exist?" do
    it 'is a public method of BuildStateMachine' do
      @bsm.public_methods
      @bsm.methods.include?('does_node_exist?').should == true
    end

    it 'searches the state_table to see if node already exists' do
      pending
      @bsm.does_node_exist?([:init_state,:critical_initialisation_error!,:system_failure_state]).should == true
    end
  end    
end

