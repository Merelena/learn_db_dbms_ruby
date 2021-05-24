require 'sequel'
require 'time'

class DatabaseController < ApplicationController
  before_action :authenticate_user_from_token!, except: [:request_block]
  OPEN_TRANSACTION = ' BEGIN; SAVEPOINT savepoint;'
  CLOSE_TRANSACTION =  'ROLLBACK TO SAVEPOINT savepoint;'
  ### Добавь проверку итоговых запросов на наличие запрещенных таблиц!!!
  def request_block
    @requests = requests
    @responses = {}
    @timestamp = "t#{(Time.now.to_f * 1000).to_i}_"
    @sql = ActiveRecord::Base.establish_connection({
      :adapter  => "postgresql",
      :host     => "localhost",
      :username => "postgres",
      :password => "0248",
      :database => "user"}).connection
    @sql.execute(OPEN_TRANSACTION)
    @requests.each { |request| break if make(request).include?("No rights") }
    @sql.execute(CLOSE_TRANSACTION)
    render json: { type: "success", response: @responses}, status: 200      
  end

  private
  def requests
    (params.require(:request_block))
      .gsub(/\n/, '')
      .split(/;\s*/)
      .select{|b| !b.empty?}
  end

  def make(request)
    result_request = "#{parse(request)}"
    #return unless result_request
    begin
      response = @sql.execute(result_request) 
      response = 'OK' if response.nil? || response.to_a.empty?
    rescue StandardError => e
      response = e.inspect.gsub(@timestamp, '')[/ОШИБКА.+/]
    end
    result_response = []
    response.to_a.each do |r|
      result_response << r.transform_keys { |k| k.gsub(@timestamp, '')}
    end unless response.class == String

    @responses[request.gsub(@timestamp, '')] = result_response.empty? ? response : result_response
  end

  def parse(request)
    result = request.split(/[\s\.\(\)\[\]]/).select { |r| r =~ /\w*[a-z]+\w*/ && r.first != "\\"}
    result.each do |word|
      request.gsub!(word, @timestamp + word)
    end
    request
  end
end
