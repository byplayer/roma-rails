class TestController < ApplicationController
  def test
    render :text => 'test'
  end

  def test2
    v = nil

    roma_client do |c|
      v = c.get('test')
    end

    render :text => "test:#{v}"
  end
end
