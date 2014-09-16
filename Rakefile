require 'pathname'
require 'fileutils'

module Dotfiles
  module DSL
    def before(base_task, before_task)
      Rake::Task[base_task].enhance Array(before_task)
    end

    def after(base_task, after_task)
      Rake::Task[base_task].enhance do
        Rake::Task[after_task].invoke
      end
    end

    def home_path
      Pathname.new ENV['HOME']
    end

    def root_path
      Pathname.new File.expand_path('../', __FILE__)
    end

    def within(dir)
      old_dir = FileUtils.pwd
      FileUtils.cd dir
      yield
    ensure
      FileUtils.cd old_dir
    end

    def symlink(src, dest)
      FileUtils.symlink src, dest
    end

    def windows?
      Gem.win_platform?
    end

    def import!
      Dir['*/**/Rakefile'].each { |f| import f }
    end

    def self.extended(object)
      object.instance_eval do
        desc 'update'
        task :update

        task :default => :update
      end
    end
  end
end

extend Dotfiles::DSL
import!

namespace :git do
  desc 'pull repository'
  task :pull do
    sh 'git', 'pull', '--rebase'
  end

  namespace :submodule do
    desc 'update git submodule'
    task :update do
      sh 'git', 'submodule', 'update', '--init', '--recursive'
    end

    desc 'pull git submodules'
    task :pull do |task, args|
      args.with_defaults branch: 'master'
      sh 'git', 'submodule', 'foreach', "git checkout #{args[:branch]}; git pull origin #{args[:branch]}"
    end

    after 'git:pull', 'git:submodule:update'
    after 'git:submodule:update', 'git:submodule:pull'
  end

  after 'update', 'git:pull'
end

