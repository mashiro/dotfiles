$:.unshift './', './lib' if RUBY_VERSION >= '1.9.2'

require 'irb/completion'
require 'irb/ext/save-history'
require 'rubygems'

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:USE_READLINE] = true
IRB.conf[:EVAL_HISTORY] = 1000
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_PATH] = File::expand_path("~/.irb_history")
