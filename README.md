A simple gem for expressing logical operators (AND, OR, NOT) as ruby hash
Usage:
```
irb(main):016:0> require 'lozic_tree'
=> true
irb(main):017:0> condition = { 'a' => 5, 'b' => 10, 'c' => 15 }
=> {"a"=>5, "b"=>10, "c"=>15}
irb(main):018:0> expression = LozicTree::Expression.from_json(JSON.parse('{"a": 5}'))
=> #<LozicTree::HashEqual:0x007fbf823b1c78 @hash={"a"=>5}>
irb(main):019:0> expression.matches? condition
=> true

irb(main):020:0> expression = LozicTree::Expression.from_json(JSON.parse('{"a": 5, "b": 10}'))
=> #<LozicTree::HashEqual:0x007fbf85020c28 @hash={"a"=>5, "b"=>10}>
irb(main):021:0> expression.matches? condition
=> true
irb(main):022:0> expression = LozicTree::Expression.from_json(JSON.parse('{"a": 5, "b": 20}'))
=> #<LozicTree::HashEqual:0x007fbf85073338 @hash={"a"=>5, "b"=>20}>
irb(main):023:0> expression.matches? condition
=> false

rb(main):024:0> expression = LozicTree::Expression.from_json(JSON.parse('{"NOT":{"a": 5}}'))
=> #<LozicTree::Not:0x007fbf84849798 @expression=#<LozicTree::HashEqual:0x007fbf848497c0 @hash={"a"=>5}>>
irb(main):025:0> expression.matches? condition
=> false
irb(main):026:0> expression = LozicTree::Expression.from_json(JSON.parse('{"NOT":{"a": 10}}'))
=> #<LozicTree::Not:0x007fbf8484a9b8 @expression=#<LozicTree::HashEqual:0x007fbf8484a9e0 @hash={"a"=>10}>>
irb(main):027:0> expression.matches? condition
=> true


irb(main):028:0> expression = LozicTree::Expression.from_json(JSON.parse('{"OR":[{"a": 10}, {"b": 10}]}'))
=> #<LozicTree::Or:0x007fbf839ceb00 @left=#<LozicTree::HashEqual:0x007fbf839ceba0 @hash={"a"=>10}>, @right=#<LozicTree::HashEqual:0x007fbf839ceb28 @hash={"b"=>10}>>
irb(main):029:0> expression.matches? condition
=> true
irb(main):030:0> expression = LozicTree::Expression.from_json(JSON.parse('{"OR":[{"a": 10}, {"b": 20}]}'))
=> #<LozicTree::Or:0x007fbf82385358 @left=#<LozicTree::HashEqual:0x007fbf823853f8 @hash={"a"=>10}>, @right=#<LozicTree::HashEqual:0x007fbf82385380 @hash={"b"=>20}>>
irb(main):031:0> expression.matches? condition
=> false

```
