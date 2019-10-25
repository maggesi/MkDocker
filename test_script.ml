let FOO_THM = ARITH_RULE `b = 0 ==> (a + b) - a = 0`;;
loads "update_database.ml";;
report "DB thm names loadaded";;
search[`y = 0 ==> (x + y) - x = 0`];;
assert (length it >= 1);;
report "HOL Light test completed!";;

