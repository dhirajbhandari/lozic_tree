require 'spec_helper'
require 'lozic_tree/expression'

describe LozicTree::Expression do
  describe ".from_json" do
    let(:json_hash) { JSON.parse(json) }
    subject { LozicTree::Expression.from_json(json_hash) }

    context 'for expression with simple hash equals' do
      let(:json) do
        <<-EOS
        { "a": 1, "b":10 }
        EOS
      end

      it 'should build HashEqual expression' do
        subject.should be_a(LozicTree::HashEqual)
      end

      context 'when expression has all the values in the hash' do
        let(:condition) { {'a' => 1, 'b' => 10, 'c' => 20} }
        it 'should match' do
          subject.matches?(condition).should be_true
        end
      end

      context 'when expression does not have all the values in the hash' do
        let(:condition) { {'a' => 1, 'c' => 20 } }
        it 'should return false' do 
          subject.matches?(condition).should be_false
        end
      end
    end
    
    context 'for Expression with AND' do
      let(:json) do
        <<-EOS
        {"AND": [{ "a": 1}, {"b":10 }]}
        EOS
      end

      it 'should build And expression' do
        subject.should be_a(LozicTree::And)
      end

      context 'when condition has all the values in the hash' do
        let(:condition) { {'a' => 1, 'b' => 10, 'c' => 20} }
        it 'should match' do
          subject.matches?(condition).should be_true
        end
      end

      context 'when condition does not have all the values in the hash' do
        let(:condition) { {'a' => 1, 'c' => 20 } }
        it 'should return false' do 
          subject.matches?(condition).should be_false
        end
      end
    end
    
    context 'for Expression with OR' do
      let(:json) do
        <<-EOS
        {"OR": [{ "a": 1}, {"b":10 }]}
        EOS
      end

      it 'should build Or expression' do
        subject.should be_a(LozicTree::Or)
      end

      context 'when condition has first values in the hash' do
        let(:condition) { {'a' => 1, 'b' => 30, 'c' => 200} }
        it 'should match' do
          subject.matches?(condition).should be_true
        end
      end

      context 'when condition has last value in the hash' do
        let(:condition) { {'a' => 10, 'b' => 10, 'c' => 200} }
        it 'should match' do
          subject.matches?(condition).should be_true
        end
      end

      context 'when condition does not have any of the values in the hash' do
        let(:condition) { {'a' => 5, 'c' => 1 } }
        it 'should return false' do 
          subject.matches?(condition).should be_false
        end
      end
    end
    
    context 'for Expression with NOT' do
      let(:json) do
        <<-EOS
        { "NOT": { "a": 1}}
        EOS
      end

      it 'should build And expression' do
        subject.should be_a(LozicTree::Not)
      end

      context 'when the inner expression does not match' do
        let(:condition) { {'a' => 0, 'b' => 10, 'c' => 20} }
        it 'should match' do
          subject.matches?(condition).should be_true
        end
      end

      context 'when the inner expression matches' do
        let(:condition) { {'a' => 1, 'c' => 20 } }
        it 'should not match' do 
          subject.matches?(condition).should be_false
        end
      end
    end

    context 'for expression with OR, NOT and AND' do
      let(:json) do
        <<-EOS
        {"OR": [{"NOT": { "a": 1}}, {"b": 0}]}
        EOS
      end

      it 'should match if a != 1' do
        condition = {'a' => 0, 'b' => 10, 'c' => 20}
        subject.matches?(condition).should be_true
      end

      it 'should match if b == 0' do
        subject.matches?({'b' => 0, 'a' => 1}).should be_true
      end

    end
  end

  def evaluate_hash_expression
    json = '{"a": 5, "b": 1}'
    expression = Expression.from_json(JSON.parse(json))
    puts "expression: #{expression.inspect}"
    condition = { 'a' => 5, 'b' => 1, 'c' => 10 }
    puts expression.matches?(condition) # => true
    Expression.from_json(JSON.parse('{"NOT": { "a": 1}}'))).matches(condition))
  end

end   
