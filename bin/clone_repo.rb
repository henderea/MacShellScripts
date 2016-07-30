#!/usr/bin/env ruby

Signal.trap('SIGINT') {
  Process.waitall
  puts
  exit 1
}

require 'readline'

def ask_continue(question = 'Would you like to continue?')
  resp = Readline.readline("#{question} ([y]es/[n]o) ", true)
  exit 0 unless resp.downcase == 'yes' || resp.downcase == 'y'
end

def divider
  puts
  puts '=' * 100
  puts
end

def run_cmd(cmd)
  puts "> #{cmd}"
  system(cmd)
end

def interrupt_capture_loop(initial_command, continue_prompt, loop_command = nil)
  begin
    initial_command.call
  rescue Exception => e
    continue_prompt.call(e)
    loop do
      begin
        (loop_command || initial_command).call
        break
      rescue Exception => ex
        continue_prompt.call(ex)
      end
    end
  end
end

loop do
  repo = Readline.readline('What is the repo you would like to clone? ', true)

  folder = repo[%r{(?<=[/])[^/]+$}]

  resp = Readline.readline('Does this repo have branches and/or tags in it? ([y]es/[n]o) ', true)

  branches = resp.downcase == 'yes' || resp.downcase == 'y'

  if branches
    resp = Readline.readline('Does this repo use standard branch layout (trunk/branches/tags)? ([y]es/[n]o) ', true)
    stdlayout = resp.downcase == 'yes' || resp.downcase == 'y'
    unless stdlayout
      t = Readline.readline('What is the path to the trunk folder? (leave blank to use "trunk") ', true)
      t = 'trunk' unless t && t.strip.length > 0
      b = Readline.readline('What is the path to the branches folder? (leave blank to use "branches") ', true)
      b = 'branches' unless b && b.strip.length > 0
      ta = Readline.readline('What is the path to the tags folder? (leave blank to use "tags") ', true)
      ta = 'tags' unless ta && ta.strip.length > 0
    end
  else
    stdlayout = false
  end

  resp = Readline.readline('Start at a specific revision? ([y]es/[n]o) ', true)

  rev_str = ''

  if resp.downcase == 'yes' || resp.downcase == 'y'
    rev = Readline.readline('What svn revision should it start at? (enter or <= 0 to start at the beginning) ', true).chomp
    unless rev.nil? || rev.strip.empty? || rev.strip.to_i <= 0
      rev_str = " -r #{rev}:HEAD"
    end
  end

  divider

  interrupt_capture_loop(-> { run_cmd "git svn clone #{repo}#{stdlayout ? ' --stdlayout' : (branches ? " --trunk #{t} --branches #{b} --tags #{ta}" : '')}#{rev_str}" }, -> (_) { ask_continue }, -> { run_cmd "cd #{folder} && git svn fetch svn" })

  divider

  run_cmd "cd #{folder} && git gc"

  divider

  ask_continue 'Would you like to clone another repo?'

  divider
end