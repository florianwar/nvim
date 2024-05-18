local ascii = require('plugins.dev.ascii')
local eq = assert.are.same

describe('ascii.padding', function()
  it('should correctly center singleline strings', function()
    local width = 40
    local artwork = 'foooobar baz'

    local padded = ascii.center(artwork, width)

    eq(string.len(padded), width)
  end)

  it('should correctly center based on displaylength', function()
    local width = 56
    local artwork = '┻━┻︵ \\(°□°)/ ︵ ┻━┻'

    local padded = ascii.center(artwork, width)

    eq(vim.fn.strdisplaywidth(padded), width)
  end)
end)
