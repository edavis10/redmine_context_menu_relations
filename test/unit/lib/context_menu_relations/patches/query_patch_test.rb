require 'test_helper'

class QueryTest < ActiveSupport::TestCase

  context "#available_columns" do
    should "include the formatted relations" do
      assert Query.available_columns.collect(&:name).include?(:formatted_relations)
    end
  end
end
