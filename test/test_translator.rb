require 'helper'

describe 'translator' do
  before do
    @translator = Eggsh::Translator.new
  end

  it 'should translate empty string' do
    @translator.translate('').should.equal ''
  end

  it 'should translate ruby with bracket' do
    @translator.translate('{ 123 }').should.equal '123'
  end

  it 'should not have problem with nested bracket' do
    @translator.translate('{(1..3).to_a.join}').should.equal '123'
    @translator.translate('{(0..2).to_a.map{|i| i + 1}.join}').should.equal '123'
  end

  it 'should not evaluate expressions not in bracket' do
    @translator.translate('(1..3).to_a.join').should.equal '(1..3).to_a.join'
  end

  it 'should work with two sets of brackets' do
    @translator.translate('{(0..2).to_a.map{|i| i + 1}.map{|i| i + 1}.join}').should.equal '234'
  end

  it 'should no return with {>}' do
    @translator.translate('{> 123 }').should.equal ''
  end

  it 'should execute within {>}' do
    $TEST = nil
    @translator.translate('{> $TEST = "abc"}').should.equal ''
    $TEST.should.equal 'abc'
  end

  it 'should raise error with unbalanced parenthesis' do
    should.raise(RuntimeError) { @translator.translate('{') }
    should.raise(RuntimeError) { @translator.translate('}') }
    should.raise(RuntimeError) { @translator.translate('{}}') }
  end
end

