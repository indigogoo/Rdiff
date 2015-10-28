# -*- ruby encoding: utf-8 -*-

require_relative 'rdiff/rdiff_default_template'
require 'optparse'
require 'ostruct'
require 'diff/lcs'
require 'diff/lcs/hunk'

class Rdiff
  attr_reader :diffs, :args, :template

  def initialize(args, template = RdiffDefaultTemplate )
    @args = args
    parse_options!
    @diffs = Diff::LCS.sdiff(*get_data_from_files)
    @template = template.new(@diffs)
  end

  def parse_options!
    @args.options do |o|
      o.banner = "Usage: #{File.basename($0)} [options] oldfile newfile"
      o.on_tail('--usage', 'Shows this text') do
        $error << o
        return 0
      end
      o.parse!
    end
    check_args_length!
  end

  def print
    return 0 if @template.diffs.empty?
    @template.print
    return 1
  end

  def check_args_length!
    unless @args.size == 2
      $stderr << @args.options
      exit 0
    end
  end


  def get_data_from_files
    file_one, file_two = ARGV
    data_seq_one = File.readlines(file_one).map { |e| e.chomp }
    data_seq_two = File.readlines(file_two).map { |e| e.chomp }
    [data_seq_one, data_seq_two]
  end
end

exit Rdiff.new(ARGV).print