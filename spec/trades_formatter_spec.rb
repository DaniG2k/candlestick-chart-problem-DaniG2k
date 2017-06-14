require 'spec_helper'
require 'csv'

RSpec.describe TradesFormatter do
  before :each do
    @input_csv = CSV.read('./spec/tester.csv')
  end

  context '#initialize' do
    it 'takes a csv file and input window' do
      window = 30
      tf = TradesFormatter.new(@input_csv, window)

      expect(tf.input_csv). to eq(@input_csv)
      expect(tf.window_size).to eq(window)
    end
  end

  context '#get_windows' do
    it 'returns data for a given window' do
      # Within a day of each other
      window = 86400

      result = {
        [1378189897, 1378276296] => [
          [
            "1378189897",
            "160000.000000000000",
            "0.100000000000"
          ],
          [
            "1378224414",
            "150000.000000000000",
            "0.200000000000"
          ],
          [
            "1378254765",
            "180000.000000000000",
            "2.940000000000"
          ],
          [
            "1378271222",
            "180000.000000000000",
            "0.500000000000"
          ]
        ],
        [1378276297, 1378362696] => [
          [
            "1378343798",
            "150000.000000000000",
            "0.100000000000"
          ]
        ],
        [1378362697, 1378449096] => [
          [
            "1378367663",
            "150000.000000000000",
            "0.537000000000"
          ],
          [
            "1378380529",
            "150000.000000000000",
            "0.463000000000"
          ],
          [
            "1378381752",
            "160000.000000000000",
            "0.300000000000"
          ],
          [
            "1378441918",
            "145000.000000000000",
            "0.200000000000"
          ]
        ],
        [1378449097, 1378535496] => [
          [
            "1378514669",
            "145000.000000000000",
            "0.100000000000"
          ],
          [
            "1378514709",
            "140000.000000000000",
            "0.100000000000"
          ]
        ],
        [1378535497, 1378621896] => [
          [
            "1378552766",
            "140000.000000000000",
            "0.200000000000"
          ],
          [
            "1378613808",
            "141000.000000000000",
            "0.400000000000"
          ]
        ],
        [1378621897, 1378647310] => [
          [
            "1378627740",
            "160000.000000000000",
            "0.200000000000"
          ],
          [
            "1378647310",
            "146000.000000000000",
            "0.200000000000"
          ]
        ]
      }

      tf = TradesFormatter.new(@input_csv, window)

      expect(tf.get_windows).to eq(result)
    end

    it 'retuns an expected result' do
      input_csv = CSV.read('./spec/tester_2.csv')
      window = 30
      tf = TradesFormatter.new(input_csv, window)
      result = {
        [1383038122, 1383038151]=>[["1383038122", "250000", "2.00000000"]],
        [1383038152, 1383038181]=>[["1383038169", "254000", "0.09700000"], ["1383038169", "259000", "1.90300000"]],
        [1383038182, 1383038211]=>[],
        [1383038212, 1383038233]=>[["1383038233", "251000", "1.39100000"]]}

      expect(tf.get_windows).to eq(result)
    end
  end

  context '#output' do
    it 'returns an array of hashes with the desired values' do
      window = 86400
      tf = TradesFormatter.new(@input_csv, window)

      result = [
        {
          "open" => "160000",
          "close" => "180000",
          "high" => "180000",
          "low" => "150000",
          "start" => 1378189897,
          "end" => 1378276296,
          "average" => "167500"
        },
        {
          "open" => "150000",
          "close" => "150000",
          "high" => "150000",
          "low" => "150000",
          "start" => 1378276297,
          "end" => 1378362696,
          "average" => "150000"
        },
        {
          "open" => "150000",
          "close" => "145000",
          "high" => "160000",
          "low" => "145000",
          "start" => 1378362697,
          "end" => 1378449096,
          "average" => "151250"
        },
        {
          "open" => "145000",
          "close" => "140000",
          "high" => "145000",
          "low" => "140000",
          "start" => 1378449097,
          "end" => 1378535496,
          "average" => "142500"
        },
        {
          "open" => "140000",
          "close" => "141000",
          "high" => "141000",
          "low" => "140000",
          "start" => 1378535497,
          "end" => 1378621896,
          "average" => "140500"
        },
        {
          "open" => "160000",
          "close" => "146000",
          "high" => "160000",
          "low" => "146000",
          "start" => 1378621897,
          "end" => 1378647310,
          "average" => "153000"
        }
      ]

      expect(tf.output).to eq(result)
    end

    it 'retuns an expected result' do
      input_csv = CSV.read('./spec/tester_2.csv')
      window = 30
      tf = TradesFormatter.new(input_csv, window)
      result = [
        {"open"=>"250000",
         "close"=>"250000",
         "high"=>"250000",
         "low"=>"250000",
         "start"=>1383038122,
         "end"=>1383038151,
         "average"=>"250000"},
        {"open"=>"254000",
         "close"=>"259000",
         "high"=>"259000",
         "low"=>"254000",
         "start"=>1383038152,
         "end"=>1383038181,
         "average"=>"256500"},
        {"open"=>nil,
         "close"=>nil,
         "high"=>nil,
         "low"=>nil,
         "start"=>1383038182,
         "end"=>1383038211,
         "average"=>nil},
        {"open"=>"251000",
         "close"=>"251000",
         "high"=>"251000",
         "low"=>"251000",
         "start"=>1383038212,
         "end"=>1383038233,
         "average"=>"251000"}
       ]

      expect(tf.output).to eq(result)
    end
  end
end
