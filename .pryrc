if RUBY_VERSION >= '1.9.2'
  ['./', './lib'].each { |path| $LOAD_PATH.unshift path }
end
