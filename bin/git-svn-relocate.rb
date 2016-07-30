#!/usr/bin/env ruby

Signal.trap('SIGINT') {
  Process.waitall
  puts
  exit 1
}

require 'readline'
require 'fileutils'

def puts_header(str)
  l = str.length
  puts "\n#{bold("#{'#' * (l + 4)}\n# #{str} #\n#{'#' * (l + 4)}")}\n\n"
end

def bold(str)
  "\e[1m#{str}\e[0m"
end

# Credit for this mdoule (other than a few modifications) goes to http://www.sanityinc.com/articles/relocating-git-svn-repositories/ and https://gist.github.com/purcell/591602
module CopyBranch
  module_function

  # There is a 'git' gem, but I didn't want to figure out how to call it to get the functionality I needed. The following
  # methods were first tested on the command line, and originally came from this blog post:
  #   http://www.sanityinc.com/articles/relocating-git-svn-repositories.

  # find git branches whose latest commit hasn't been checked into svn
  def local_branches(repo_path)
    result = []
    `(cd "#{repo_path}" && git branch | cut -c3-)`.split("\n").each do |branch|
      result << branch unless `(cd #{repo_path} && git log -1 --pretty=full #{branch})` =~ /git-svn-id:/
    end
    result
  end

  # return the git commit sha for the newest commit that *has* been checked into svn
  def newest_svn_commit_on_branch(repo_path, branch)
    `(cd "#{repo_path}" && git rev-list -n1 #{branch} --grep=git-svn-id:)`.strip
  end

  # return the svn revision number corresponding to a git commit sha
  def find_svn_rev_for_commit(repo_path, commit)
    `(cd "#{repo_path}" && git svn find-rev #{commit})`.strip
  end

  # return the git commit sha for the commit corresponding to an svn revision
  def find_commit_for_svn_rev(repo_path, svn_rev, base_branch)
    `(cd "#{repo_path}" && git rev-list #{base_branch} --grep="git-svn-id:.*@#{svn_rev}")`.strip
  end

  def branch_exists?(repo_path, branch)
    `(cd "#{repo_path}" && git branch -M #{branch} #{branch} &> /dev/null)`
    $? == 0
  end

  # create a branch on a git repo from a certain git commit and checkout that branch
  def create_branch_and_checkout(repo_path, commit, branch)
    `(cd "#{repo_path}" && git checkout -b #{branch} #{commit})`
  end

  # return a patch containing every commit in a branch on a repo, starting from a certain commit
  def create_patch(repo_path, commit, branch)
    `(cd "#{repo_path}" && git format-patch --stdout #{commit}..#{branch})`
  end

  # apply a patch to the current branch of a repo
  def apply_patch(repo_path, patch)
    `(cd "#{repo_path}" && echo #{patch} | git am)`
  end

  # create a patch from the src repo and apply it to the dest repo
  def copy_branch_commits(src_repo_path, src_branch, src_branch_point, dest_repo_path)
    `(cd "#{src_repo_path}" && git format-patch --stdout #{src_branch_point}..#{src_branch}) | (cd "#{dest_repo_path}" && git am)`
  end

  def copy_branch_itr(src_repo_path, src_branch, base_branch, dest_repo_path)
    src_branch_point = newest_svn_commit_on_branch(src_repo_path, src_branch)
    fail "Couldn't find an svn commit on branch '#{src_branch}' in repo '#{src_repo_path}'" if src_branch_point.empty?
    svn_revision = find_svn_rev_for_commit(src_repo_path, src_branch_point)
    fail "Couldn't extract the svn revision for commit '#{src_branch_point}' in repo '#{src_repo_path}'" if svn_revision.empty?
    dest_branch_point = find_commit_for_svn_rev(dest_repo_path, svn_revision, base_branch)
    fail "Couldn't find the git commit containing svn revision '#{svn_revision}' in repo '#{dest_repo_path}'" if dest_branch_point.empty?
    create_branch_and_checkout(dest_repo_path, dest_branch_point, src_branch)
    copy_branch_commits(src_repo_path, src_branch, src_branch_point, dest_repo_path)
  end

  def copy_branch(src, dest, base_branch, branch_name = nil)
    src_repo = File.expand_path(src)
    dest_repo = File.expand_path(dest)

    [src_repo, dest_repo].each do |path|
      unless File.exist?(path) && File.directory?(path)
        puts "directory #{path} doesn't exist or isn't a directory"
        exit 1
      end
    end

    if branch_name
      if branch_exists?(dest_repo, branch_name)
        puts "** Skipped branch [#{branch_name}] because it already exists"
      else
        copy_branch_itr(src_repo, branch_name, base_branch, dest_repo)
      end
    else
      local_branches(src_repo).each do |branch|
        if branch_exists?(dest_repo, branch)
          puts "** Skipped branch [#{branch}] because it already exists"
        else
          puts "Copying branch #{branch}"
          copy_branch_itr(src_repo, branch, base_branch, dest_repo)
          puts '  Copy successful'
        end
      end
    end
  end
end

# Must be called with one command-line arg.
# Example: git-svn-relocate.rb https://new.server
if ARGV.count < 1
  puts 'Please invoke this script with one command-line argument (new SVN URL).'
  exit 1
end

initial_branch = nil
branches_str = `git branch --list --no-color 2>&1`.chomp
branches = branches_str.split(/\n/).map { |b|
  rv = b.gsub(/^[*]?\s*(.+)\s*/, '\1')
  initial_branch = rv if b.start_with?('*')
  rv
}
branches -= [initial_branch]
branches << initial_branch

initial_branch_real = initial_branch

puts "Local branches: \n#{branches.join("\n")}\n\n"

puts_header 'Checking for un-pushed changes in local branches'

has_unpushed = []

branches.each { |b|
  `git checkout #{b} 2>&1`
  result = `git log --oneline @{u}..HEAD 2>&1`.chomp
  unless result.strip.empty?
    puts "Branch #{b} has un-pushed changes!"
    has_unpushed << b
  end
}

create_copy = false

if has_unpushed.empty?
  puts "No unpushed changes\n\n"
  ans = Readline.readline('Create repo copy? (y/n) ', true).chomp
  create_copy = ans.downcase == 'y' || ans.downcase == 'yes'
else
  if has_unpushed.include?(initial_branch)
    initial_branch = (branches - has_unpushed).first
    if initial_branch.nil?
      puts 'You have no branches without un-pushed changes! This script requires at least one branch with all changes pushed in order to work. Exiting.'
      exit 1
    end
    puts "Initial branch #{initial_branch_real} had unpushed changes.  Using #{initial_branch} instead."
    `git checkout #{initial_branch} 2>&1`
  end

  puts_header 'IMPORTANT NOTE!'

  puts <<EOS
If you have local commits that have not been pushed to the svn server, even if they are in a different branch, this script may not work properly #{bold('and may mess up your repository')}.
Please cancel and do the following:
1) manually back up the un-pushed changes
2) delete the branches with un-pushed changes
3) run this script again
4) manually restore the un-pushed changes and any deleted branches.

This script can attempt to perform these steps automatically.  It will create a copy of the repo that you can choose whether or not to delete at the end of the operation.

EOS
  ans = Readline.readline('Continue and attempt automatically? (y/n) ', true).chomp
  exit 1 unless ans.downcase == 'y' || ans.downcase == 'yes'
  create_copy = true
end

if create_copy
  puts_header 'Creating copy of repo'
  cur_dir = Dir.getwd
  dir_name = cur_dir[(cur_dir.rindex('/') + 1)..-1]
  new_dir = File.expand_path("../#{dir_name}.backup-#{Random.rand}")
  FileUtils.cp_r(cur_dir, new_dir)
end

old_url_init = `git config --get svn-remote.svn.url`.chomp
new_url_init = ARGV[0]

puts "old URL from git config: #{bold(old_url_init)}"
loop do
  puts "new URL provided: #{bold(new_url_init)}"
  ans = Readline.readline('continue with this URL? (y/n) ', true).chomp
  if ans.downcase == 'y' || ans.downcase == 'yes'
    break
  else
    nurl = Readline.readline('enter new URL (enter to cancel): ', true).chomp
    if nurl && !nurl.strip.empty?
      new_url_init = nurl.strip
    else
      break
    end
  end
end

unless has_unpushed.empty?
  puts_header 'Deleting branches with un-pushed changes from main repo'
  has_unpushed.each { |hu| `git branch -D #{hu} 2>&1` }
end

# Prepare URLs for regex search and replace.
old_url = old_url_init.gsub(/[.]/, '\\\.')
new_url = new_url_init.gsub(/[&]/, '\\\&')
old_url2 = old_url_init.gsub(%r{//(.+?[@])}, '//').gsub(/[.]/, '\\\.')
new_url2 = new_url_init.gsub(%r{//(.+?[@])}, '//').gsub(/[&]/, '\\\&')

filter = "sed \"s|git-svn-id: #{old_url2}|git-svn-id: #{new_url2}|g\""
puts_header 'beginning git filter-branch'
system("git filter-branch --msg-filter '#{filter}' -- --all")

puts_header 'beginning .git/config url change'
system("sed -i.backup -e 's|#{old_url}|#{new_url}|g' .git/config")

puts_header 'beginning removing .git/svn'
system('rm -rf .git/svn')

puts_header 'beginning git svn rebase'
system('git svn rebase')

unless has_unpushed.empty?
  puts_header 'Copying branches from copy back to main version'

  has_unpushed.each { |hu|
    loop do
      begin
        puts "preparing to copy branch #{bold(hu)}"
        base_branch = initial_branch
        loop do
          ans = Readline.readline("Base off of branch #{bold(base_branch)}? (y/n) ", true).chomp
          break if ans.downcase == 'y' || ans.downcase == 'yes'
          nbranch = Readline.readline('Please enter the branch to base off of (enter to use already selected one): ', true).chomp
          if nbranch && !nbranch.strip.empty?
            base_branch = nbranch.strip
          else
            break
          end
        end
        puts "beginning copying branch #{bold(hu)} based off of branch #{bold(base_branch)}"
        CopyBranch.copy_branch(new_dir, cur_dir, base_branch, hu)
        break
      rescue StandardError => e
        puts "copying branch #{bold(hu)} based off of branch #{bold(base_branch)} failed: #{e.message}"
        puts e.backtrace.join("\n")
      end
    end
  }
end

`git checkout #{initial_branch_real} 2>&1`

loop do
  begin
    puts_header 'Fetching latest contents from svn to finish rebuilding repo.'
    ans = Readline.readline('Start fetch at a specific revision? (y/n) ', true).chomp
    if ans.downcase == 'y' || ans.downcase == 'yes'
      rev = Readline.readline('What svn revision should it start at? (enter or <= 0 to start at the beginning) ', true).chomp
      unless rev.strip.empty? || rev.strip.to_i <= 0
        system("git svn fetch svn -r #{rev.strip}:HEAD")
        break
      end
    end
    system('git svn fetch svn')
    break
  rescue Exception
    ans = Readline.readline("\n\nDid fetch freeze and you want to try fetching again (n to exit)? (y/n) ", true).chomp
    exit 0 unless ans.downcase == 'y' || ans.downcase == 'yes'
  end
end

if new_dir
  puts "\n\nRepo copy is located at #{new_dir}"
  ans = Readline.readline('Delete repo copy? (y/n) ', true).chomp
  exit 0 unless ans.downcase == 'y' || ans.downcase == 'yes'
  FileUtils.rm_r(new_dir)
end