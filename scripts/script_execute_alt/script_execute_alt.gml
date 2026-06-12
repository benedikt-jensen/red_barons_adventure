///@description Legacy alias kept for the dialogue system; prefer
/// script_execute_ext (or exec_with_args) in new code.
///@arg ind
///@arg [arg1,arg2,...]
function script_execute_alt(_func, _argv) {
	script_execute_ext(_func, _argv);
}
