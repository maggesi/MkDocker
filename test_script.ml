let FOO_THM = ARITH_RULE `b = 0 ==> (a + b) - a = 0`;;
loads "update_database.ml";;
search[`x = 0 ==> (x + y) - x = 0`];;
assert (length it >= 1);;
report "Done!";;
