local bmodule = require('bmessages.bmodule')

describe("greeting", function()
   it('works!', function()
      assert.combinators.match("Hello Gabo", bmodule.greeting("Gabo"))
   end)
end)

