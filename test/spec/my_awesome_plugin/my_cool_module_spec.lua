local my_cool_module = require('bmessages.my_cool_module')

describe("greeting", function()
   it('works!', function()
      assert.combinators.match("Hello Gabo", my_cool_module.greeting("Gabo"))
   end)
end)

