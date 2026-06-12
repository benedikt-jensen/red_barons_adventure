global.timed_actions = [];

function TimedAction(_func, _argv, _delay) constructor {
	func = _func;
	argv = _argv;
	delay = _delay;
}

function exec_scheduled_actions() {
	// Iterate backwards so finished actions can be removed in place.
	for (var i = array_length(global.timed_actions)-1; i>=0; i--) {
		var _action = global.timed_actions[i];
		if _action.delay==0 {
			exec_with_args(_action.func, _action.argv);
			array_delete(global.timed_actions,i,1);
		} else {
			_action.delay -= 1;
		}
	}
}

function exec_delayed(_func, _argv, _delay) {
	array_push(global.timed_actions, new TimedAction(_func, _argv, _delay));
}

function exec_with_args(_func, _argv) {
	script_execute_ext(_func, _argv);
}
