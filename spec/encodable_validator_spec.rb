require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'rspec'

module ActiveModel

  module Validations

    describe "EncodableValidator" do
      before do
        TestRecord.reset_callbacks(:validate)
      end

      describe ".validates" do

        it "checks validity of the arguments" do
          [Encoding::ASCII, nil, ["utf-8", "euc-jp"]].each do |wrong_argument|
            expect {
              TestRecord.validates :target_text, :encodable => { :encodings => wrong_argument }
            }.to raise_error(ArgumentError, ":encodings must be a array of Encodings")
          end
        end

        context "passed UTF_8 encoded text that is not encodable ISO_2022_JP" do
          before do
            TestRecord.validates :target_text, encodable: { encodings: [Encoding::ISO_2022_JP] }
          end

          ["\u2601", "\u2602", "\u2603", "\u2604"].each do |char|
            it "invalid" do
              sut = TestRecord.new(char)
              sut.should be_invalid
              sut.errors[:target_text].should == ["can not encode to #{Encoding::ISO_2022_JP}"]
            end
          end
        end

        context "passed empty object" do
          context 'allow_nil' do
            before do
              TestRecord.validates :target_text, :encodable => { :encodings => [Encoding::ASCII] }, :allow_nil => true
            end

            it "valid" do
              sut = TestRecord.new(nil)
              sut.should be_valid
            end
          end

          context 'not allow_nil' do
            before do
              TestRecord.validates :target_text, :encodable => { :encodings => [Encoding::ASCII] }, :allow_nil => false
            end

            it "invalid" do
              sut = TestRecord.new(nil)
              sut.should be_invalid
              sut.errors[:target_text].should == ["is not encodable object"]
            end
          end
        end
      end

    end

    # TODO refuctor duplicated test codes
    describe "work with helper method" do
      before do
        TestRecord.reset_callbacks(:validate)
        TestRecord.validates_encodable_of :target_text, :encodings => [Encoding::ISO_2022_JP]
      end

      context "passed UTF_8 encoded text that is not encodable ISO_2022_JP" do
        ["\u2601", "\u2602", "\u2603", "\u2604"].each do |char|
          it "invalid" do
            sut = TestRecord.new(char)
            sut.should be_invalid
            sut.errors[:target_text].should == ["can not encode to #{Encoding::ISO_2022_JP}"]
          end
        end
      end

      context "passed UTF_8 encoded text that is encodable ISO_2022_JP" do
        ["\u3041", "\u3042", "\u3043", "\u3044"].each do |char|
          it "valid" do
            sut = TestRecord.new(char)
            sut.should be_valid
          end
        end
      end
    end

  end

end
