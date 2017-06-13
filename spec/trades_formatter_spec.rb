require 'spec_helper'
require 'csv'

RSpec.describe TradesFormatter do
  context 'initialization' do
    it 'takes a csv file and input window' do
      input_csv = CSV.read('./spec/tester.csv')
      window = 30
      tf = TradesFormatter.new(input_csv, window)

      expect(tf.input_csv). to eq(input_csv)
      expect(tf.window_size).to eq(window)
    end

    it '#get_window returns data from a given window' do
      input_csv = CSV.read('./spec/tester.csv')
      # Within a day of each other
      window = 86400

      result = {
        0 => [
          ["1378189897", "160000.000000000000", "0.100000000000"],
          ["1378224414", "150000.000000000000", "0.200000000000"],
          ["1378254765", "180000.000000000000", "2.940000000000"],
          ["1378271222", "180000.000000000000", "0.500000000000"]],
        1 => [
          ["1378343798", "150000.000000000000", "0.100000000000"],
          ["1378367663", "150000.000000000000", "0.537000000000"],
          ["1378380529", "150000.000000000000", "0.463000000000"],
          ["1378381752", "160000.000000000000", "0.300000000000"]],
        2 => [
          ["1378441918", "145000.000000000000", "0.200000000000"],
          ["1378514669", "145000.000000000000", "0.100000000000"],
          ["1378514709", "140000.000000000000", "0.100000000000"]],
        3 => [
          ["1378552766", "140000.000000000000", "0.200000000000"],
          ["1378613808", "141000.000000000000", "0.400000000000"],
          ["1378627740", "160000.000000000000", "0.200000000000"]],
        4 => [
          ["1378647310", "146000.000000000000", "0.200000000000"]]
      }

      tf = TradesFormatter.new(input_csv, window)

      expect(tf.get_window).to eq(result)
    end
  end
end
