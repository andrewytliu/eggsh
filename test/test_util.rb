require 'helper'

describe 'to_cmd' do
  it 'should convert array to command line with to_cmd' do
    %[ab cd ef].to_cmd.should.equal 'ab cd ef'
  end

  it 'should remain string with to_cmd' do
    'abc'.to_cmd.should.equal 'abc'
  end
end

describe 'to_color' do
  it 'should output color escape with red' do
    'abc'.to_color(:red).should.equal "\x1b[31mabc\x1b[m"
  end
end

