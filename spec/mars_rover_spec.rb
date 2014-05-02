require 'spec_helper'

module Mars
  describe RoverGroup do
    subject { RoverGroup.new }

    describe "Validations" do
      it "needs integers as grid dimensions" do
        expect { subject.walk("5.5 4.2") }.to raise_error(BadGrid)
      end

      it "refuses coordinates greater than 50" do
        expect { subject.walk("55 10") }.to raise_error(BadGrid)
      end

      it "refuses coordinates less than 0" do # Extra validation free of charge
        expect { subject.walk("-5 10") }.to raise_error(BadGrid)
      end

      it "refuses instruction strings with more than 100 characters" do
        turns = "10 10\n5 5 N\n" + 'L' * 101
        expect { subject.walk(turns) }.to raise_error(TooManyInstructions)
      end

      # Other types of errors: ArgumentError if bad grid dimensions
    end

    describe "#execution" do
      it "executes the instruction strings" do
        instructions = "5 3\n1 1 E\nRFRFRFRF\n3 2 N\nFRRFLLFFRRFLL\n0 3 W\nLLFFFLFLFL"
        positions = subject.walk(instructions)
        positions.should == "1 1 E\n3 3 N LOST\n2 3 S\n"
      end
    end
  end
end
