require 'pathname'
require 'fileutils'
require 'logger'

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
      FileUtils.cd dir.to_s
      yield
    ensure
      FileUtils.cd old_dir
    end

    def symlink(src, dest)
      FileUtils.symlink src, dest, force: ENV['FORCE']
      puts "symlink #{src} -> #{dest}"
    rescue
      false
    end

    def symlink_dotfiles(from, to = home_path)
      within from do
        dotfiles = Dir['.*'] - %w(. ..)
        dotfiles.each do |filename|
          symlink File.expand_path(filename), to
        end
      end
    end

    def silent
      verbose false do
        yield
      end
    end

    def has?(command)
      command = command.to_s

      silent do
        if windows?
          sh 'where', command
        else
          sh 'which', command
        end
      end
    rescue
      false
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
verbose true

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

