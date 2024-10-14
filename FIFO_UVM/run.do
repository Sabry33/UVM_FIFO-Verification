vlib work
vlog -f sourcefiles.txt +cover
vsim -voptargs=+acc work.TOP -cover -classdebug -uvmcontrol=all
add wave /TOP/f_if/*
coverage save TOP.ucdb -onexit 
run -all
