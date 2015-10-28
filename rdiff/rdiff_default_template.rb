# -*- ruby encoding: utf-8 -*-

class RdiffDefaultTemplate
	attr_reader :diffs

	def initialize(diffs)
		@diffs = prettify_diffs(diffs)
	end

	def prettify_diffs(diffs)
		diffs.map do |diff|
			rebuild_diff(diff.to_a)
		end
	end

	def rebuild_diff(diff)
		kind = diff[0] 
		case kind
		when '!'
			process_changed_line_diff(diff)
		when '-'
			process_first_file_diff(diff)
		when '+'
			process_second_file_diff(diff)
		when '='
			process_not_changed_diff(diff)
		else
			diff
		end
	end

	def print
		@diffs.each_with_index { |diff, i| p (i + 1).to_s.ljust(5) + diff }
	end

	private

	def process_changed_line_diff(diff)
		'*'.ljust(5) + "#{diff[1][1]} | #{diff[2][1]}"
	end

	def process_first_file_diff(diff)
		'-'.ljust(5) + "#{diff[1][1]}"
	end

	def process_second_file_diff(diff)
		'+'.ljust(5) + "#{diff[2][1]}"
	end

	def process_not_changed_diff(diff)
		''.ljust(5) + "#{diff[1][1]}"
	end
end
