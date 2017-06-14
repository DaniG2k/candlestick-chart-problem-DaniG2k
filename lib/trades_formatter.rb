require 'csv'
require 'pry'

class TradesFormatter
  attr_accessor :input_csv, :window_size

  def initialize(input_csv, window_size)
    @input_csv = input_csv
    @window_size = window_size
  end

  def get_windows
    result = {}
    start_time = @input_csv[0][0].to_i
    end_time = @input_csv[-1][0].to_i

    start_and_end_windows = (start_time..end_time)
      .each_slice(@window_size)
      .map {|slice| [slice[0], slice[-1]] }

    start_and_end_windows.each do |window|
      result[window] = []
      while !@input_csv.empty?
        range = (window[0]..window[1])
        if range.include?(@input_csv[0][0].to_i)
          entry = @input_csv.shift
          current_time = entry[0].to_i
          result[window] << entry
        else
          break
        end
      end
    end
    result
  end

  # def get_window
  #   result = {}
  #   batch = 0
  #
  #   @input_csv.each do |entry|
  #     new_time = Time.at(entry.first.to_i)
  #
  #     if result.empty?
  #       result[batch] = [entry]
  #     else
  #       start_time = Time.at(result[batch].first.first.to_i)
  #       end_time = start_time + @window_size
  #
  #       if (start_time..end_time).include?(new_time)
  #         result[batch] << entry
  #       else
  #         batch += 1
  #         result[batch] = [entry]
  #       end
  #     end
  #   end
  #   result
  # end
  #
  # def output
  #   result = []
  #   get_window.each do |batch, entries|
  #     result << {
  #       'open'    => entries.first[1].to_f.round.to_s,
  #       'close'   => entries.last[1].to_f.round.to_s,
  #       'high'    => max_entry(entries),
  #       'low'     => min_entry(entries),
  #       'start'   => entries.first[0].to_i,
  #       'end'     => entries.last[0].to_i,
  #       'average' => avg_entries(entries)
  #       # 'weighted_average'  => ,
  #       # 'volume'  => ,
  #     }
  #   end
  #   result
  # end
  #
  # private
  #   def max_entry(entries)
  #     entries.max {|a, b| a[1] <=> b[1]}[1].to_f.round.to_s
  #   end
  #
  #   def min_entry(entries)
  #     entries.min {|a, b| a[1] <=> b[1]}[1].to_f.round.to_s
  #   end
  #
  #   def avg_entries(entries)
  #     sum_entries = entries.map {|e| e[1].to_i}.reduce(:+)
  #     (sum_entries / entries.count).to_f.round.to_s
  #   end
end
