require 'json'

module LozicTree
  class Expression
    class << self
      def from_json(json)
        if json.size == 1 and [And::KEY, Or::KEY, Not::KEY].include?(json.keys.first)
          key, value = json.first
          logical_expression(key, value)
        else
          HashEqual.new(json)
        end
      end

      def logical_expression(key, value)
        result = case(key)
                 when And::KEY
                   And.from_json(value)
                 when LozicTree::Or::KEY
                   LozicTree::Or.from_json(value)
                 when LozicTree::Not::KEY
                   LozicTree::Not.from_json(value)
                   #else
                   #  raise "Unknown expression type: #{key}"
                 end
        raise "Unknown expression type: #{key}" unless result
        result
      end 
    end

    def matches?(condition)
      raise "#{self} should implement matches?"
    end

    private
    def initialize; end
  end

  class BinaryExpression < Expression
    def self.parse(values)
      raise "Cannot create binary expression from: #{values}" unless values.is_a?(Array)
      raise "Must have 2 values in the array to create a binary expression from: #{values}" unless values.size == 2
      values.map { |v| Expression.from_json(v) }
    end

    def initialize(left, right)
      @left, @right = left, right
    end
  end

  class And < BinaryExpression
    KEY = 'AND'

    def self.from_json(value)
      left, right = BinaryExpression.parse(value)
      new(left, right)
    end

    def matches?(condition)
      @left.matches?(condition) && @right.matches?(condition)
    end
  end

  class Or < BinaryExpression
    KEY = 'OR'

    def self.from_json(value)
      left ,right = BinaryExpression.parse(value)
      new(left, right)
    end

    def matches?(condition)
      @left.matches?(condition) || @right.matches?(condition) 
    end
  end

  class Not < Expression
    KEY = 'NOT'

    def self.from_json(value)
      #raise "Cannot create not expression from: #{value}" unless value.is_a?(Hash)
      new(Expression.from_json(value))
      #super(value.first, value.last)
    end

    def initialize(expression)
      @expression = expression 
    end

    def matches?(condition)
      !@expression.matches?(condition) 
    end
  end

  class HashEqual < Expression
    def initialize(hash)
      @hash = hash
    end

    def matches?(condition)
      @hash.each_pair do | key, value|
      return false unless condition[key] == value 
      end
      true
    end
  end
end
