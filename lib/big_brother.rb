require 'sinatra/base'
require 'sinatra/synchrony'

require 'big_brother/app'
require 'big_brother/cluster'
require 'big_brother/ticker'
require 'big_brother/version'

module BigBrother
  def self.clusters
    @clusters ||= {}
  end
end