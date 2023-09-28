// Ref: false

#import "../src/types.typ": *

#assert.eq(types-to-string(array), "array")
#assert.eq(types-to-string(bool), "boolean")
#assert.eq(types-to-string(content), "content")
#assert.eq(types-to-string(dictionary), "dictionary")
#assert.eq(types-to-string(float), "float")
#assert.eq(types-to-string(function), "function")
#assert.eq(types-to-string(int), "integer")
#assert.eq(types-to-string(str), "string")
#assert.eq(types-to-string(type), "type")
#assert.eq(types-to-string(None), "none")
#assert.eq(types-to-string(None, int), "none or integer")
#assert.eq(types-to-string(int, None), "integer or none")
#assert.eq(types-to-string(None, int, bool), "none, integer or boolean")

#assert-type(0, "", int)
#assert-type(0.0, "", float)
#assert(not check-type(0, float))
#assert-type(0, "", int, float)
#assert-type(none, "", None, int, str)
